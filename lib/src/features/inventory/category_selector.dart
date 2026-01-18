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
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(widget.isManageMode ? l10n.categoryAddSub : l10n.categoryAdd),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(hintText: l10n.name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          if (controller.text.isNotEmpty) {
            final isar = ref.read(databaseProvider);
            final newCat = Category(name: controller.text, parentId: _currentParentId, level: (_currentParentCategory?.level ?? -1) + 1);
            await isar.writeTxn(() async => await isar.categorys.put(newCat));
            _loadCategories();
            if(mounted) Navigator.pop(ctx);
          }
        }, child: Text(l10n.save)),
      ],
    ));
  }

  void _editCategory(Category cat) {
    final controller = TextEditingController(text: cat.name);
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.categoryRename),
      content: TextField(controller: controller, autofocus: true, decoration: InputDecoration(labelText: l10n.name)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          if (controller.text.isNotEmpty && controller.text != cat.name) {
            final isar = ref.read(databaseProvider);
            await isar.writeTxn(() async {
              cat.name = controller.text;
              await isar.categorys.put(cat);
              final items = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
              for (var item in items) {
                item.categoryName = cat.name;
                await isar.items.put(item);
              }
            });
            _loadCategories();
            if(mounted) Navigator.pop(ctx);
          }
        }, child: Text(l10n.save)),
      ],
    ));
  }

  void _deleteCategory(Category cat) async {
     final l10n = AppLocalizations.of(context)!;
     final isar = ref.read(databaseProvider);
     if (await isar.categorys.filter().parentIdEqualTo(cat.id).count() > 0) {
       HapticFeedback.heavyImpact();
       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.containsSubItems), backgroundColor: Colors.red));
       return;
     }
     final count = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).count();
     if (count > 0) _showMoveAndDeleteDialog(cat, count);
     else _confirmDeleteEmpty(cat);
  }

  void _confirmDeleteEmpty(Category cat) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.categoryDeleteTitle), content: Text(l10n.deleteEmptyConfirm),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          await ref.read(databaseProvider).writeTxn(() async => await ref.read(databaseProvider).categorys.delete(cat.id));
          _loadCategories();
          if(mounted) Navigator.pop(ctx);
        }, child: Text(l10n.delete, style: const TextStyle(color: Colors.red))),
      ],
    ));
  }

  void _showMoveAndDeleteDialog(Category cat, int count) {
    final l10n = AppLocalizations.of(context)!;
    final target = LocalizedUtils.getLocalizedName(context, 'Misc');
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(l10n.categoryDeleteTitle), content: Text(l10n.deleteMoveConfirm(count, target)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
        TextButton(onPressed: () async {
          await _performMoveAndDelete(cat);
          if(mounted) Navigator.pop(ctx);
        }, child: Text(l10n.confirmAndMove, style: const TextStyle(color: Colors.red))),
      ],
    ));
  }

  Future<void> _performMoveAndDelete(Category cat) async {
    final isar = ref.read(databaseProvider);
    final l10n = AppLocalizations.of(context)!;
    final defaultCat = await isar.categorys.filter().nameEqualTo('杂物').or().nameEqualTo('Misc').findFirst();
    if (defaultCat == null || defaultCat.id == cat.id) return;
    await isar.writeTxn(() async {
      final items = await isar.items.filter().categoryLink((q) => q.idEqualTo(cat.id)).findAll();
      for (var item in items) {
        item.categoryLink.value = defaultCat;
        item.categoryName = defaultCat.name;
        await item.categoryLink.save();
        await isar.items.put(item);
      }
      await isar.categorys.delete(cat.id);
    });
    _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _currentParentCategory != null ? LocalizedUtils.getLocalizedName(context, _currentParentCategory!.name) : (widget.isManageMode ? l10n.manageCategories : l10n.categorySelect);
    return Container(
      height: 550, decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(children: [
        Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
        Row(children: [
          if (_currentParentId != null) IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: _goBack),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Spacer(), IconButton(onPressed: _addCategory, icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen, size: 36)),
        ]),
        const SizedBox(height: 16),
        Expanded(child: _categories.isEmpty ? Center(child: Text(l10n.emptyList)) : ListView.separated(
          itemCount: _categories.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[100]),
          itemBuilder: (ctx, i) {
            final c = _categories[i];
            final deep = c.level < 2;
            return ListTile(
              onTap: () => deep ? _enterLevel(c) : (widget.isManageMode ? _editCategory(c) : _handleSelection(c)),
              leading: Icon(deep ? Icons.grid_view : Icons.label_outline),
              title: Text(LocalizedUtils.getLocalizedName(context, c.name)),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                if (widget.isManageMode) ...[
                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _editCategory(c)),
                  IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => _deleteCategory(c))
                ] else ...[
                  IconButton(onPressed: () => _handleSelection(c), icon: const Icon(Icons.radio_button_unchecked))
                ],
                if (deep) const Icon(Icons.chevron_right),
              ]),
            );
          },
        )),
      ]),
    );
  }
}