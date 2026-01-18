import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:use_up/src/localization/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/item.dart';
import '../../models/category.dart';
import '../../models/location.dart';
import '../../../main.dart';
import 'category_selector.dart';
import 'location_selector.dart';
import 'widgets/date_input_field.dart';
import '../../services/notification_service.dart';

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
  
  String? _imagePath; // 保存图片路径
  final ImagePicker _picker = ImagePicker();

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
      
      // --- 核心修复开始 ---
      // IsarLink 有时候需要手动 load，虽然 watch 会自动 load，但为了保险起见：
      item.categoryLink.loadSync(); 
      item.locationLink.loadSync();

      _selectedCategoryObj = item.categoryLink.value;
      _categoryNameDisplay = item.categoryLink.value?.name ?? item.categoryName;
      
      _selectedLocationObj = item.locationLink.value;
      _locationNameDisplay = item.locationLink.value?.name ?? item.locationName;
      // --- 核心修复结束 ---
      
      _expiryDate = item.expiryDate;
      _imagePath = item.imagePath;
    } else {
      _nameController = TextEditingController();
      _quantityController = TextEditingController(text: '1');
    }
  }

  // --- 新增：选择并保存图片 ---
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 50, // 压缩一下，防止数据库太卡
      );

      if (pickedFile == null) return;

      // 【关键步骤】将临时缓存图片 复制到 App 的永久文档目录
      final directory = await getApplicationDocumentsDirectory();
      final String fileName = p.basename(pickedFile.path);
      final String savedPath = '${directory.path}/$fileName';
      
      // 复制文件
      await File(pickedFile.path).copy(savedPath);

      setState(() {
        _imagePath = savedPath;
      });
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // --- 新增：弹出选择框 (相机或相册) ---
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
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

          // 1. Prepare the item object (OUTSIDE the transaction)
          Item itemToSave;

          if (widget.itemToEdit != null) {
            // Edit Mode: Update existing object
            itemToSave = widget.itemToEdit!;
            itemToSave.name = name;
            itemToSave.quantity = quantity;
            itemToSave.unit = _selectedUnit;
            itemToSave.expiryDate = _expiryDate;
            itemToSave.imagePath = _imagePath;
          } else {
            // Create Mode: New object
            itemToSave = Item(
              name: name,
              quantity: quantity,
              unit: _selectedUnit,
              purchaseDate: DateTime.now(),
              expiryDate: _expiryDate,
              imagePath: _imagePath,
            );
          }

          // Update common fields
          itemToSave.categoryName = _categoryNameDisplay.isEmpty ? 'Unknown' : _categoryNameDisplay;
          itemToSave.locationName = _locationNameDisplay.isEmpty ? 'Unknown' : _locationNameDisplay;
          
          itemToSave.categoryLink.value = _selectedCategoryObj;
          itemToSave.locationLink.value = _selectedLocationObj;

          // 2. Save to DB (INSIDE the transaction)
          await isarInstance.writeTxn(() async {
            // 1. 先把 Item 存入数据库 (为了生成 ID)
            await isarInstance.items.put(itemToSave);

            // 2. 更新 Link 的值
            itemToSave.categoryLink.value = _selectedCategoryObj;
            itemToSave.locationLink.value = _selectedLocationObj;
            
            // 3. 更新缓存的字符串名字 (用于 UI 快速显示)
            itemToSave.categoryName = _categoryNameDisplay;
            itemToSave.locationName = _locationNameDisplay;

            // 4. 【关键】再次保存 Links
            await itemToSave.categoryLink.save();
            await itemToSave.locationLink.save();
            
            // 5. 如果是编辑模式，为了保险，再次保存 Item 确保 string 字段也更新了
            await isarInstance.items.put(itemToSave); 
          });
          
          // 3. Schedule Notification (OUTSIDE the transaction)
          try {
             await NotificationService().scheduleExpiryNotification(itemToSave);
          } catch (e) {
             debugPrint('Failed to schedule notification: $e');
          }
          
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
            // --- 0. 图片选择区域 (新增) ---
            Center(
              child: GestureDetector(
                onTap: _showImageSourceActionSheet,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                    // 如果有图显示图，没图显示 Icon
                    image: _imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(_imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imagePath == null
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey[400])
                      : null, // 如果有图就不显示 Icon
                ),
              ),
            ),
            const SizedBox(height: 24), // 间距

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
