import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../localization/app_localizations.dart';
import '../inventory/providers/inventory_provider.dart'; // 导入新 Provider
import 'widgets/expiring_card.dart';
import '../../config/theme.dart';
import '../../utils/expiry_utils.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    // 监听数据库流
    final inventoryAsync = ref.watch(inventoryProvider);

    return Scaffold(
      backgroundColor: AppTheme.neutralGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralGrey,
        elevation: 0,
        title: Row(
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
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
          ),
        ],
      ),
      
      // 处理异步数据状态
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          // 如果没数据，显示空状态
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

          // 筛选即将过期的物品 (有过期时间 且 剩余天数 <= 5)
          final expiringItems = items.where((i) {
            if (i.expiryDate == null) return false;
            final days = ExpiryUtils.daysRemaining(i.expiryDate!);
            return days <= 5; // UI Doc 定义: 5天内算即将过期
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION 1: Expiring Soon ---
                  // 只有当有即将过期的物品时才显示这个区域
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

                  // --- SECTION 2: All Items ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.sectionAllItems, style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      // 计算天数
                      final days = item.expiryDate != null 
                          ? ExpiryUtils.daysRemaining(item.expiryDate!) 
                          : 999;
                      
                      return Card(
                        child: ListTile(
                          onTap: () {
                            context.push('/item/${item.id}');
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.softSage.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // 这里可以根据 item.categoryName 显示不同图标
                            child: _getCategoryIcon(item.categoryName),
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
                    },
                  ),
                  // 底部留白，防止被 FAB 遮挡
                  const SizedBox(height: 80), 
                ],
              ),
            ),
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
           context.push('/add');
        },
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l10n.addItem, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  // 辅助方法：根据分类返回图标
  Widget _getCategoryIcon(String categoryName) {
    IconData icon;
    // 简单的关键词匹配
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