import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:use_up/src/localization/app_localizations.dart'; // 修正后的正确路径
import '../inventory/providers/inventory_provider.dart'; 
import 'providers/dashboard_filter_provider.dart';
import 'widgets/expiring_card.dart';
import '../../config/theme.dart';        // 修正为 ../../
import '../../utils/expiry_utils.dart';  // 修正为 ../../
import '../../models/item.dart';
import '../inventory/category_selector.dart';
import '../inventory/location_selector.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isSearching = false; // 控制是否显示搜索框
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 清空搜索
  void _clearSearch() {
    _searchController.clear();
    ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(searchQuery: '');
    setState(() {
      _isSearching = false;
    });
  }

  // --- 新增：显示筛选弹窗 ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 允许半屏以上
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        // 使用 Consumer 获取当前状态，以便回显（可选）
        return Consumer(
          builder: (context, ref, _) {
            final currentFilter = ref.read(dashboardFilterProvider);
            
            return Container(
              padding: const EdgeInsets.all(24),
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          // 重置所有
                          ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                            searchQuery: currentFilter.searchQuery, // 保留搜索词
                          );
                          Navigator.pop(ctx);
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 1. 分类选择
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      // 弹出之前写的 CategorySelector
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (c) => CategorySelector(
                          onSelected: (cat) {
                            // 更新 Provider
                            final old = ref.read(dashboardFilterProvider);
                            ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                              searchQuery: old.searchQuery,
                              locationId: old.locationId,
                              locationName: old.locationName,
                              // 更新分类
                              categoryId: cat.id,
                              categoryName: cat.name,
                            );
                            Navigator.pop(c); // 关掉选择器
                            Navigator.pop(ctx); // 关掉筛选页 (或者保留体验更好？这里简单起见先全关)
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentFilter.categoryName ?? 'All Categories', style: const TextStyle(fontSize: 16)),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 2. 位置选择
                  const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                       showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (c) => LocationSelector(
                          onSelected: (loc) {
                            final old = ref.read(dashboardFilterProvider);
                            ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                              searchQuery: old.searchQuery,
                              categoryId: old.categoryId,
                              categoryName: old.categoryName,
                              // 更新位置
                              locationId: loc.id,
                              locationName: loc.name,
                            );
                            Navigator.pop(c);
                            Navigator.pop(ctx);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentFilter.locationName ?? 'All Locations', style: const TextStyle(fontSize: 16)),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inventoryAsync = ref.watch(inventoryProvider);
    // 获取当前状态
    final filterState = ref.watch(dashboardFilterProvider);
    final currentQuery = filterState.searchQuery;
    
    // 是否有活跃的筛选 (分类或位置)
    final hasActiveFilters = filterState.categoryId != null || filterState.locationId != null;

    return Scaffold(
      backgroundColor: AppTheme.neutralGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralGrey,
        elevation: 0,
        // --- 动态 AppBar ---
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                onChanged: (value) {
                  // 实时更新 Provider
                  ref.read(dashboardFilterProvider.notifier).state = 
                      filterState.copyWith(searchQuery: value);
                },
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.eco, color: AppTheme.primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'UseUp',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                ],
              ),
        actions: [
          // 搜索开关按钮
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),

          // 【新增】筛选按钮
          // 如果正在搜索，也可以筛选
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.black),
                onPressed: _showFilterSheet,
              ),
              // 如果有筛选条件，显示一个小红点
              if (hasActiveFilters)
                Positioned(
                  right: 8, top: 8,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.alertOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
            
          if (!_isSearching)
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
            ),
        ],
      ),
      
      body: Column(
        children: [
          // 【新增】筛选条件展示条 (Chips)
          // 只有当有筛选条件时才显示
          if (hasActiveFilters)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Filters: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(width: 8),
                    // 分类 Chip
                    if (filterState.categoryName != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          label: Text(filterState.categoryName!),
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppTheme.primaryGreen),
                          onDeleted: () {
                            ref.read(dashboardFilterProvider.notifier).state = 
                                ref.read(dashboardFilterProvider).clearCategory();
                          },
                        ),
                      ),
                    // 位置 Chip
                    if (filterState.locationName != null)
                      InputChip(
                        label: Text(filterState.locationName!),
                        backgroundColor: AppTheme.softSage.withOpacity(0.3),
                        labelStyle: const TextStyle(color: Colors.black87),
                        onDeleted: () {
                          ref.read(dashboardFilterProvider.notifier).state = 
                              ref.read(dashboardFilterProvider).clearLocation();
                        },
                      ),
                  ],
                ),
              ),
            ),

          // 下面是原来的内容，用 Expanded 包裹，因为外层套了 Column
          Expanded(
            child: inventoryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (items) {
                final isFiltered = currentQuery.isNotEmpty || hasActiveFilters;

                // --- 搜索/筛选状态下的特殊处理 ---
                if (isFiltered) {
                   if (items.isEmpty) {
                      return Center(child: Text('No items found'));
                   }
                   return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => _buildItemTile(context, items[index]),
                   );
                }

                // --- 正常状态 (无搜索/筛选) ---
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No items yet', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }

                final expiringItems = items.where((i) {
                  if (i.expiryDate == null) return false;
                  final days = ExpiryUtils.daysRemaining(i.expiryDate!);
                  return days <= 5; 
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION 1: Expiring Soon
                        if (expiringItems.isNotEmpty) ...[
                          Text(l10n.sectionExpiringSoon, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: expiringItems.length,
                              itemBuilder: (context, index) {
                                return ExpiringCard(item: expiringItems[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // SECTION 2: All Items
                        Text(l10n.sectionAllItems, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _buildItemTile(context, items[index]);
                          },
                        ),
                        const SizedBox(height: 80), 
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l10n.addItem, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, Item item) {
    final days = item.expiryDate != null 
        ? ExpiryUtils.daysRemaining(item.expiryDate!) 
        : 999;
    
    return Card(
      child: ListTile(
        onTap: () => context.push('/item/${item.id}'),
        leading: Container(
          width: 50, 
          height: 50,
          clipBehavior: Clip.antiAlias, // 裁剪圆角
          decoration: BoxDecoration(
            color: AppTheme.softSage.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.imagePath != null
              ? Image.file(
                  File(item.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => _getCategoryIcon(item.categoryName), // 如果图片坏了，降级显示图标
                )
              : _getCategoryIcon(item.categoryName), // 没图显示默认图标
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${item.quantity} ${item.unit} • ${item.locationName}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ExpiryUtils.getColorForExpiry(days).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ExpiryUtils.getExpiryString(context, days),
            style: TextStyle(
              color: ExpiryUtils.getColorForExpiry(days),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String categoryName) {
    IconData icon;
    if (categoryName.contains('Vegetable') || categoryName.contains('蔬菜')) {
      icon = Icons.grass;
    } else if (categoryName.contains('Fruit') || categoryName.contains('水果')) {
      icon = Icons.apple;
    } else if (categoryName.contains('Meat') || categoryName.contains('肉')) {
      icon = Icons.kebab_dining;
    } else if (categoryName.contains('Dairy') || categoryName.contains('奶')) {
      icon = Icons.water_drop;
    } else if (categoryName.contains('Health') || categoryName.contains('药') || categoryName.contains('健康')) {
      icon = Icons.medical_services;
    } else if (categoryName.contains('Utility') || categoryName.contains('工具') || categoryName.contains('日用')) {
      icon = Icons.build;
    } else if (categoryName.contains('Food') || categoryName.contains('食品')) {
      icon = Icons.restaurant; 
    } else {
      icon = Icons.inventory_2_outlined;
    }
    return Icon(icon, color: AppTheme.primaryGreen);
  }
}