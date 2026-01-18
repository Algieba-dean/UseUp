import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../models/location.dart';
import '../../models/item.dart';
import '../../../main.dart'; 
import '../../config/theme.dart';
import '../../utils/localized_utils.dart';

class LocationSelector extends StatefulWidget {
  final Function(Location)? onSelected;
  final bool isManageMode;

  const LocationSelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  Id? _currentParentId;
  List<Location> _locations = [];
  Location? _currentParentLocation;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final locs = await isarInstance.locations
        .filter()
        .parentIdEqualTo(_currentParentId)
        .findAll();
    
    if (_currentParentId != null) {
      _currentParentLocation = await isarInstance.locations.get(_currentParentId!);
    } else {
      _currentParentLocation = null;
    }

    setState(() {
      _locations = locs;
    });
  }

  void _enterLevel(Location loc) {
    if (loc.level < 2) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentParentId = loc.id;
      });
      _loadLocations();
    }
  }

  void _goBack() async {
    if (_currentParentLocation != null) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentParentId = _currentParentLocation!.parentId;
      });
      _loadLocations();
    }
  }

  void _handleSelection(Location loc) async {
    if (widget.onSelected != null) {
      await HapticFeedback.mediumImpact();
      widget.onSelected!(loc);
    }
  }

  void _addLocation() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isManageMode ? l10n.locationAddSub : l10n.locationAdd),
        content: TextField(
          controller: controller, 
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                HapticFeedback.lightImpact();
                final newLoc = Location(
                  name: controller.text,
                  parentId: _currentParentId,
                  level: (_currentParentLocation?.level ?? -1) + 1,
                );
                await isarInstance.writeTxn(() async => await isarInstance.locations.put(newLoc));
                _loadLocations();
                if(mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          )
        ],
      ),
    );
  }

  void _editLocation(Location loc) {
    final controller = TextEditingController(text: loc.name);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationRename),
        content: TextField(
          controller: controller, 
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty && controller.text != loc.name) {
                await isarInstance.writeTxn(() async {
                  loc.name = controller.text;
                  await isarInstance.locations.put(loc);
                  
                  final items = await isarInstance.items.filter().locationLink((q) => q.idEqualTo(loc.id)).findAll();
                  for (var item in items) {
                    item.locationName = loc.name;
                    await isarInstance.items.put(item);
                  }
                });
                _loadLocations();
                if(mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _deleteLocation(Location loc) async {
     final l10n = AppLocalizations.of(context)!;

     final hasChildren = await isarInstance.locations.filter().parentIdEqualTo(loc.id).count() > 0;
     if (hasChildren) {
       HapticFeedback.heavyImpact();
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text(l10n.containsSubItems), 
           backgroundColor: Colors.red
         ));
       }
       return;
     }

     final relatedItemsCount = await isarInstance.items.filter().locationLink((q) => q.idEqualTo(loc.id)).count();
     
     if (relatedItemsCount > 0) {
       _showMoveAndDeleteDialog(loc, relatedItemsCount);
     } else {
       _confirmDeleteEmpty(loc);
     }
  }

  void _confirmDeleteEmpty(Location loc) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationDeleteTitle),
        content: Text(l10n.deleteEmptyConfirm),
        actions: [
           TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
           TextButton(
             style: TextButton.styleFrom(foregroundColor: Colors.red),
             onPressed: () async {
               await isarInstance.writeTxn(() async => await isarInstance.locations.delete(loc.id));
               _loadLocations();
               if(mounted) Navigator.pop(ctx);
             }, 
             child: Text(l10n.delete)
           ),
        ],
      ),
    );
  }

  void _showMoveAndDeleteDialog(Location loc, int count) {
    final l10n = AppLocalizations.of(context)!;
    final targetName = LocalizedUtils.getLocalizedName(context, 'Other');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationDeleteTitle),
        content: Text(l10n.deleteMoveConfirm(count, targetName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await _performMoveAndDelete(loc);
              if(mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.confirmAndMove),
          ),
        ],
      ),
    );
  }

  Future<void> _performMoveAndDelete(Location loc) async {
    final l10n = AppLocalizations.of(context)!;
    var defaultLoc = await isarInstance.locations.filter().nameEqualTo('其他').findFirst();
    if (defaultLoc == null) {
      defaultLoc = await isarInstance.locations.filter().nameEqualTo('Other').findFirst();
    }
    
    if (defaultLoc == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorDefaultNotFound('Other'))));
      return;
    }

    if (defaultLoc.id == loc.id) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cannotDeleteDefault)));
       return;
    }

    await isarInstance.writeTxn(() async {
      final items = await isarInstance.items.filter().locationLink((q) => q.idEqualTo(loc.id)).findAll();
      for (var item in items) {
        item.locationLink.value = defaultLoc;
        item.locationName = defaultLoc!.name;
        await item.locationLink.save();
        await isarInstance.items.put(item);
      }
      await isarInstance.locations.delete(loc.id);
    });

    HapticFeedback.mediumImpact();
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final parentName = _currentParentLocation == null 
        ? null 
        : LocalizedUtils.getLocalizedName(context, _currentParentLocation!.name);

    final title = parentName ?? (widget.isManageMode ? l10n.manageLocations : l10n.locationSelect);

    return Container(
      height: 550,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          Row(
            children: [
              if (_currentParentId != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: _goBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (_currentParentId != null) const SizedBox(width: 16),
              
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: _addLocation,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 36),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _locations.isEmpty
                ? Center(child: Text(l10n.emptyList, style: TextStyle(color: Colors.grey[400])))
                : ListView.separated(
                    itemCount: _locations.length,
                    separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) {
                      final loc = _locations[index];
                      final canGoDeeper = loc.level < 2;
                      final displayName = LocalizedUtils.getLocalizedName(context, loc.name);

                      return InkWell(
                        onTap: () {
                          if (canGoDeeper) {
                            _enterLevel(loc);
                          } else {
                            if (!widget.isManageMode) {
                              _handleSelection(loc);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Row(
                            children: [
                              Icon(
                                canGoDeeper ? Icons.grid_view : Icons.place_outlined, 
                                color: Colors.grey[600],
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(displayName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.isManageMode) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                      onPressed: () => _editLocation(loc),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                                      onPressed: () => _deleteLocation(loc),
                                    ),
                                  ] else ...[
                                    IconButton(
                                      onPressed: () => _handleSelection(loc),
                                      icon: Icon(Icons.radio_button_unchecked, color: Colors.grey[400], size: 28),
                                    ),
                                  ],
                                  if (canGoDeeper)
                                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
