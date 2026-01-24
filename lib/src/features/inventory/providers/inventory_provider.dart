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

  // 6. 状态筛选 (已过期/临期)
  // 注意：需要 import 'package:isar/isar.dart'; 确保扩展方法可用
  final now = DateTime.now();
  // 清除时分秒，只比较日期
  final today = DateTime(now.year, now.month, now.day);
  
  if (filter.status == FilterStatus.expired) {
    query = query.expiryDateLessThan(today);
  } else if (filter.status == FilterStatus.expiringSoon) {
    // 临期：今天 <= 到期日 <= 5天后
    final fiveDaysLater = today.add(const Duration(days: 5));
    query = query.expiryDateBetween(today, fiveDaysLater, includeLower: true, includeUpper: true);
  }

  // 7. 输出流 (根据状态调整排序)
  // 已过期物品通常按“过期时间倒序”（越早过期的越上面？或者刚刚过期的在上面？）
  // 这里的需求是“按过期时间倒序排列” (Desc)，即 2022年 在 2023年 上面（Isar sortDesc 是大到小，所以 2023 在 2022 上面）。
  // 通常“已过期”列表，我们希望看到“过期最久”的还是“刚刚过期”的？需求说是“倒序”。
  // 假设 2020年(A) 和 2024年(B)。倒序 -> B, A。
  // 如果是默认排序 (sortByExpiryDate) 是升序 -> 2020, 2024。
  
  if (filter.status == FilterStatus.expired) {
    yield* query.sortByExpiryDateDesc().watch(fireImmediately: true);
  } else {
    yield* query.sortByExpiryDate().watch(fireImmediately: true);
  }
});