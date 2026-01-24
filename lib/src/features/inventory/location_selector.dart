import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../models/location.dart';
import '../../models/item.dart';
import '../../config/theme.dart';
import '../../data/providers/database_provider.dart';
import '../../utils/localized_utils.dart';

class LocationSelector extends ConsumerStatefulWidget {
  final Function(Location)? onSelected;
  final bool isManageMode;
  final Id? parentId;
  final String? breadcrumbs;

  const LocationSelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
    this.parentId,
    this.breadcrumbs,
  });

  @override
  ConsumerState<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends ConsumerState<LocationSelector> {
  List<Location> _locations = [];
  Location? _currentParentLocation;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadLocations());
  }

  Future<void> _loadLocations() async {
    final isar = ref.read(databaseProvider);
    final locs = await isar.locations.filter().parentIdEqualTo(widget.parentId).findAll();
    if (widget.parentId != null) {
      _currentParentLocation = await isar.locations.get(widget.parentId!);
    }
    setState(() => _locations = locs);
  }

  Future<bool> _checkDuplicate(String name, Id? parentId, {Id? excludeId}) async {
    final isar = ref.read(databaseProvider);
    var query = isar.locations
        .filter()
        .parentIdEqualTo(parentId)
        .nameEqualTo(name, caseSensitive: false);
    if (excludeId != null) {
      query = query.not().idEqualTo(excludeId);
    }
    final count = await query.count();
    return count > 0;
  }

  void _enterLevel(Location loc) async {
    if (loc.level < 2) {
      HapticFeedback.selectionClick();
      final currentName = LocalizedUtils.getLocalizedName(context, loc.name);
      final newPath = widget.breadcrumbs == null 
          ? currentName 
          : '${widget.breadcrumbs} / $currentName';

      final result = await Navigator.push<Location>(
        context,
        MaterialPageRoute(
          builder: (ctx) => LocationSelector(
            isManageMode: widget.isManageMode,
            parentId: loc.id,
            breadcrumbs: newPath,
          ),
        ),
      );
      
      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  void _handleSelection(Location loc) {
    HapticFeedback.mediumImpact();
    Navigator.pop(context, loc);
  }

  void _addLocation() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    String? errorText;
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(widget.isManageMode ? l10n.locationAddSub : l10n.locationAdd),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.breadcrumbs != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "In: ${widget.breadcrumbs}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                  ),
                TextField(
                  controller: controller, 
                  autofocus: true,
                  decoration: InputDecoration(hintText: l10n.name, errorText: errorText),
                  onChanged: (_) { if (errorText != null) setState(() => errorText = null); },
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
              TextButton(onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  if (await _checkDuplicate(name, widget.parentId)) {
                     HapticFeedback.heavyImpact();
                     setState(() => errorText = l10n.errorNameExists);
                     return;
                  }
                  HapticFeedback.lightImpact();
                  final isar = ref.read(databaseProvider);
                  final newLoc = Location(
                    name: name, 
                    parentId: widget.parentId, 
                    level: (_currentParentLocation?.level ?? -1) + 1,
                  );
                  await isar.writeTxn(() async => await isar.locations.put(newLoc));
                  _loadLocations();
                  if(mounted) Navigator.pop(ctx);
                }
              }, child: Text(l10n.save)),
            ],
          );
        }
      ),
    );
  }

  void _editLocation(Location loc) {
    final controller = TextEditingController(text: loc.name);
    final l10n = AppLocalizations.of(context)!;
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.locationRename),
            content: TextField(
              controller: controller, 
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.name, errorText: errorText),
              onChanged: (_) { if (errorText != null) setState(() => errorText = null); },
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
              TextButton(onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty && name != loc.name) {
                  if (await _checkDuplicate(name, loc.parentId, excludeId: loc.id)) {
                     HapticFeedback.heavyImpact();
                     setState(() => errorText = l10n.errorNameExists);
                     return;
                  }
                  final isar = ref.read(databaseProvider);
                  await isar.writeTxn(() async {
                    loc.name = name;
                    await isar.locations.put(loc);
                    final items = await isar.items.filter().locationLink((q) => q.idEqualTo(loc.id)).findAll();
                    for (var item in items) {
                      item.locationName = name;
                      await isar.items.put(item);
                    }
                  });
                  _loadLocations();
                  if(mounted) Navigator.pop(ctx);
                }
              }, child: Text(l10n.save)),
            ],
          );
        }
      ),
    );
  }

  void _deleteLocation(Location loc) async {
     final l10n = AppLocalizations.of(context)!;
     final isar = ref.read(databaseProvider);
     if (await isar.locations.filter().parentIdEqualTo(loc.id).count() > 0) {
       HapticFeedback.heavyImpact();
       showDialog(context: context, builder: (ctx) => AlertDialog(
         title: Text(l10n.locationDeleteTitle), content: Text(l10n.containsSubItems),
         actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.confirm))],
       ));
       return;
     }
     final count = await isar.items.filter().locationLink((q) => q.idEqualTo(loc.id)).count();
     if (count > 0) _showMoveAndDeleteDialog(loc, count);
     else _confirmDeleteEmpty(loc);
  }

  void _confirmDeleteEmpty(Location loc) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.locationDeleteTitle), content: Text(l10n.deleteEmptyConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          await ref.read(databaseProvider).writeTxn(() async => await ref.read(databaseProvider).locations.delete(loc.id));
          _loadLocations();
          if(mounted) Navigator.pop(ctx);
        }, child: Text(l10n.delete, style: const TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _showMoveAndDeleteDialog(Location loc, int count) {
    final l10n = AppLocalizations.of(context)!;
    final target = LocalizedUtils.getLocalizedName(context, 'Other');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.locationDeleteTitle), content: Text(l10n.deleteMoveConfirm(count, target)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          await _performMoveAndDelete(loc);
          if(mounted) Navigator.pop(ctx);
        }, child: Text(l10n.confirmAndMove, style: const TextStyle(color: Colors.red))),
      ],
    ));
  }

  Future<void> _performMoveAndDelete(Location loc) async {
    final isar = ref.read(databaseProvider);
    final l10n = AppLocalizations.of(context)!;
    var defaultLoc = await isar.locations.filter().nameEqualTo('Other').findFirst();
    if (defaultLoc == null) {
       defaultLoc = await isar.locations.filter().nameEqualTo('其他').findFirst();
    }
    
    if (defaultLoc == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorDefaultNotFound('Other'))));
      return;
    }

    if (defaultLoc.id == loc.id) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cannotDeleteDefault)));
       return;
    }

    await isar.writeTxn(() async {
      final items = await isar.items.filter().locationLink((q) => q.idEqualTo(loc.id)).findAll();
      for (var item in items) {
        item.locationLink.value = defaultLoc;
        item.locationName = defaultLoc!.name;
        await item.locationLink.save();
        await isar.items.put(item);
      }
      await isar.locations.delete(loc.id);
    });

    HapticFeedback.mediumImpact();
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.breadcrumbs ?? (widget.isManageMode ? l10n.manageLocations : l10n.locationSelect);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _addLocation,
            icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 28),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _locations.isEmpty
          ? Center(child: Text(l10n.emptyList, style: TextStyle(color: Colors.grey[400])))
          : ListView.separated(
              itemCount: _locations.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
              itemBuilder: (ctx, i) {
                final l = _locations[i];
                final deep = l.level < 2;
                final displayName = LocalizedUtils.getLocalizedName(context, l.name);

                return ListTile(
                  onTap: () {
                    // 逻辑优化：有下一级就进入，否则根据模式决定动作
                    if (deep) {
                      _enterLevel(l);
                    } else {
                      if (widget.isManageMode) {
                        _editLocation(l);
                      } else {
                        _handleSelection(l);
                      }
                    }
                  },
                  leading: Icon(deep ? Icons.grid_view : Icons.place_outlined, color: Colors.grey[600], size: 24),
                  title: Text(displayName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (widget.isManageMode) ...[
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _editLocation(l)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteLocation(l)),
                    ] else ...[
                      IconButton(onPressed: () => _handleSelection(l), icon: const Icon(Icons.radio_button_unchecked, color: Colors.grey)),
                    ],
                    if (deep) Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ]),
                );
              },
            ),
    );
  }
}
