import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:use_up/src/config/theme.dart';
import 'package:use_up/src/models/item.dart';
import 'package:use_up/src/utils/expiry_utils.dart';

class ExpiringCard extends StatelessWidget {
  final Item item;

  const ExpiringCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final days = ExpiryUtils.daysRemaining(item.expiryDate!);
    final color = ExpiryUtils.getColorForExpiry(days);

    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push('/item/${item.id}');
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.neutralWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 这里的 Icon 换成图片
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              foregroundColor: color,
              backgroundImage: item.imagePath != null 
                  ? FileImage(File(item.imagePath!)) 
                  : null,
              child: item.imagePath == null 
                  ? const Icon(Icons.fastfood) // 默认图标
                  : null, 
            ),
            const Spacer(),
            Text(
              item.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: color),
                const SizedBox(width: 4),
                // Updated to use localized string
                Text(
                  ExpiryUtils.getExpiryString(context, days),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}