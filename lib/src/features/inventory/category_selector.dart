import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:use_up/src/models/category.dart';
import 'package:use_up/main.dart';
import '../../config/theme.dart';
import '../../models/item.dart';

class CategorySelector extends StatefulWidget {
  final Function(Category)? onSelected;
  final bool isManageMode; // 【新增】是否是管理模式

  const CategorySelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  List<Category> _currentCategories = [];
  Category? _parentCategory; // 当前层级的父级 (null 代表顶层)
  final TextEditingController _addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final parentId = _parentCategory?.id;
    List<Category> cats;
    if (parentId == null) {
      // 查顶层 (level 0)
      cats = await isarInstance.categorys.filter().levelEqualTo(0).findAll();
    } else {
      // 查子层
      cats = await isarInstance.categorys.filter().parentIdEqualTo(parentId).findAll();
    }
    setState(() {
      _currentCategories = cats;
    });
  }

  Future<void> _addCategory() async {
    final name = _addController.text.trim();
    if (name.isEmpty) return;

    final newCat = Category(
      name: name,
      level: _parentCategory == null ? 0 : (_parentCategory!.level + 1),
      parentId: _parentCategory?.id,
    );

    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.put(newCat);
    });

    _addController.clear();
    _loadCategories();
  }

  // --- 【新增】重命名逻辑 ---
  void _editCategory(Category cat) {
    final controller = TextEditingController(text: cat.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Category'),
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
              if (controller.text.isNotEmpty && controller.text != cat.name) {
                // 执行更新
                await _updateCategoryName(cat, controller.text);
                if (mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // 同步更新 Item 表中的 categoryName
  Future<void> _updateCategoryName(Category cat, String newName) async {
    await isarInstance.writeTxn(() async {
      // 1. 更新分类本身
      cat.name = newName;
      await isarInstance.categorys.put(cat);

      // 2. 找到所有关联了这个分类的物品
      final items = await isarInstance.items
          .filter()
          .categoryLink((q) => q.idEqualTo(cat.id))
          .findAll();
      
      for (var item in items) {
        item.categoryName = newName;
        await isarInstance.items.put(item);
      }
    });
    
    _loadCategories(); // 刷新列表
    if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Updated!')));
    }
  }

  Future<void> _deleteCategory(Category cat) async {
    // 检查是否有子分类
    final subCount = await isarInstance.categorys.filter().parentIdEqualTo(cat.id).count();
    if (subCount > 0) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete: Has sub-categories.")));
      return;
    }
    
    // 检查是否被使用 (Item)
    final itemCount = await isarInstance.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).count();
    if (itemCount > 0) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete: Items are using this category.")));
      return;
    }

    await isarInstance.writeTxn(() async {
      await isarInstance.categorys.delete(cat.id);
    });
    _loadCategories();
  }

  void _enterLevel(Category cat) {
    setState(() {
      _parentCategory = cat;
    });
    _loadCategories();
  }

  void _goBackLevel() {
    if (_parentCategory == null) return;
    
    // 如果现在的 parent 是顶层，回退后 parent 为 null
    // 如果现在的 parent 是二级，回退后 parent 为它爹
    // 简单起见，这里只支持 2 层，所以直接回退到 null (顶层)
    // 如果未来支持多层，这里需要查库找 parent
    
    setState(() {
      _parentCategory = null; 
    });
    _loadCategories();
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
              if (_parentCategory != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _goBackLevel,
                ),
              Text(
                _parentCategory == null ? "Select Category" : _parentCategory!.name,
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
                    hintText: "New Category Name",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _addCategory,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // List
          Expanded(
            child: _currentCategories.isEmpty 
              ? const Center(child: Text("No categories here."))
              : ListView.separated(
                  itemCount: _currentCategories.length,
                  separatorBuilder: (ctx, i) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final cat = _currentCategories[i];
                    
                    // Future: 检查是否有子类，如果有显示箭头
                    // 这里简单处理：如果 parentId 为 null，则允许点击进入下一级
                    final canGoDeeper = (cat.parentId == null); 

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      onTap: () {
                        if (widget.isManageMode) {
                          // 管理模式：如果没有子层级，或者是子层级，直接编辑
                          // 逻辑：点击总是编辑，还是点击如果有子类进子类？
                          // 更好的体验：管理模式下，还是允许导航，只有点特定的 Edit 按钮才编辑？
                          // 或者：点击名字导航，点击 trailing 的 edit 按钮编辑。
                          
                          if (canGoDeeper) {
                            _enterLevel(cat);
                          } else {
                            _editCategory(cat);
                          }
                        } else {
                          // 选择模式
                          if (canGoDeeper) {
                            _enterLevel(cat);
                          } else {
                            if (widget.onSelected != null) {
                               widget.onSelected!(cat);
                            }
                          }
                        }
                      },
                      leading: Icon(
                        canGoDeeper ? Icons.folder_open : Icons.label_outline,
                        color: Colors.grey,
                      ),
                      title: Text(cat.name, style: const TextStyle(fontSize: 16)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isManageMode)
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                              onPressed: () => _editCategory(cat),
                            ),
                          
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                            onPressed: () => _deleteCategory(cat),
                          ),
                          
                          if (canGoDeeper)
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                          else if (!widget.isManageMode)
                            // 选择模式下的选中状态逻辑略显复杂，这里简化
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
