import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../localization/app_localizations.dart';
import '../../models/category.dart';
import '../../models/item.dart';
import '../../../main.dart'; 
import '../../config/theme.dart';

class CategorySelector extends StatefulWidget {
  final Function(Category) onSelected;

  const CategorySelector({super.key, required this.onSelected});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int? _currentParentId;
  List<Category> _categories = [];
  Category? _currentParentCategory;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await isarInstance.categorys
        .filter()
        .parentIdEqualTo(_currentParentId)
        .findAll();
    
    if (_currentParentId != null) {
      _currentParentCategory = await isarInstance.categorys.get(_currentParentId!);
    } else {
      _currentParentCategory = null;
    }

    if (mounted) {
      setState(() {
        _categories = cats;
      });
    }
  }

  void _enterLevel(Category cat) {
    if (cat.level < 2) {
      setState(() {
        _currentParentId = cat.id;
      });
      _loadCategories();
    }
  }

  void _goBack() async {
    if (_currentParentCategory != null) {
      setState(() {
        _currentParentId = _currentParentCategory!.parentId;
      });
      _loadCategories();
    }
  }

  void _addCategory() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.category), // 这里用 category 也可以，或者 "Add Category"
        content: TextField(
          controller: controller, 
          decoration: const InputDecoration(hintText: "Category Name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final newCat = Category(
                  name: controller.text,
                  parentId: _currentParentId,
                  level: (_currentParentCategory?.level ?? -1) + 1,
                );
                await isarInstance.writeTxn(() async => await isarInstance.categorys.put(newCat));
                _loadCategories();
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          )
        ],
      ),
    );
  }

  void _deleteCategory(Category cat) async {
     final hasChildren = await isarInstance.categorys.filter().parentIdEqualTo(cat.id).count() > 0;
     final hasItems = await isarInstance.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).count() > 0;

    if (hasChildren || hasItems) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("This category contains items or sub-categories."), backgroundColor: Colors.red)
        );
      }
      return;
    }
    await isarInstance.writeTxn(() async => await isarInstance.categorys.delete(cat.id));
    _loadCategories();
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
                _currentParentCategory?.name ?? l10n.category,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: _addCategory,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          
          Expanded(
            child: _categories.isEmpty
                ? Center(child: Text('No categories yet', style: TextStyle(color: Colors.grey[400])))
                : ListView.separated(
                    itemCount: _categories.length,
                    separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        title: Text(
                          cat.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 30),
                              onPressed: () {
                                widget.onSelected(cat);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, size: 22, color: Colors.red[200]),
                              onPressed: () => _deleteCategory(cat),
                            ),
                            if (cat.level < 2) 
                              IconButton(
                                icon: const Icon(Icons.chevron_right, color: Colors.grey),
                                onPressed: () {
                                  _enterLevel(cat);
                                },
                              ),
                          ],
                        ),
                        onTap: () {
                          if (cat.level < 2) {
                            _enterLevel(cat);
                          } else {
                            widget.onSelected(cat);
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