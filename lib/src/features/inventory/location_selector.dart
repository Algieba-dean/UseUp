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

  const LocationSelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
  });

  @override
  ConsumerState<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends ConsumerState<LocationSelector> {
  Id? _currentParentId;
  List<Location> _locations = [];
  Location? _currentParentLocation;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadLocations());
  }

  Future<void> _loadLocations() async {
    final isar = ref.read(databaseProvider);
    final locs = await isar.locations.filter().parentIdEqualTo(_currentParentId).findAll();
    if (_currentParentId != null) {
      _currentParentLocation = await isar.locations.get(_currentParentId!);
    } else {
      _currentParentLocation = null;
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

  void _enterLevel(Location loc) {
    if (loc.level < 2) {
      HapticFeedback.selectionClick();
      setState(() => _currentParentId = loc.id);
      _loadLocations();
    }
  }

  void _goBack() {
    if (_currentParentLocation != null) {
      HapticFeedback.selectionClick();
      setState(() => _currentParentId = _currentParentLocation!.parentId);
      _loadLocations();
    }
  }

  void _handleSelection(Location loc) {
    if (widget.onSelected != null) {
      HapticFeedback.mediumImpact();
      widget.onSelected!(loc);
    }
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
            content: TextField(
              controller: controller, 
              autofocus: true,
              decoration: InputDecoration(hintText: l10n.name, errorText: errorText),
              onChanged: (_) { if (errorText != null) setState(() => errorText = null); },
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
              TextButton(onPressed: () async {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  if (await _checkDuplicate(name, _currentParentId)) {
                     HapticFeedback.heavyImpact();
                     setState(() => errorText = l10n.errorNameExists);
                     return;
                  }
                  HapticFeedback.lightImpact();
                  final isar = ref.read(databaseProvider);
                  final newLoc = Location(name: name, parentId: _currentParentId, level: (_currentParentLocation?.level ?? -1) + 1);
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
    final title = _currentParentLocation != null ? LocalizedUtils.getLocalizedName(context, _currentParentLocation!.name) : (widget.isManageMode ? l10n.manageLocations : l10n.locationSelect);
    return Container(
      height: 550, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(children: [
        Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
        Row(children: [
          if (_currentParentId != null) IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: _goBack),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(), IconButton(onPressed: _addLocation, icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 36)),
        ]),
        const SizedBox(height: 16),
        Expanded(child: _locations.isEmpty ? Center(child: Text(l10n.emptyList, style: TextStyle(color: Colors.grey[400]))) : ListView.separated(
          itemCount: _locations.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
          itemBuilder: (ctx, i) {
            final l = _locations[i];
            final deep = l.level < 2;
            return ListTile(
              onTap: () => deepTap(l, deep),
              leading: Icon(deep ? Icons.grid_view : Icons.place_outlined, color: Colors.grey[600], size: 24),
              title: Text(LocalizedUtils.getLocalizedName(context, l.name), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (widget.isManageMode) ...[
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _editLocation(l)),
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteLocation(l))
                ] else ...[
                  IconButton(onPressed: () => _handleSelection(l), icon: Icon(Icons.radio_button_unchecked, color: Colors.grey[400], size: 28)),
                ],
                if (deep) Icon(Icons.chevron_right, color: Colors.grey[400]),
              ]),
            );
          },
        )),
      ]),
    );
  }

  void deepTap(Location loc, bool canGoDeeper) {
    if (canGoDeeper) {
      _enterLevel(loc);
    } else {
      if (!widget.isManageMode) {
        _handleSelection(loc);
      }
    }
  }
}