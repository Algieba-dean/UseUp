import 'package:flutter/material.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import '../config/theme.dart';

class ExpiryUtils {
  // 计算剩余天数 (保持不变)
  static int daysRemaining(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  // 颜色逻辑 (保持不变)
  static Color getColorForExpiry(int days) {
    if (days < 0) return Colors.grey;
    if (days <= 2) return AppTheme.alertOrange;
    if (days <= 5) return const Color(0xFFFFB74D);
    return AppTheme.primaryGreen;
  }

  // 修改：不再返回硬编码字符串，而是使用 localized context
  static String getExpiryString(BuildContext context, int days) {
    final l10n = AppLocalizations.of(context)!;
    
    if (days < 0) {
      return l10n.expired;
    }
    // 使用 ARB 文件中定义的 plural 逻辑
    return l10n.daysLeft(days);
  }
}