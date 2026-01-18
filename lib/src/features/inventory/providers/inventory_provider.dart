import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../models/item.dart';
import '../../../models/category.dart'; 
import '../../../models/location.dart'; 
import '../../dashboard/providers/dashboard_filter_provider.dart';
import '../data/inventory_repository.dart';

final inventoryProvider = StreamProvider<List<Item>>((ref) async* {
  final filter = ref.watch(dashboardFilterProvider);
  final repository = ref.watch(inventoryRepositoryProvider);
  
  // 1. 预先获取 ID 列表 (包含子孙)
  List<int> categoryIds = [];
  if (filter.categoryId != null) {
     categoryIds = await repository.getCategoryIdsWithDescendants(filter.categoryId!);
  }
  
  List<int> locationIds = [];
  if (filter.locationId != null) {
     locationIds = await repository.getLocationIdsWithDescendants(filter.locationId!);
  }

  // 2. 构建查询
  var query = repository.getItemsQuery().filter().isConsumedEqualTo(false);

  // 3. 搜索词
  if (filter.searchQuery.isNotEmpty) {
    query = query.nameContains(filter.searchQuery, caseSensitive: false);
  }

  // 4. 分类筛选 (使用 anyOf 匹配 ID 列表)
  if (filter.categoryId != null) {
    if (categoryIds.isNotEmpty) {
      query = query.categoryLink((q) => q.anyOf(categoryIds, (q, id) => q.idEqualTo(id)));
    } else {
      // 理论上不可能，至少包含自己
      query = query.categoryLink((q) => q.idEqualTo(filter.categoryId!));
    }
  }

  // 5. 位置筛选
  if (filter.locationId != null) {
    if (locationIds.isNotEmpty) {
      query = query.locationLink((q) => q.anyOf(locationIds, (q, id) => q.idEqualTo(id)));
    } else {
      query = query.locationLink((q) => q.idEqualTo(filter.locationId!));
    }
  }

  // 6. 输出流
  yield* query.sortByExpiryDate().watch(fireImmediately: true);
});