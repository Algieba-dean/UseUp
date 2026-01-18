import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../models/item.dart';
import '../../../models/category.dart'; 
import '../../../models/location.dart'; 
import '../../dashboard/providers/dashboard_filter_provider.dart';
import '../data/inventory_repository.dart'; // 引入 Repository

final inventoryProvider = StreamProvider<List<Item>>((ref) {
  final filter = ref.watch(dashboardFilterProvider);
  // 通过 Repository 获取查询起点
  final repository = ref.watch(inventoryRepositoryProvider);
  
  var query = repository.getItemsQuery().filter().isConsumedEqualTo(false);

  // 3. 动态叠加搜索条件
  if (filter.searchQuery.isNotEmpty) {
    query = query.nameContains(filter.searchQuery, caseSensitive: false);
  }

  // 4. 动态叠加分类条件
  if (filter.categoryId != null) {
    query = query.categoryLink((q) => q.idEqualTo(filter.categoryId!));
  }

  // 5. 动态叠加位置条件
  if (filter.locationId != null) {
    query = query.locationLink((q) => q.idEqualTo(filter.locationId!));
  }

  return query
      .sortByExpiryDate()
      .watch(fireImmediately: true);
});
