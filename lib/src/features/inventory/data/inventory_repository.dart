import 'dart:io';
import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../models/location.dart';
import '../../../data/providers/database_provider.dart';
import '../../../config/constants.dart';
import '../../../services/notification_service.dart';

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
    
    // Ensure notifications are cancelled
    await NotificationService().cancelNotification(id);
  }

  // 3. 消耗物品
  Future<void> consumeItem(Item item) async {
    await _isar.writeTxn(() async {
      item.isConsumed = true;
      item.consumedDate = DateTime.now();
      await _isar.items.put(item);
    });
    
    // Consumed items shouldn't trigger expiry notifications
    await NotificationService().cancelNotification(item.id);
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

  // --- Category Safety Operations ---

  Future<int> countItemsByCategory(int id) {
    return _isar.items.filter().categoryLink((q) => q.idEqualTo(id)).count();
  }

  Future<int> countSubCategories(int id) {
    return _isar.categorys.filter().parentIdEqualTo(id).count();
  }

  Future<void> deleteCategorySafe(int id) async {
    // 1. Find Default
    var defaultCat = await _isar.categorys.filter().nameEqualTo(AppConstants.defaultCategoryMisc).findFirst();
    // Fallback for legacy data
    if (defaultCat == null) {
       defaultCat = await _isar.categorys.filter().nameEqualTo('杂物').findFirst();
    }
    
    if (defaultCat == null) throw Exception("Default category not found.");
    if (defaultCat.id == id) throw Exception("Cannot delete the system default category.");

    await _isar.writeTxn(() async {
      // 2. Migrate Sub-categories
      final subs = await _isar.categorys.filter().parentIdEqualTo(id).findAll();
      for (var sub in subs) {
        sub.parentId = defaultCat!.id;
        await _isar.categorys.put(sub);
      }

      // 3. Migrate Items
      final items = await _isar.items.filter().categoryLink((q) => q.idEqualTo(id)).findAll();
      for (var item in items) {
        item.categoryLink.value = defaultCat;
        item.categoryName = defaultCat!.name;
        await item.categoryLink.save();
        await _isar.items.put(item);
      }

      // 4. Delete
      await _isar.categorys.delete(id);
    });
  }

  // --- Location Safety Operations ---

  Future<int> countItemsByLocation(int id) {
    return _isar.items.filter().locationLink((q) => q.idEqualTo(id)).count();
  }

  Future<int> countSubLocations(int id) {
    return _isar.locations.filter().parentIdEqualTo(id).count();
  }

  Future<void> deleteLocationSafe(int id) async {
    var defaultLoc = await _isar.locations.filter().nameEqualTo(AppConstants.defaultLocationOther).findFirst();
    if (defaultLoc == null) {
       defaultLoc = await _isar.locations.filter().nameEqualTo('其他').findFirst();
    }

    if (defaultLoc == null) throw Exception("Default location not found.");
    if (defaultLoc.id == id) throw Exception("Cannot delete the system default location.");

    await _isar.writeTxn(() async {
      // Migrate Sub-locations
      final subs = await _isar.locations.filter().parentIdEqualTo(id).findAll();
      for (var sub in subs) {
        sub.parentId = defaultLoc!.id;
        await _isar.locations.put(sub);
      }

      // Migrate Items
      final items = await _isar.items.filter().locationLink((q) => q.idEqualTo(id)).findAll();
      for (var item in items) {
        item.locationLink.value = defaultLoc;
        item.locationName = defaultLoc!.name;
        await item.locationLink.save();
        await _isar.items.put(item);
      }

      // Delete
      await _isar.locations.delete(id);
    });
  }

  // 6. 递归获取子分类 ID
  Future<List<int>> getCategoryIdsWithDescendants(int parentId) async {
    final ids = {parentId};
    var currentLevelIds = [parentId];
    
    while (currentLevelIds.isNotEmpty) {
      final children = await _isar.categorys
          .filter()
          .anyOf(currentLevelIds, (q, int id) => q.parentIdEqualTo(id))
          .findAll();
      if (children.isEmpty) break;
      currentLevelIds = children.map((e) => e.id).toList();
      ids.addAll(currentLevelIds);
    }
    return ids.toList();
  }

  // 7. 递归获取子位置 ID
  Future<List<int>> getLocationIdsWithDescendants(int parentId) async {
    final ids = {parentId};
    var currentLevelIds = [parentId];
    
    while (currentLevelIds.isNotEmpty) {
      final children = await _isar.locations
          .filter()
          .anyOf(currentLevelIds, (q, int id) => q.parentIdEqualTo(id))
          .findAll();
      if (children.isEmpty) break;
      currentLevelIds = children.map((e) => e.id).toList();
      ids.addAll(currentLevelIds);
    }
    return ids.toList();
  }
}

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final isar = ref.watch(databaseProvider);
  return InventoryRepository(isar);
});