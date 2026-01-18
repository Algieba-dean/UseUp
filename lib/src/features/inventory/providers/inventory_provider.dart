import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../main.dart'; 
import '../../../models/item.dart';
import '../../../models/category.dart'; 
import '../../../models/location.dart'; 
import '../../dashboard/providers/dashboard_filter_provider.dart';

final inventoryProvider = StreamProvider<List<Item>>((ref) {
  // 1. 获取当前的筛选条件
  final filter = ref.watch(dashboardFilterProvider);

  // 2. 构建查询 - 使用 var 让 Dart 自动推断复杂的 Isar 类型
  // 起手式：只看未消耗的物品
  var query = isarInstance.items.filter().isConsumedEqualTo(false);

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

  // 6. 最后进行排序并实时监听
  // 因为上面的 query 一直保持着 QAfterFilterCondition 类型，所以 sortBy 是可用的
  return query
      .sortByExpiryDate()
      .watch(fireImmediately: true);
});