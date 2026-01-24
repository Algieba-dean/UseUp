import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:use_up/src/config/theme.dart';
import 'package:use_up/src/models/item.dart';
import 'package:use_up/src/utils/expiry_utils.dart';
import 'package:use_up/src/localization/app_localizations.dart';

import 'package:use_up/src/utils/localized_utils.dart';

class ExpiringCard extends StatelessWidget {
  final Item item;

  const ExpiringCard({super.key, required this.item});

  void _showImagePreview(BuildContext context, ImageProvider imageProvider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.9),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
            padding: const EdgeInsets.all(20),
            child: InteractiveViewer(
              child: Image(image: imageProvider, fit: BoxFit.contain),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = ExpiryUtils.daysRemaining(item.expiryDate!);
    final color = ExpiryUtils.getColorForExpiry(days);
    
    final ImageProvider? imageProvider = item.imagePath != null
        ? FileImage(File(item.imagePath!))
        : null;

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
            GestureDetector(
              onLongPress: () {
                if (imageProvider != null) {
                  _showImagePreview(context, imageProvider);
                }
              },
              child: Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.1),
                    image: imageProvider != null 
                        ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                  child: imageProvider == null
                      ? Icon(LocalizedUtils.getCategoryIcon(item.categoryName), color: AppTheme.primaryGreen)
                      : null,
                ),
              ),
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
            
            Text(
              '${item.quantity} ${LocalizedUtils.getLocalizedUnit(context, item.unit)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: color),
                const SizedBox(width: 4),
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
