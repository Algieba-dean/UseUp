import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../localization/app_localizations.dart';
import '../../models/location.dart';
import '../../models/item.dart';
import '../../../main.dart'; 
import '../../config/theme.dart';

class LocationSelector extends StatefulWidget {
  final Function(Location) onSelected;

  const LocationSelector({super.key, required this.onSelected});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  int? _currentParentId;
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

    if (mounted) {
      setState(() {
        _locations = locs;
      });
    }
  }

  void _enterLevel(Location loc) {
    if (loc.level < 2) {
      setState(() {
        _currentParentId = loc.id;
      });
      _loadLocations();
    }
  }

  void _goBack() async {
    if (_currentParentLocation != null) {
      setState(() {
        _currentParentId = _currentParentLocation!.parentId;
      });
      _loadLocations();
    }
  }

  void _addLocation() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.locationAdd),
        content: TextField(
          controller: controller, 
          decoration: InputDecoration(hintText: l10n.locationName),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final newLoc = Location(
                  name: controller.text,
                  parentId: _currentParentId,
                  level: (_currentParentLocation?.level ?? -1) + 1,
                );
                await isarInstance.writeTxn(() async => await isarInstance.locations.put(newLoc));
                _loadLocations();
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          )
        ],
      ),
    );
  }

  void _deleteLocation(Location loc) async {
     final l10n = AppLocalizations.of(context)!;
     final hasChildren = await isarInstance.locations.filter().parentIdEqualTo(loc.id).count() > 0;
     final hasItems = await isarInstance.items.filter().locationLink((q) => q.idEqualTo(loc.id)).count() > 0;

    if (hasChildren || hasItems) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.deleteConfirm), backgroundColor: Colors.red));
      }
      return;
    }
    await isarInstance.writeTxn(() async => await isarInstance.locations.delete(loc.id));
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部灰色小横条 (Drag Handle)
          Center(
            child: Container(
              width: 40, 
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // 顶部导航栏
          Row(
            children: [
              if (_currentParentId != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: _goBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (_currentParentId != null) const SizedBox(width: 12),
              
              Text(
                _currentParentLocation?.name ?? l10n.locationSelect,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: _addLocation,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          
          Expanded(
            child: _locations.isEmpty
                ? Center(child: Text('No locations yet', style: TextStyle(color: Colors.grey[400])))
                : ListView.separated(
                    itemCount: _locations.length,
                    separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) {
                      final loc = _locations[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        title: Text(
                          loc.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 30),
                              onPressed: () {
                                widget.onSelected(loc);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, size: 22, color: Colors.red[200]),
                              onPressed: () => _deleteLocation(loc),
                            ),
                            if (loc.level < 2) 
                              IconButton(
                                icon: const Icon(Icons.chevron_right, color: Colors.grey),
                                onPressed: () {
                                  _enterLevel(loc);
                                },
                              ),
                          ],
                        ),
                        onTap: () {
                          if (loc.level < 2) {
                            _enterLevel(loc);
                          } else {
                            widget.onSelected(loc);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}