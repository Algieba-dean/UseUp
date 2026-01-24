import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterStatus { all, expired, expiringSoon }

class DashboardFilter {
  final String searchQuery;
  
  // 新增：筛选条件
  final int? categoryId;
  final String? categoryName; // 用于 UI 显示 "已选: 蔬菜"

  final int? locationId;
  final String? locationName; // 用于 UI 显示 "已选: 冰箱"
  
  final FilterStatus status;

  DashboardFilter({
    this.searchQuery = '',
    this.categoryId,
    this.categoryName,
    this.locationId,
    this.locationName,
    this.status = FilterStatus.all,
  });

  DashboardFilter copyWith({
    String? searchQuery,
    int? categoryId,
    String? categoryName,
    int? locationId,
    String? locationName,
    FilterStatus? status,
  }) {
    return DashboardFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      // 如果传入 null 不覆盖，只有显式传值才覆盖？
      // 为了支持 "清除筛选" (传入 null)，我们需要允许 nullable 覆盖
      // 这里使用简单的覆盖逻辑：
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      status: status ?? this.status,
    );
  }

  // 辅助方法：清除分类
  DashboardFilter clearCategory() {
    return DashboardFilter(
      searchQuery: this.searchQuery,
      locationId: this.locationId,
      locationName: this.locationName,
      // Keep status
      status: this.status,
      categoryId: null,
      categoryName: null,
    );
  }

  // 辅助方法：清除位置
  DashboardFilter clearLocation() {
    return DashboardFilter(
      searchQuery: this.searchQuery,
      categoryId: this.categoryId,
      categoryName: this.categoryName,
      // Keep status
      status: this.status,
      locationId: null,
      locationName: null,
    );
  }
}

final dashboardFilterProvider = StateProvider<DashboardFilter>((ref) {
  return DashboardFilter();
});