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
import '../../models/item.dart';         // 修正为 ../../

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inventoryAsync = ref.watch(inventoryProvider);
    // 获取当前是否有搜索词
    final currentQuery = ref.watch(dashboardFilterProvider).searchQuery;

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
                      DashboardFilter(searchQuery: value);
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
            
          if (!_isSearching)
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
            ),
        ],
      ),
      
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          // --- 搜索状态下的特殊处理 ---
          if (currentQuery.isNotEmpty) {
             if (items.isEmpty) {
                return Center(child: Text('No items found for "$currentQuery"'));
             }
             return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) => _buildItemTile(context, items[index]),
             );
          }

          // --- 正常状态 (无搜索) ---
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