import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../models/location.dart';
import '../../../data/providers/database_provider.dart';

// Repository 类：只负责纯粹的数据库操作
class InventoryRepository {
  final Isar _isar;

  InventoryRepository(this._isar);

  // 1. 添加/更新物品 (包含关联关系处理)
  Future<void> saveItem(Item item, Category? category, Location? location) async {
    await _isar.writeTxn(() async {
      // 1. 保存 Item 获取 ID
      await _isar.items.put(item);

      // 2. 设置关联
      item.categoryLink.value = category;
      item.locationLink.value = location;
      
      // 3. 更新缓存字段
      item.categoryName = category?.name ?? 'Unknown';
      item.locationName = location?.name ?? 'Unknown';

      // 4. 保存关联
      await item.categoryLink.save();
      await item.locationLink.save();
      
      // 5. 再次保存 Item (更新字符串字段)
      await _isar.items.put(item);
    });
  }

  // 2. 删除物品
  Future<void> deleteItem(int id) async {
    await _isar.writeTxn(() async {
      await _isar.items.delete(id);
    });
  }

  // 3. 标记消耗
  Future<void> consumeItem(Item item) async {
    await _isar.writeTxn(() async {
      item.isConsumed = true;
      item.consumedDate = DateTime.now();
      await _isar.items.put(item);
    });
  }

  // 4. 获取查询构建器 (用于 Provider 监听)
  QueryBuilder<Item, Item, QWhere> getItemsQuery() {
    return _isar.items.where();
  }
}

// Provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final isar = ref.watch(databaseProvider);
  return InventoryRepository(isar);
});
