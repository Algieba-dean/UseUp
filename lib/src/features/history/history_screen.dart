import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../../config/theme.dart';
import '../../models/item.dart';
import '../../data/providers/database_provider.dart';

final historyProvider = StreamProvider<List<Item>>((ref) {
  final isar = ref.watch(databaseProvider);
  return isar.items
      .filter()
      .isConsumedEqualTo(true)
      .sortByConsumedDateDesc()
      .watch(fireImmediately: true);
});

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(l10n.history, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(l10n.emptyList, style: TextStyle(color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildHistoryCard(context, item, ref, l10n);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Item item, WidgetRef ref, AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: const Icon(Icons.check, color: Colors.grey),
        ),
        title: Text(
          item.name,
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${item.quantity} ${item.unit}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            Text(
              'Used: ${item.consumedDate != null ? DateFormat('MM-dd HH:mm').format(item.consumedDate!) : '-'}',
              style: TextStyle(color: Colors.grey[400], fontSize: 10),
            ),
          ],
        ),
        trailing: TextButton.icon(
          onPressed: () => _restockItem(ref, item, context),
          icon: const Icon(Icons.refresh, size: 16),
          label: Text(l10n.restock),
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.primaryGreen,
            backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
          ),
        ),
      ),
    );
  }

  Future<void> _restockItem(WidgetRef ref, Item oldItem, BuildContext context) async {
    final isar = ref.read(databaseProvider);
    final newItem = Item(
      name: oldItem.name,
      quantity: oldItem.quantity,
      unit: oldItem.unit,
      purchaseDate: DateTime.now(),
      expiryDate: null,
      categoryName: oldItem.categoryName,
      locationName: oldItem.locationName,
      isConsumed: false,
    );
    
    await isar.writeTxn(() async {
      await isar.items.put(newItem);
      newItem.categoryLink.value = oldItem.categoryLink.value;
      newItem.locationLink.value = oldItem.locationLink.value;
      await newItem.categoryLink.save();
      await newItem.locationLink.save();
    });

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newItem.name} restocked!')),
      );
    }
  }
}
