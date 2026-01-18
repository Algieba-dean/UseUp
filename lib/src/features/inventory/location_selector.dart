import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:use_up/src/models/location.dart';
import 'package:use_up/main.dart';
import '../../config/theme.dart';
import '../../models/item.dart';

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
  List<Location> _currentLocations = [];
  Location? _parentLocation; 
  final TextEditingController _addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final parentId = _parentLocation?.id;
    List<Location> locs;
    if (parentId == null) {
      locs = await isarInstance.locations.filter().levelEqualTo(0).findAll();
    } else {
      locs = await isarInstance.locations.filter().parentIdEqualTo(parentId).findAll();
    }
    setState(() {
      _currentLocations = locs;
    });
  }

  Future<void> _addLocation() async {
    final name = _addController.text.trim();
    if (name.isEmpty) return;

    final newLoc = Location(
      name: name,
      level: _parentLocation == null ? 0 : (_parentLocation!.level + 1),
      parentId: _parentLocation?.id,
    );

    await isarInstance.writeTxn(() async {
      await isarInstance.locations.put(newLoc);
    });

    _addController.clear();
    _loadLocations();
  }

  // --- 【新增】重命名逻辑 ---
  void _editLocation(Location loc) {
    final controller = TextEditingController(text: loc.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Location'),
        content: TextField(
          controller: controller, 
          autofocus: true,
          decoration: const InputDecoration(labelText: "New Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty && controller.text != loc.name) {
                await _updateLocationName(loc, controller.text);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 同步更新 Item 表中的 locationName
  Future<void> _updateLocationName(Location loc, String newName) async {
    await isarInstance.writeTxn(() async {
      loc.name = newName;
      await isarInstance.locations.put(loc);

      final items = await isarInstance.items
          .filter()
          .locationLink((q) => q.idEqualTo(loc.id))
          .findAll();
      
      for (var item in items) {
        item.locationName = newName;
        await isarInstance.items.put(item);
      }
    });
    
    _loadLocations(); 
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated!')));
    }
  }

  Future<void> _deleteLocation(Location loc) async {
    // Check sub-locations
    final subCount = await isarInstance.locations.filter().parentIdEqualTo(loc.id).count();
    if (subCount > 0) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete: Has sub-locations.")));
      return;
    }
    
    // Check usage
    final itemCount = await isarInstance.items.filter().locationLink((q) => q.idEqualTo(loc.id)).count();
    if (itemCount > 0) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete: Items are stored here.")));
      return;
    }

    await isarInstance.writeTxn(() async {
      await isarInstance.locations.delete(loc.id);
    });
    _loadLocations();
  }

  void _enterLevel(Location loc) {
    setState(() {
      _parentLocation = loc;
    });
    _loadLocations();
  }

  void _goBackLevel() {
    if (_parentLocation == null) return;
    setState(() {
      _parentLocation = null; 
    });
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              if (_parentLocation != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBackLevel,
                ),
              Text(
                _parentLocation == null ? "Select Location" : _parentLocation!.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (widget.isManageMode)
                 const Chip(label: Text("Manage Mode"), backgroundColor: AppTheme.alertOrange)
            ],
          ),
          const Divider(),

          // Add New
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _addController,
                  decoration: const InputDecoration(
                    hintText: "New Location Name",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addLocation,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List
          Expanded(
            child: _currentLocations.isEmpty 
              ? const Center(child: Text("No locations here."))
              : ListView.separated(
                  itemCount: _currentLocations.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final loc = _currentLocations[i];
                    final canGoDeeper = (loc.parentId == null); 

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        if (widget.isManageMode) {
                          if (canGoDeeper) {
                            _enterLevel(loc);
                          } else {
                            _editLocation(loc);
                          }
                        } else {
                          if (canGoDeeper) {
                            _enterLevel(loc);
                          } else {
                            if (widget.onSelected != null) {
                               widget.onSelected!(loc);
                            }
                          }
                        }
                      },
                      leading: Icon(
                        canGoDeeper ? Icons.folder_open : Icons.place_outlined,
                        color: Colors.grey,
                      ),
                      title: Text(loc.name, style: const TextStyle(fontSize: 16)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isManageMode)
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                              onPressed: () => _editLocation(loc),
                            ),
                          
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            onPressed: () => _deleteLocation(loc),
                          ),
                          
                          if (canGoDeeper)
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                          else if (!widget.isManageMode)
                            const Icon(Icons.radio_button_unchecked, size: 20, color: Colors.grey),
                        ],
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
