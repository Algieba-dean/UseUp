import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../models/category.dart';
import '../../models/item.dart';
import '../../../main.dart'; 
import '../../config/theme.dart';
import '../../utils/localized_utils.dart'; // 引入工具类

class CategorySelector extends StatefulWidget {
  final Function(Category)? onSelected;
  final bool isManageMode; 

  const CategorySelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  Id? _currentParentId;
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

    setState(() {
      _categories = cats;
    });
  }

  void _enterLevel(Category cat) {
    if (cat.level < 2) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentParentId = cat.id;
      });
      _loadCategories();
    }
  }

  void _goBack() async {
    if (_currentParentCategory != null) {
      HapticFeedback.selectionClick();
      setState(() {
        _currentParentId = _currentParentCategory!.parentId;
      });
      _loadCategories();
    }
  }

  void _handleSelection(Category cat) async {
    if (widget.onSelected != null) {
      await HapticFeedback.mediumImpact();
      widget.onSelected!(cat);
    }
  }

  void _addCategory() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.isManageMode ? l10n.categoryAddSub : l10n.categoryAdd),
        content: TextField(
          controller: controller, 
          autofocus: true,
          decoration: InputDecoration(hintText: l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                HapticFeedback.lightImpact();
                final newCat = Category(
                  name: controller.text,
                  parentId: _currentParentId,
                  level: (_currentParentCategory?.level ?? -1) + 1,
                );
                await isarInstance.writeTxn(() async => await isarInstance.categorys.put(newCat));
                _loadCategories();
                if(mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          )
        ],
      ),
    );
  }

  void _editCategory(Category cat) {
    final controller = TextEditingController(text: cat.name);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categoryRename),
        content: TextField(
          controller: controller, 
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty && controller.text != cat.name) {
                await isarInstance.writeTxn(() async {
                  cat.name = controller.text;
                  await isarInstance.categorys.put(cat);
                  
                  final items = await isarInstance.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
                  for (var item in items) {
                    item.categoryName = cat.name;
                    await isarInstance.items.put(item);
                  }
                });
                _loadCategories();
                if(mounted) Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(Category cat) async {
     final l10n = AppLocalizations.of(context)!;

     final hasChildren = await isarInstance.categorys.filter().parentIdEqualTo(cat.id).count() > 0;
     if (hasChildren) {
       HapticFeedback.heavyImpact();
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
           content: Text(l10n.containsSubItems), 
           backgroundColor: Colors.red
         ));
       }
       return;
     }

     final relatedItemsCount = await isarInstance.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).count();
     
     if (relatedItemsCount > 0) {
       _showMoveAndDeleteDialog(cat, relatedItemsCount);
     } else {
       _confirmDeleteEmpty(cat);
     }
  }

  void _confirmDeleteEmpty(Category cat) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categoryDeleteTitle),
        content: Text(l10n.deleteEmptyConfirm),
        actions: [
           TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
           TextButton(
             style: TextButton.styleFrom(foregroundColor: Colors.red),
             onPressed: () async {
               await isarInstance.writeTxn(() async => await isarInstance.categorys.delete(cat.id));
               _loadCategories();
               if(mounted) Navigator.pop(ctx);
             }, 
             child: Text(l10n.delete)
           ),
        ],
      ),
    );
  }

  void _showMoveAndDeleteDialog(Category cat, int count) {
    final l10n = AppLocalizations.of(context)!;
    // 目标分类名如果是 "Misc" 要翻译
    final targetName = LocalizedUtils.getLocalizedName(context, 'Misc'); 

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categoryDeleteTitle),
        content: Text(l10n.deleteMoveConfirm(count, targetName)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              await _performMoveAndDelete(cat);
              if(mounted) Navigator.pop(ctx);
            },
            child: Text(l10n.confirmAndMove),
          ),
        ],
      ),
    );
  }

  Future<void> _performMoveAndDelete(Category cat) async {
    final l10n = AppLocalizations.of(context)!;
    var defaultCat = await isarInstance.categorys.filter().nameEqualTo('杂物').findFirst();
    if (defaultCat == null) {
      defaultCat = await isarInstance.categorys.filter().nameEqualTo('Misc').findFirst();
    }
    if (defaultCat == null) {
       defaultCat = await isarInstance.categorys.filter().nameEqualTo('Other').findFirst();
    }
    
    if (defaultCat == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorDefaultNotFound('Misc'))));
      return;
    }

    if (defaultCat.id == cat.id) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cannotDeleteDefault)));
       return;
    }

    await isarInstance.writeTxn(() async {
      final items = await isarInstance.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
      for (var item in items) {
        item.categoryLink.value = defaultCat;
        item.categoryName = defaultCat!.name;
        await item.categoryLink.save();
        await isarInstance.items.put(item);
      }
      await isarInstance.categorys.delete(cat.id);
    });

    HapticFeedback.mediumImpact();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // 显示父级名称时也要 Localized
    final parentName = _currentParentCategory == null 
        ? null 
        : LocalizedUtils.getLocalizedName(context, _currentParentCategory!.name);

    final title = parentName ?? (widget.isManageMode ? l10n.manageCategories : l10n.categorySelect);

    return Container(
      height: 550,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
          ),
          
          Row(
            children: [
              if (_currentParentId != null)
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: _goBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (_currentParentId != null) const SizedBox(width: 16),
              
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                onPressed: _addCategory,
                icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 36),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: _categories.isEmpty
                ? Center(child: Text(l10n.emptyList, style: TextStyle(color: Colors.grey[400])))
                : ListView.separated(
                    itemCount: _categories.length,
                    separatorBuilder: (ctx, i) => Divider(height: 1, color: Colors.grey[100]),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final canGoDeeper = cat.level < 2;
                      
                      // 核心：使用工具类翻译名称
                      final displayName = LocalizedUtils.getLocalizedName(context, cat.name);

                      return InkWell(
                        onTap: () {
                          if (canGoDeeper) {
                            _enterLevel(cat);
                          } else {
                            if (!widget.isManageMode) {
                              _handleSelection(cat);
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                          child: Row(
                            children: [
                              Icon(
                                canGoDeeper ? Icons.grid_view : Icons.label_outline, 
                                color: Colors.grey[600],
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(displayName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.isManageMode) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                      onPressed: () => _editCategory(cat),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline, color: Colors.red[300]),
                                      onPressed: () => _deleteCategory(cat),
                                    ),
                                  ] else ...[
                                    IconButton(
                                      onPressed: () => _handleSelection(cat),
                                      icon: Icon(Icons.radio_button_unchecked, color: Colors.grey[400], size: 28),
                                    ),
                                  ],
                                  if (canGoDeeper)
                                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                                ],
                              ),
                            ],
                          ),
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
