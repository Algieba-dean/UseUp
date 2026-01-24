import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/item.dart';
import '../../utils/expiry_utils.dart';
import 'add_item_screen.dart';
import '../../services/notification_service.dart';
import '../../data/providers/database_provider.dart';
import 'data/inventory_repository.dart';
import '../../utils/localized_utils.dart';

class ItemDetailScreen extends ConsumerWidget {
  final int itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isar = ref.watch(databaseProvider);

    return StreamBuilder<Item?>(
      stream: isar.items.watchObject(itemId, fireImmediately: true),
      builder: (context, snapshot) {
        final item = snapshot.data;

        if (item == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddItemScreen(itemToEdit: item))),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _deleteItem(context, ref, itemId),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imagePath != null)
                  Container(
                    width: double.infinity, height: 200, margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: FileImage(File(item.imagePath!)), fit: BoxFit.cover)),
                  ),
                Text(item.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${item.quantity} ${LocalizedUtils.getLocalizedUnit(context, item.unit)}', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
                const SizedBox(height: 32),
                _buildExpiryCard(color, expiryString, item),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildInfoCard(context, Icons.category_outlined, "Category", item.categoryName)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfoCard(context, Icons.place_outlined, "Location", item.locationName)),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _consumeItem(context, ref, item),
            backgroundColor: AppTheme.primaryGreen,
            icon: const Icon(Icons.check),
            label: Text(AppLocalizations.of(context)!.markAsUsed),
          ),
        );
      },
    );
  }

  Widget _buildExpiryCard(Color color, String expiryString, Item item) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(children: [
        Icon(Icons.timer_outlined, size: 48, color: color),
        const SizedBox(height: 12),
        Text(expiryString, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        if (item.expiryDate != null)
          Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Expires: ${DateFormat('yyyy-MM-dd').format(item.expiryDate!)}', style: TextStyle(color: color.withOpacity(0.8)))),
      ]),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Icon(icon, size: 18, color: Colors.grey), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))]),
        const SizedBox(height: 8),
        Text(LocalizedUtils.getLocalizedName(context, value), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Future<void> _deleteItem(BuildContext context, WidgetRef ref, int id) async {
    final confirm = await _showConfirmDialog(context, "Delete Item?", "This cannot be undone.");
    if (confirm == true) {
      await ref.read(inventoryRepositoryProvider).deleteItem(id);
      await NotificationService().cancelNotification(id);
      if (context.mounted) context.pop();
    }
  }

  Future<void> _consumeItem(BuildContext context, WidgetRef ref, Item item) async {
    await ref.read(inventoryRepositoryProvider).consumeItem(item);
    await NotificationService().cancelNotification(item.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.itemConsumed)));
      context.pop();
    }
  }

  Future<bool?> _showConfirmDialog(BuildContext context, String title, String content) {
    return showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: Text(title), content: Text(content),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Delete')),
      ],
    ));
  }
}