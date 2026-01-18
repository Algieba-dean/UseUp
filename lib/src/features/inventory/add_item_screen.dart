import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:use_up/src/localization/app_localizations.dart';

import '../../config/theme.dart';
import '../../models/item.dart';
import '../../models/category.dart';
import '../../models/location.dart';
import '../../../main.dart';
import '../../services/notification_service.dart';
import '../../utils/localized_utils.dart'; // Import LocalizedUtils
import 'category_selector.dart';
import 'location_selector.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  final Item? itemToEdit;
  const AddItemScreen({super.key, this.itemToEdit});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _shelfLifeController;

  String _selectedUnit = 'pcs';
  // Use keys for logic, display names will be localized
  final List<String> _unitKeys = ['pcs', 'kg', 'g', 'L', 'ml', 'pack', 'box'];

  Category? _selectedCategoryObj;
  String _categoryNameDisplay = "";
  
  Location? _selectedLocationObj;
  String _locationNameDisplay = "Other"; 

  DateTime? _expiryDate;
  DateTime _purchaseDate = DateTime.now();
  DateTime? _productionDate;
  
  List<int> _selectedNotifyDays = [1, 3]; 
  String? _imagePath;
  
  bool _isProductionMode = false; 

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initData();
    if (widget.itemToEdit == null) {
      _loadDefaultSelections();
    }
  }

  Future<void> _loadDefaultSelections() async {
    var defaultLoc = await isarInstance.locations
        .filter()
        .nameEqualTo('其他')
        .findFirst();
    if (defaultLoc == null) {
      defaultLoc = await isarInstance.locations
          .filter()
          .nameEqualTo('Other')
          .findFirst();
    }

    var defaultCat = await isarInstance.categorys
        .filter()
        .nameEqualTo('杂物')
        .findFirst();
    if (defaultCat == null) {
      defaultCat = await isarInstance.categorys
          .filter()
          .nameEqualTo('Misc')
          .findFirst();
    }

    if (mounted) {
      setState(() {
        if (defaultLoc != null) {
          _selectedLocationObj = defaultLoc;
          _locationNameDisplay = defaultLoc.name;
        }
        if (defaultCat != null) {
          _selectedCategoryObj = defaultCat;
          _categoryNameDisplay = defaultCat.name;
        }
      });
    }
  }

  void _initData() {
    final item = widget.itemToEdit;
    if (item != null) {
      _nameController = TextEditingController(text: item.name);
      _quantityController = TextEditingController(
          text: item.quantity % 1 == 0 ? item.quantity.toInt().toString() : item.quantity.toString());
      _priceController = TextEditingController(text: item.price?.toString() ?? '');
      _shelfLifeController = TextEditingController(text: item.shelfLifeDays?.toString() ?? '');
      
      _selectedUnit = item.unit;
      _purchaseDate = item.purchaseDate;
      _expiryDate = item.expiryDate;
      _productionDate = item.productionDate;
      _selectedNotifyDays = List.from(item.notifyDaysList);
      
      _isProductionMode = item.productionDate != null;

      item.categoryLink.loadSync();
      _selectedCategoryObj = item.categoryLink.value;
      _categoryNameDisplay = item.categoryLink.value?.name ?? item.categoryName;
      
      item.locationLink.loadSync();
      _selectedLocationObj = item.locationLink.value;
      _locationNameDisplay = item.locationLink.value?.name ?? item.locationName;
      
      _imagePath = item.imagePath;
    } else {
      _nameController = TextEditingController();
      _quantityController = TextEditingController(text: '1');
      _priceController = TextEditingController();
      _shelfLifeController = TextEditingController();
      _locationNameDisplay = "Other"; 
      _categoryNameDisplay = "Misc";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _shelfLifeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
      if (pickedFile == null) return;
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(pickedFile.path);
      final String savedPath = '${directory.path}/$fileName';
      await File(pickedFile.path).copy(savedPath);
      setState(() => _imagePath = savedPath);
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
            ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
          ],
        ),
      ),
    );
  }

  void _calculateExpiryFromProduction() {
    if (_productionDate != null && _shelfLifeController.text.isNotEmpty) {
      final days = int.tryParse(_shelfLifeController.text);
      if (days != null) {
        setState(() {
          _expiryDate = _productionDate!.add(Duration(days: days));
        });
      }
    }
  }

  // 获取单位的本地化显示名称
  String _getUnitDisplayName(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'pcs': return l10n.unitPcs;
      case 'kg': return l10n.unitKg;
      case 'g': return l10n.unitG;
      case 'L': return l10n.unitL;
      case 'ml': return l10n.unitMl;
      case 'pack': return l10n.unitPack;
      case 'box': return l10n.unitBox;
      default: return key;
    }
  }

  Future<void> _saveItem({bool addNext = false}) async {
    if (_formKey.currentState!.validate()) {
      if (_expiryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please set an expiry date')));
        return;
      }

      final name = _nameController.text;
      final quantity = double.tryParse(_quantityController.text) ?? 1.0;
      final price = double.tryParse(_priceController.text);
      final shelfLife = int.tryParse(_shelfLifeController.text);

      Item itemToSave;
      if (widget.itemToEdit != null && !addNext) {
        itemToSave = widget.itemToEdit!;
        itemToSave.name = name;
        itemToSave.quantity = quantity;
        itemToSave.unit = _selectedUnit;
        itemToSave.price = price;
        itemToSave.purchaseDate = _purchaseDate;
        itemToSave.expiryDate = _expiryDate;
        itemToSave.productionDate = _isProductionMode ? _productionDate : null;
        itemToSave.shelfLifeDays = _isProductionMode ? shelfLife : null;
        itemToSave.notifyDaysList = _selectedNotifyDays;
        itemToSave.imagePath = _imagePath;
        itemToSave.categoryName = _categoryNameDisplay; 
        itemToSave.locationName = _locationNameDisplay;
      } else {
        itemToSave = Item(
          name: name,
          quantity: quantity,
          unit: _selectedUnit,
          price: price,
          purchaseDate: _purchaseDate,
          expiryDate: _expiryDate,
          productionDate: _isProductionMode ? _productionDate : null,
          shelfLifeDays: _isProductionMode ? shelfLife : null,
          notifyDaysList: _selectedNotifyDays,
          imagePath: _imagePath,
          categoryName: _categoryNameDisplay,
          locationName: _locationNameDisplay,
        );
      }
      
      itemToSave.categoryLink.value = _selectedCategoryObj;
      itemToSave.locationLink.value = _selectedLocationObj;

      await isarInstance.writeTxn(() async {
        await isarInstance.items.put(itemToSave);
        await itemToSave.categoryLink.save();
        await itemToSave.locationLink.save();
        await isarInstance.items.put(itemToSave);
      });
      
      try {
        await NotificationService().scheduleExpiryNotification(itemToSave);
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }

      if (mounted) {
        if (addNext) {
          HapticFeedback.mediumImpact(); 
          // 这里的提示也可以本地化，暂留
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"$name" saved! Ready for next.')));
          
          _nameController.clear();
          _priceController.clear();
          _shelfLifeController.clear();
          setState(() {
            _imagePath = null;
            _expiryDate = null;
            _productionDate = null;
          });
          FocusScope.of(context).unfocus();
        } else {
          context.pop();
        }
      }
    }
  }

  Widget _buildSection({required List<Widget> children, bool isAdvanced = false}) {
    final l10n = AppLocalizations.of(context)!;
    if (isAdvanced) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            // Localized Title & Subtitle
            title: Text(l10n.advancedDetails, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            subtitle: Text(l10n.advancedSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: children,
          ),
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.itemToEdit != null;
    String currency = Localizations.localeOf(context).languageCode == 'zh' ? '¥' : '\$';

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(isEditing ? l10n.editItem : l10n.addItem, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), 
          children: [
            Center(
              child: GestureDetector(
                onTap: _showImageSourceActionSheet,
                child: Container(
                  width: 100, height: 100,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image: _imagePath != null
                        ? DecorationImage(image: FileImage(File(_imagePath!)), fit: BoxFit.cover)
                        : null,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: _imagePath == null ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey[300]) : null,
                ),
              ),
            ),

            _buildSection(children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: "${l10n.name} *",
                  hintText: "e.g. Milk",
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.edit_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const Divider(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _buildModeTab(l10n.toggleExpiryDate, !_isProductionMode, () => setState(() => _isProductionMode = false)),
                    const SizedBox(width: 12),
                    _buildModeTab(l10n.toggleProductionDate, _isProductionMode, () => setState(() => _isProductionMode = true)),
                  ],
                ),
              ),

              if (!_isProductionMode)
                _buildDateRow(
                  label: "${l10n.expiryDate} *",
                  value: _expiryDate,
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: _expiryDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if (d != null) setState(() => _expiryDate = d);
                  },
                )
              else
                Column(
                  children: [
                    _buildDateRow(
                      label: l10n.productionDate,
                      value: _productionDate,
                      onTap: () async {
                        final d = await showDatePicker(context: context, initialDate: _productionDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                        if (d != null) {
                          setState(() => _productionDate = d);
                          _calculateExpiryFromProduction();
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _shelfLifeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: l10n.shelfLife, border: InputBorder.none),
                            onChanged: (_) => _calculateExpiryFromProduction(),
                          ),
                        ),
                      ],
                    ),
                    if (_expiryDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 36),
                        child: Text(l10n.calculatedExpiry(DateFormat('yyyy-MM-dd').format(_expiryDate!)), 
                          style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              
              const Divider(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_outlined, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(l10n.reminderLabel, style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildFilterChip(l10n.reminder1Day, 1),
                      _buildFilterChip(l10n.reminder3Days, 3),
                      _buildFilterChip(l10n.reminder7Days, 7),
                    ],
                  ),
                ],
              ),
            ]),

            _buildSection(isAdvanced: true, children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: l10n.quantity, border: InputBorder.none),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    underline: const SizedBox(),
                    // Use Localized Unit Display Name
                    items: _unitKeys.map((key) => DropdownMenuItem(
                      value: key, 
                      child: Text(_getUnitDisplayName(key))
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val!),
                  ),
                ],
              ),
              const Divider(),

              _buildSelectorRow(
                label: l10n.category, 
                // Localized display value
                value: _categoryNameDisplay.isEmpty 
                    ? "Unknown" 
                    : LocalizedUtils.getLocalizedName(context, _categoryNameDisplay),
                icon: Icons.category_outlined,
                onTap: () => showModalBottomSheet(
                  context: context, isScrollControlled: true, useSafeArea: true,
                  builder: (_) => CategorySelector(onSelected: (c) {
                    setState(() { _selectedCategoryObj = c; _categoryNameDisplay = c.name; });
                    Navigator.pop(context);
                  }),
                ),
              ),
              const Divider(),

              _buildSelectorRow(
                label: l10n.location, 
                // Localized display value
                value: _locationNameDisplay.isEmpty 
                    ? "Other" 
                    : LocalizedUtils.getLocalizedName(context, _locationNameDisplay),
                icon: Icons.kitchen_outlined,
                onTap: () => showModalBottomSheet(
                  context: context, isScrollControlled: true, useSafeArea: true,
                  builder: (_) => LocationSelector(onSelected: (l) {
                    setState(() { _selectedLocationObj = l; _locationNameDisplay = l.name; });
                    Navigator.pop(context);
                  }),
                ),
              ),
              const Divider(),

              _buildDateRow(
                label: l10n.purchaseDate, 
                value: _purchaseDate, 
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: _purchaseDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (d != null) setState(() => _purchaseDate = d);
                }
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.price, 
                        border: InputBorder.none,
                        prefixText: currency,
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))]),
        child: SafeArea(
          child: Row(
            children: [
              if (!isEditing)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _saveItem(addNext: true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(l10n.saveAndNext, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (!isEditing) const SizedBox(width: 12),
              
              Expanded(
                child: FilledButton(
                  onPressed: () => _saveItem(addNext: false),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEditing ? l10n.updateItem : l10n.save, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int days) {
    final isSelected = _selectedNotifyDays.contains(days);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            _selectedNotifyDays.add(days);
          } else {
            _selectedNotifyDays.remove(days);
          }
        });
      },
      selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryGreen,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryGreen : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildModeTab(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: isActive ? Border.all(color: AppTheme.primaryGreen) : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? AppTheme.primaryGreen : Colors.grey[600],
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateRow({required String label, required DateTime? value, required VoidCallback onTap}) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Colors.grey),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.black87)),
            const Spacer(),
            Text(
              value == null ? l10n.pickDate : DateFormat('yyyy-MM-dd').format(value),
              style: TextStyle(
                fontWeight: value == null ? FontWeight.normal : FontWeight.bold,
                color: value == null ? Colors.grey : AppTheme.primaryGreen,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorRow({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: Colors.black87)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
