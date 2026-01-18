import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:isar/isar.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/item.dart';
import '../../utils/expiry_utils.dart';
import '../../../main.dart';
import 'add_item_screen.dart';
import '../../services/notification_service.dart';

class ItemDetailScreen extends ConsumerWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  // 删除逻辑
  Future<void> _deleteItem(BuildContext context) async {
    // 弹窗确认
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await isarInstance.writeTxn(() async {
        await isarInstance.items.delete(itemId);
      });
      
      // Cancel notification outside transaction
      try {
        await NotificationService().cancelNotification(itemId);
      } catch (e) {
         debugPrint('Error canceling notification: $e');
      }

      if (context.mounted) {
        context.pop(); // 退回首页
      }
    }
  }

  Future<void> _consumeItem(BuildContext context, Item item) async {
    final l10n = AppLocalizations.of(context)!;
    
    await isarInstance.writeTxn(() async {
      // 1. 修改状态
      item.isConsumed = true;
      item.consumedDate = DateTime.now();
      
      // 2. 保存更新
      await isarInstance.items.put(item);
    });

    // 3. 取消通知 (移出事务)
    try {
      await NotificationService().cancelNotification(item.id);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.itemConsumed),
          action: SnackBarAction(
            label: 'Undo', // 提供撤销机会
            onPressed: () async {
               await isarInstance.writeTxn(() async {
                  item.isConsumed = false;
                  item.consumedDate = null;
                  await isarInstance.items.put(item);
               });
            },
          ),
        ),
      );
      context.pop(); // 返回首页
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 这里的 StreamBuilder 监听单个物品的变化
    // 如果你在编辑页修改了数据，回来这里会自动刷新
    return StreamBuilder<Item?>(
      stream: isarInstance.items.watchObject(itemId, fireImmediately: true),
      builder: (context, snapshot) {
        final item = snapshot.data;

        if (item == null) {
          // 处理删除后返回时 briefly 显示的空白
          // 或者 ID 不存在的情况
          return const Scaffold(
              backgroundColor: AppTheme.neutralGrey,
              body: Center(child: CircularProgressIndicator())
          );
        }

        final days = item.expiryDate != null 
            ? ExpiryUtils.daysRemaining(item.expiryDate!) 
            : 999;
        final color = ExpiryUtils.getColorForExpiry(days);
        final expiryString = ExpiryUtils.getExpiryString(context, days);

        return Scaffold(
          backgroundColor: AppTheme.neutralGrey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            actions: [
              // 编辑按钮
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  // 跳转到编辑页，传入 item
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddItemScreen(itemToEdit: item)),
                  );
                },
              ),
              // 删除按钮
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _deleteItem(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 0. 大图展示 (新增) ---
                if (item.imagePath != null)
                  Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: FileImage(File(item.imagePath!)),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                  ),

                // 1. 大标题 (Name)
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.quantity} ${item.unit}',
                  style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                ),
                
                const SizedBox(height: 32),

                // 2. 过期状态卡片
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.timer_outlined, size: 48, color: color),
                      const SizedBox(height: 12),
                      Text(
                        expiryString,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                      ),
                      if (item.expiryDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Expires: ${DateFormat('yyyy-MM-dd').format(item.expiryDate!)}',
                            style: TextStyle(color: color.withOpacity(0.8)),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. 详情 Grid (Category & Location)
                Row(
                  children: [
                    Expanded(child: _buildInfoCard(Icons.category_outlined, "Category", item.categoryName)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoCard(Icons.place_outlined, "Location", item.locationName)),
                  ],
                ),
              ],
            ),
          ),
          // 底部 "Consume" 按钮 (暂未实现具体逻辑，先做删除)
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _consumeItem(context, item), // 绑定新方法
            backgroundColor: AppTheme.primaryGreen,
            icon: const Icon(Icons.check),
            label: Text(AppLocalizations.of(context)!.markAsUsed),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
