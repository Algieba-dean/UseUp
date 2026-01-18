import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../main.dart'; // 引入全局 isarInstance
import '../../../models/item.dart';
import '../../dashboard/providers/dashboard_filter_provider.dart';

// 这个 Provider 会监听 Isar 数据库的变化
// 一旦数据库有变动（添加/删除），它会自动通知 UI 刷新
final inventoryProvider = StreamProvider<List<Item>>((ref) {
  // 1. 监听筛选条件的变化
  final filter = ref.watch(dashboardFilterProvider);

  // 2. 使用链式调用 + optional 来构建查询，避免类型推断错误
  return isarInstance.items
      .filter()
      .isConsumedEqualTo(false)
      .optional(
        filter.searchQuery.isNotEmpty,
        (q) => q.nameContains(filter.searchQuery, caseSensitive: false),
      )
      .sortByExpiryDate() // Isar 自动生成的方法
      .watch(fireImmediately: true);
});