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
  final bool isManageMode; 
  final Id? parentId; 
  final String? breadcrumbs;

  const CategorySelector({
    super.key, 
    this.isManageMode = false,
    this.parentId,
    this.breadcrumbs,
  });

  @override
  ConsumerState<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends ConsumerState<CategorySelector> {
  List<Category> _categories = [];
  Category? _currentParentCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadCategories());
  }

  Future<void> _loadCategories() async {
    final isar = ref.read(databaseProvider);
    final cats = await isar.categorys.filter().parentIdEqualTo(widget.parentId).findAll();
    if (widget.parentId != null) {
      _currentParentCategory = await isar.categorys.get(widget.parentId!);
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

  void _enterLevel(Category cat) async {
    if (cat.level < 2) {
      HapticFeedback.selectionClick();
      final currentName = LocalizedUtils.getLocalizedName(context, cat.name);
      final newPath = widget.breadcrumbs == null 
          ? currentName 
          : '${widget.breadcrumbs} / $currentName';

      final result = await Navigator.push<Category>(
        context,
        MaterialPageRoute(
          builder: (ctx) => CategorySelector(
            isManageMode: widget.isManageMode,
            parentId: cat.id,
            breadcrumbs: newPath,
          ),
        ),
      );
      
      if (result != null && mounted) {
        Navigator.pop(context, result);
      }
    }
  }

  void _handleSelection(Category cat) {
    HapticFeedback.mediumImpact();
    Navigator.pop(context, cat);
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
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.breadcrumbs != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "In: ${widget.breadcrumbs}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold),
                    ),
                  ),
                TextField(
                  controller: controller, 
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.name,
                    errorText: errorText,
                  ),
                  onChanged: (_) {
                    if (errorText != null) setState(() => errorText = null);
                  },
                ),
              ],
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
                    if (await _checkDuplicate(name, widget.parentId)) {
                       HapticFeedback.heavyImpact();
                       setState(() => errorText = l10n.errorNameExists);
                       return;
                    }
                    
                    HapticFeedback.lightImpact();
                    final isar = ref.read(databaseProvider);
                    final newCat = Category(name: name, parentId: widget.parentId, level: (_currentParentCategory?.level ?? -1) + 1);
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
    
    String title = widget.breadcrumbs ?? (widget.isManageMode ? l10n.manageCategories : l10n.categorySelect);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        centerTitle: false, // 靠左对齐
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _addCategory,
            icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 28),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _categories.isEmpty
          ? Center(child: Text(l10n.emptyList, style: TextStyle(color: Colors.grey[400])))
          : ListView.separated(
              itemCount: _categories.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
              itemBuilder: (ctx, i) {
                final c = _categories[i];
                final deep = c.level < 2;
                final displayName = LocalizedUtils.getLocalizedName(context, c.name);

                return ListTile(
                  onTap: () {
                    // 如果能深入，点击就深入
                    if (deep) {
                      _enterLevel(c);
                    } else {
                      // 否则，如果是管理模式，点击编辑；如果是选择模式，选中并返回
                      if (widget.isManageMode) {
                        _editCategory(c);
                      } else {
                        _handleSelection(c);
                      }
                    }
                  },
                  leading: Icon(deep ? Icons.grid_view : Icons.label_outline, color: Colors.grey[600], size: 24),
                  title: Text(displayName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (widget.isManageMode) ...[
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blueAccent), onPressed: () => _editCategory(c)),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteCategory(c)),
                    ] else ...[
                      // 选中按钮
                      IconButton(onPressed: () => _handleSelection(c), icon: const Icon(Icons.radio_button_unchecked, color: Colors.grey)),
                    ],
                    if (deep) Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ]),
                );
              },
            ),
    );
  }
}
