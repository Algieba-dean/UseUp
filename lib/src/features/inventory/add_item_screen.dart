import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 用于震动
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
  
  // --- Controllers ---
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController; // 新增：价格
  late TextEditingController _shelfLifeController; // 新增：保质期天数

  // --- State Variables ---
  String _selectedUnit = 'pcs';
  final List<String> _units = ['pcs', 'kg', 'g', 'L', 'ml', 'pack', 'box'];

  Category? _selectedCategoryObj;
  String _categoryNameDisplay = "";
  
  Location? _selectedLocationObj;
  String _locationNameDisplay = "Other"; // 默认显示 Other

  DateTime? _expiryDate;
  DateTime _purchaseDate = DateTime.now(); // 默认今天
  DateTime? _productionDate;
  
  int _notifyDays = 3; // 默认提前3天
  String? _imagePath;
  
  // 模式切换：直接输入过期日 OR 生产日期+保质期
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
    // 笨办法：分开查，确保不报错
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
      _notifyDays = item.notifyDaysBefore;
      
      _isProductionMode = item.productionDate != null; // 如果有生产日期，默认开启该模式

      // 关联加载
      item.categoryLink.loadSync();
      _selectedCategoryObj = item.categoryLink.value;
      _categoryNameDisplay = item.categoryLink.value?.name ?? item.categoryName;
      
      item.locationLink.loadSync();
      _selectedLocationObj = item.locationLink.value;
      _locationNameDisplay = item.locationLink.value?.name ?? item.locationName;
      
      _imagePath = item.imagePath;
    } else {
      // 新建默认值
      _nameController = TextEditingController();
      _quantityController = TextEditingController(text: '1'); // 默认 1
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

  // --- Logic: Image ---
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

  // --- Logic: Date Calculation ---
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

  // --- Logic: Save ---
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

      // Prepare item object (Outside transaction)
      Item itemToSave;
      if (widget.itemToEdit != null && !addNext) { // 编辑模式且不是"下一个"
        itemToSave = widget.itemToEdit!;
        itemToSave.name = name;
        itemToSave.quantity = quantity;
        itemToSave.unit = _selectedUnit;
        itemToSave.price = price;
        itemToSave.purchaseDate = _purchaseDate;
        itemToSave.expiryDate = _expiryDate;
        itemToSave.productionDate = _isProductionMode ? _productionDate : null;
        itemToSave.shelfLifeDays = _isProductionMode ? shelfLife : null;
        itemToSave.notifyDaysBefore = _notifyDays;
        itemToSave.imagePath = _imagePath;
        itemToSave.categoryName = _categoryNameDisplay; // Ensure strings updated
        itemToSave.locationName = _locationNameDisplay;
      } else {
        // 新建模式
        itemToSave = Item(
          name: name,
          quantity: quantity,
          unit: _selectedUnit,
          price: price,
          purchaseDate: _purchaseDate,
          expiryDate: _expiryDate,
          productionDate: _isProductionMode ? _productionDate : null,
          shelfLifeDays: _isProductionMode ? shelfLife : null,
          notifyDaysBefore: _notifyDays,
          imagePath: _imagePath,
          categoryName: _categoryNameDisplay,
          locationName: _locationNameDisplay,
        );
      }
      
      // Update link values
      itemToSave.categoryLink.value = _selectedCategoryObj;
      itemToSave.locationLink.value = _selectedLocationObj;

      await isarInstance.writeTxn(() async {
        // 存数据库
        await isarInstance.items.put(itemToSave);
        
        // 存 Links
        await itemToSave.categoryLink.save();
        await itemToSave.locationLink.save();
        
        // Save again to ensure consistency (optional but safe)
        await isarInstance.items.put(itemToSave);
      });
      
      // 设通知 (Outside transaction)
      try {
        await NotificationService().scheduleExpiryNotification(itemToSave);
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }

      if (mounted) {
        if (addNext) {
          // --- 连续添加逻辑 ---
          HapticFeedback.mediumImpact(); // 震动反馈
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"$name" saved! Ready for next.')));
          
          // 重置表单，保留部分习惯 (如分类、位置、购买日期可能是一样的)
          _nameController.clear();
          _priceController.clear();
          _shelfLifeController.clear();
          // _quantityController.text = '1'; // 保持默认
          setState(() {
            _imagePath = null;
            _expiryDate = null;
            _productionDate = null;
            // 保留 Category 和 Location，方便批量录入
          });
          // 滚动回顶部
          FocusScope.of(context).unfocus();
        } else {
          context.pop();
        }
      }
    }
  }

  // --- UI Widgets ---

  // 通用白色卡片背景
  Widget _buildSection({required List<Widget> children, bool isAdvanced = false}) {
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
            title: const Text("Advanced Details", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            subtitle: const Text("Quantity, Location, Price...", style: TextStyle(fontSize: 12, color: Colors.grey)),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: children,
          ),
        ),
      );
    }
    
    // Level 1 Section
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

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(isEditing ? "Edit Item" : l10n.addItem, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // 底部留出按钮空间
          children: [
            // 0. 图片区域 (保持不变，视觉重心)
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

            // --- Level 1: 核心信息 (Name, Expiry, Notify) ---
            _buildSection(children: [
              // 1.1 物品名称 (必填)
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

              // 1.2 日期模式切换 (Tab)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _buildModeTab("Expiry Date", !_isProductionMode, () => setState(() => _isProductionMode = false)),
                    const SizedBox(width: 12),
                    _buildModeTab("Prod. Date + Shelf Life", _isProductionMode, () => setState(() => _isProductionMode = true)),
                  ],
                ),
              ),

              // 1.3 日期输入区域
              if (!_isProductionMode)
                // 模式 A: 直接输入过期时间
                _buildDateRow(
                  label: "Expiry Date *",
                  value: _expiryDate,
                  onTap: () async {
                    final d = await showDatePicker(context: context, initialDate: _expiryDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
                    if (d != null) setState(() => _expiryDate = d);
                  },
                )
              else
                // 模式 B: 生产日期 + 保质期
                Column(
                  children: [
                    _buildDateRow(
                      label: "Production Date",
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
                            decoration: const InputDecoration(labelText: "Shelf Life (Days)", border: InputBorder.none),
                            onChanged: (_) => _calculateExpiryFromProduction(),
                          ),
                        ),
                      ],
                    ),
                    if (_expiryDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 36),
                        child: Text("Calculated Expiry: ${DateFormat('yyyy-MM-dd').format(_expiryDate!)}", 
                          style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              
              const Divider(),

              // 1.4 提醒设置
              Row(
                children: [
                  const Icon(Icons.notifications_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Expanded(child: Text("Reminder")),
                  DropdownButton<int>(
                    value: _notifyDays,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("1 day before")),
                      DropdownMenuItem(value: 3, child: Text("3 days before")),
                      DropdownMenuItem(value: 7, child: Text("1 week before")),
                    ],
                    onChanged: (v) => setState(() => _notifyDays = v!),
                  ),
                ],
              ),
            ]),

            // --- Level 2: 高级信息 (Advanced) ---
            _buildSection(isAdvanced: true, children: [
              // 2.1 数量 & 单位
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: "Quantity", border: InputBorder.none),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedUnit,
                    underline: const SizedBox(),
                    items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (val) => setState(() => _selectedUnit = val!),
                  ),
                ],
              ),
              const Divider(),

              // 2.2 分类 (保留之前的 Selector)
              _buildSelectorRow(
                label: "Category", 
                value: _categoryNameDisplay.isEmpty ? "Unknown" : _categoryNameDisplay,
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

              // 2.3 位置 (默认 Other)
              _buildSelectorRow(
                label: "Location", 
                value: _locationNameDisplay.isEmpty ? "Other" : _locationNameDisplay,
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

              // 2.4 购买日期 & 价格
              _buildDateRow(
                label: "Purchase Date", 
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
                      decoration: const InputDecoration(labelText: "Unit Price (Optional)", border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
      
      // --- 底部双按钮 (Save & Next) ---
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, -2))]),
        child: SafeArea(
          child: Row(
            children: [
              // Save & Add Next
              if (!isEditing) // 只有新建时显示
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _saveItem(addNext: true),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryGreen),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Save & Next", style: TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                ),
              if (!isEditing) const SizedBox(width: 12),
              
              // Save (Done)
              Expanded(
                child: FilledButton(
                  onPressed: () => _saveItem(addNext: false),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEditing ? "Update Item" : "Save", style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---

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
              value == null ? "Select" : DateFormat('yyyy-MM-dd').format(value),
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