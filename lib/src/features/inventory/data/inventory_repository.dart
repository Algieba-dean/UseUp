import 'dart:io';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../models/location.dart';
import '../../../data/providers/database_provider.dart';
import '../../../config/constants.dart';

class InventoryRepository {
  final Isar _isar;

  InventoryRepository(this._isar);

  // 1. 保存/更新物品
  Future<void> saveItem(Item item, Category? category, Location? location) async {
    await _isar.writeTxn(() async {
      await _isar.items.put(item);
      item.categoryLink.value = category;
      item.locationLink.value = location;
      item.categoryName = category?.name ?? AppConstants.defaultCategoryMisc;
      item.locationName = location?.name ?? AppConstants.defaultLocationOther;
      await item.categoryLink.save();
      await item.locationLink.save();
      await _isar.items.put(item);
    });
  }

  // 2. 彻底删除（含图片文件删除）
  Future<void> deleteItem(int id) async {
    final item = await _isar.items.get(id);
    if (item != null && item.imagePath != null) {
      try {
        final file = File(item.imagePath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Log error
      }
    }
    await _isar.writeTxn(() async {
      await _isar.items.delete(id);
    });
  }

  // 3. 消耗物品
  Future<void> consumeItem(Item item) async {
    await _isar.writeTxn(() async {
      item.isConsumed = true;
      item.consumedDate = DateTime.now();
      await _isar.items.put(item);
    });
  }

  // 4. 获取默认位置和分类
  Future<Location?> getDefaultLocation() async {
    return await _isar.locations.filter()
        .nameEqualTo('其他').or().nameEqualTo(AppConstants.defaultLocationOther)
        .findFirst();
  }

  Future<Category?> getDefaultCategory() async {
    return await _isar.categorys.filter()
        .nameEqualTo('杂物').or().nameEqualTo(AppConstants.defaultCategoryMisc)
        .findFirst();
  }

  QueryBuilder<Item, Item, QWhere> getItemsQuery() {
    return _isar.items.where();
  }
  
  // 5. 异步加载 Link
  Future<void> loadLinks(Item item) async {
    await item.categoryLink.load();
    await item.locationLink.load();
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final isar = ref.watch(databaseProvider);
  return InventoryRepository(isar);
});