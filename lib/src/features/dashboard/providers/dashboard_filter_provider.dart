import 'package:flutter_riverpod/flutter_riverpod.dart';

// 定义筛选条件模型
class DashboardFilter {
  final String searchQuery;
  // 未来可以扩展：final int? categoryId;
  // 未来可以扩展：final int? locationId;

  DashboardFilter({this.searchQuery = ''});

  // 复制并修改的方法 (copyWith)
  DashboardFilter copyWith({String? searchQuery}) {
    return DashboardFilter(
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// 创建 Provider 来管理这个状态
// StateProvider 允许我们在 UI 中直接修改它
final dashboardFilterProvider = StateProvider<DashboardFilter>((ref) {
  return DashboardFilter(); // 初始状态为空
});
