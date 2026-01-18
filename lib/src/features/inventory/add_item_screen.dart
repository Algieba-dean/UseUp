import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/item.dart';
import '../../models/category.dart';
import '../../models/location.dart';
import '../../../main.dart';
import 'category_selector.dart';
import 'location_selector.dart';
import 'widgets/date_input_field.dart';

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
  
  String _selectedUnit = 'pcs'; 
  final List<String> _units = ['pcs', 'kg', 'g', 'L', 'ml', 'pack'];

  Category? _selectedCategoryObj;
  String _categoryNameDisplay = "";
  
  Location? _selectedLocationObj;
  String _locationNameDisplay = "";
  
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    final item = widget.itemToEdit;

    if (item != null) {
      _nameController = TextEditingController(text: item.name);
      _quantityController = TextEditingController(
          text: item.quantity % 1 == 0 
              ? item.quantity.toInt().toString() 
              : item.quantity.toString());
      _selectedUnit = item.unit;
      
      _categoryNameDisplay = item.categoryName;
      _locationNameDisplay = item.locationName;
      // Note: Direct object assignment might need fresh fetch if object not loaded, 
      // but assuming item comes from ISAR watch, links should be available or we rely on names.
      // Ideally we check if link is loaded.
      _selectedCategoryObj = item.categoryLink.value;
      _selectedLocationObj = item.locationLink.value;
      
      _expiryDate = item.expiryDate;
    } else {
      _nameController = TextEditingController();
      _quantityController = TextEditingController(text: '1');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // 获取翻译后的单位
  String _getLocalizedUnit(String key, AppLocalizations l10n) {
    switch (key) {
      case 'pcs': return l10n.unitPcs;
      case 'kg': return l10n.unitKg;
      case 'g': return l10n.unitG;
      case 'L': return l10n.unitL;
      case 'ml': return l10n.unitMl;
      case 'pack': return l10n.unitPack;
      default: return key;
    }
  }

  Future<void> _saveItem() async {
      if (_formKey.currentState!.validate()) {
          final name = _nameController.text;
          final quantity = double.tryParse(_quantityController.text) ?? 1.0;

          await isarInstance.writeTxn(() async {
            Item itemToSave;

            if (widget.itemToEdit != null) {
              // Edit Mode
              itemToSave = widget.itemToEdit!;
              itemToSave.name = name;
              itemToSave.quantity = quantity;
              itemToSave.unit = _selectedUnit;
              itemToSave.expiryDate = _expiryDate;
              // preserve purchaseDate or update if needed
            } else {
              // Create Mode
              itemToSave = Item(
                name: name,
                quantity: quantity,
                unit: _selectedUnit,
                purchaseDate: DateTime.now(),
                expiryDate: _expiryDate,
              );
            }

            // Update common fields
            itemToSave.categoryName = _categoryNameDisplay.isEmpty ? 'Unknown' : _categoryNameDisplay;
            itemToSave.locationName = _locationNameDisplay.isEmpty ? 'Unknown' : _locationNameDisplay;
            
            // Update Links
            // Note: assign value only if selected, otherwise it might clear existing link if null?
            // Logic: if user selected something, update. If user didn't touch it, 
            // in edit mode: _selectedCategoryObj is init from item.categoryLink.value, so it preserves.
            // in add mode: it's null.
            itemToSave.categoryLink.value = _selectedCategoryObj;
            itemToSave.locationLink.value = _selectedLocationObj;

            await isarInstance.items.put(itemToSave);
            await itemToSave.categoryLink.save();
            await itemToSave.locationLink.save();
          });
          
          if(mounted) {
             context.pop();
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('${name} Saved!')),
             );
          }
      }
  }

  // --- 新的 UI 构建方法 ---

  // 通用输入框样式 (卡片式)
  Widget _buildCardInput({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  // 选择器触发按钮 (高亮逻辑)
  Widget _buildSelectorTrigger({
    required String label,
    required String value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final hasValue = value.isNotEmpty;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // 选中后边框变绿，增强反馈
          border: hasValue ? Border.all(color: AppTheme.primaryGreen, width: 1.5) : null,
          boxShadow: [
             BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // 图标颜色变化
            Icon(icon, color: hasValue ? AppTheme.primaryGreen : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: hasValue ? AppTheme.primaryGreen : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasValue ? value : "Tap to select",
                    style: TextStyle(
                      fontSize: 16,
                      // 选中后字体加粗、变黑
                      fontWeight: hasValue ? FontWeight.bold : FontWeight.normal,
                      color: hasValue ? Colors.black : Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: hasValue ? AppTheme.primaryGreen : Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = widget.itemToEdit != null ? "Edit Item" : l10n.addItem;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // 浅灰背景，突显白色卡片
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _saveItem,
            child: Text(l10n.save, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1. Name Input
            _buildCardInput(
              child: TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: l10n.name,
                  prefixIcon: const Icon(Icons.edit_outlined),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a name';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),

            // 2. Quantity Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildCardInput(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.quantity,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildCardInput(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      ),
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(_getLocalizedUnit(u, l10n)))).toList(),
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 分割线标题
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text("Details", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
            ),

            // 3. Category
            _buildSelectorTrigger(
              label: l10n.category,
              value: _categoryNameDisplay,
              icon: Icons.category_outlined,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent, // 后面做圆角
                  builder: (ctx) => CategorySelector(
                    onSelected: (cat) {
                      setState(() {
                        _selectedCategoryObj = cat;
                        _categoryNameDisplay = cat.name;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // 4. Location
            _buildSelectorTrigger(
              label: l10n.location,
              value: _locationNameDisplay,
              icon: Icons.kitchen_outlined,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder: (ctx) => LocationSelector(
                    onSelected: (loc) {
                      setState(() {
                        _selectedLocationObj = loc;
                        _locationNameDisplay = loc.name;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // 5. Date
            DateInputField(
              label: l10n.expiryDate,
              initialDate: _expiryDate,
              onDateChanged: (date) => _expiryDate = date,
            ),
            
            // 底部留白，方便滚动
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
