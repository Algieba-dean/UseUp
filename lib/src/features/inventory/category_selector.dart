import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../models/category.dart';
import '../../models/item.dart';
import '../../config/theme.dart';
import '../../data/providers/database_provider.dart';
import '../../utils/localized_utils.dart';

class CategorySelector extends ConsumerStatefulWidget {
  final Function(Category)? onSelected;
  final bool isManageMode; 

  const CategorySelector({
    super.key, 
    this.onSelected,
    this.isManageMode = false,
  });

  @override
  ConsumerState<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  Id? _currentParentId;
  List<Category> _categories = [];
  Category? _currentParentCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadCategories());
  }

  Future<void> _loadCategories() async {
    final isar = ref.read(databaseProvider);
    final cats = await isar.categorys.filter().parentIdEqualTo(_currentParentId).findAll();
    if (_currentParentId != null) {
      _currentParentCategory = await isar.categorys.get(_currentParentId!);
    } else {
      _currentParentCategory = null;
    }
    setState(() => _categories = cats);
  }

  Future<bool> _checkDuplicate(String name, Id? parentId, {Id? excludeId}) async {
    final isar = ref.read(databaseProvider);
    var query = isar.categorys
        .filter()
        .parentIdEqualTo(parentId)
        .nameEqualTo(name, caseSensitive: false);
        
    if (excludeId != null) {
      query = query.not().idEqualTo(excludeId);
    }
    
    final count = await query.count();
    return count > 0;
  }

  void _enterLevel(Category cat) {
    if (cat.level < 2) {
      HapticFeedback.selectionClick();
      setState(() => _currentParentId = cat.id);
      _loadCategories();
    }
  }

  void _goBack() {
    if (_currentParentCategory != null) {
      HapticFeedback.selectionClick();
      setState(() => _currentParentId = _currentParentCategory!.parentId);
      _loadCategories();
    }
  }

  void _handleSelection(Category cat) {
    if (widget.onSelected != null) {
      HapticFeedback.mediumImpact();
      widget.onSelected!(cat);
    }
  }

  void _addCategory() {
    final controller = TextEditingController();
    final l10n = AppLocalizations.of(context)!;
    String? errorText;
    
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(widget.isManageMode ? l10n.categoryAddSub : l10n.categoryAdd),
            content: TextField(
              controller: controller, 
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.name,
                errorText: errorText, // 显示错误信息
              ),
              onChanged: (_) {
                if (errorText != null) setState(() => errorText = null);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    if (await _checkDuplicate(name, _currentParentId)) {
                       HapticFeedback.heavyImpact();
                       setState(() => errorText = l10n.errorNameExists);
                       return;
                    }
                    
                    HapticFeedback.lightImpact();
                    final isar = ref.read(databaseProvider);
                    final newCat = Category(name: name, parentId: _currentParentId, level: (_currentParentCategory?.level ?? -1) + 1);
                    await isar.writeTxn(() async => await isar.categorys.put(newCat));
                    _loadCategories();
                    if(mounted) Navigator.pop(ctx);
                  }
                },
                child: Text(l10n.save),
              )
            ],
          );
        }
      ),
    );
  }

  void _editCategory(Category cat) {
    final controller = TextEditingController(text: cat.name);
    final l10n = AppLocalizations.of(context)!;
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.categoryRename),
            content: TextField(
              controller: controller, 
              autofocus: true,
              decoration: InputDecoration(
                labelText: l10n.name,
                errorText: errorText,
              ),
              onChanged: (_) {
                if (errorText != null) setState(() => errorText = null);
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  final name = controller.text.trim();
                  if (name.isNotEmpty && name != cat.name) {
                    if (await _checkDuplicate(name, cat.parentId, excludeId: cat.id)) {
                       HapticFeedback.heavyImpact();
                       setState(() => errorText = l10n.errorNameExists);
                       return;
                    }

                    final isar = ref.read(databaseProvider);
                    await isar.writeTxn(() async {
                      cat.name = name;
                      await isar.categorys.put(cat);
                      final items = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
                      for (var item in items) {
                        item.categoryName = name;
                        await isar.items.put(item);
                      }
                    });
                    _loadCategories();
                    if(mounted) Navigator.pop(ctx);
                  }
                },
                child: Text(l10n.save),
              ),
            ],
          );
        }
      ),
    );
  }

  void _deleteCategory(Category cat) async {
     final l10n = AppLocalizations.of(context)!;
     final isar = ref.read(databaseProvider);
     if (await isar.categorys.filter().parentIdEqualTo(cat.id).count() > 0) {
       HapticFeedback.heavyImpact();
       // 弹窗提示，不使用 SnackBar
       showDialog(context: context, builder: (ctx) => AlertDialog(
         title: Text(l10n.categoryDeleteTitle),
         content: Text(l10n.containsSubItems),
         actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.confirm))],
       ));
       return;
     }
     final count = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).count();
     if (count > 0) _showMoveAndDeleteDialog(cat, count);
     else _confirmDeleteEmpty(cat);
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
               await ref.read(databaseProvider).writeTxn(() async => await ref.read(databaseProvider).categorys.delete(cat.id));
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
    final target = LocalizedUtils.getLocalizedName(context, 'Misc');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.categoryDeleteTitle),
        content: Text(l10n.deleteMoveConfirm(count, target)),
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
    final isar = ref.read(databaseProvider);
    final l10n = AppLocalizations.of(context)!;
    var defaultCat = await isar.categorys.filter().nameEqualTo('Misc').findFirst();
    if (defaultCat == null) {
       defaultCat = await isar.categorys.filter().nameEqualTo('杂物').findFirst();
    }
    if (defaultCat == null) {
       defaultCat = await isar.categorys.filter().nameEqualTo('Other').findFirst();
    }
    
    if (defaultCat == null) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorDefaultNotFound('Misc'))));
      return;
    }

    if (defaultCat.id == cat.id) {
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.cannotDeleteDefault)));
       return;
    }

    await isar.writeTxn(() async {
      final items = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
      for (var item in items) {
        item.categoryLink.value = defaultCat;
        item.categoryName = defaultCat!.name;
        await item.categoryLink.save();
        await isar.items.put(item);
      }
      await isar.categorys.delete(cat.id);
    });

    HapticFeedback.mediumImpact();
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _currentParentCategory != null ? LocalizedUtils.getLocalizedName(context, _currentParentCategory!.name) : (widget.isManageMode ? l10n.manageCategories : l10n.categorySelect);
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
                      final displayName = LocalizedUtils.getLocalizedName(context, cat.name);

                      return ListTile(
                        onTap: () => deepTap(cat, canGoDeeper),
                        leading: Icon(canGoDeeper ? Icons.grid_view : Icons.label_outline, color: Colors.grey[600], size: 24),
                        title: Text(displayName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.isManageMode) ...[
                              IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _editCategory(cat)),
                              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteCategory(cat)),
                            ] else ...[
                              IconButton(onPressed: () => _handleSelection(cat), icon: Icon(Icons.radio_button_unchecked, color: Colors.grey[400], size: 28)),
                            ],
                            if (canGoDeeper)
                              Icon(Icons.chevron_right, color: Colors.grey[400]),
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

  void deepTap(Category cat, bool canGoDeeper) {
    if (canGoDeeper) {
      _enterLevel(cat);
    } else {
      if (!widget.isManageMode) {
        _handleSelection(cat);
      }
    }
  }
}