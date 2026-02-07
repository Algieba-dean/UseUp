import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/utils/expiry_utils.dart';
import 'package:use_up/src/config/theme.dart';

void main() {
  group('ExpiryUtils', () {
    test('daysRemaining should calculate correct difference', () {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final tomorrow = today.add(const Duration(days: 1));
      expect(ExpiryUtils.daysRemaining(tomorrow), 1);

      final yesterday = today.subtract(const Duration(days: 1));
      expect(ExpiryUtils.daysRemaining(yesterday), -1);

      expect(ExpiryUtils.daysRemaining(today), 0);
      
      final tenDaysLater = today.add(const Duration(days: 10));
      expect(ExpiryUtils.daysRemaining(tenDaysLater), 10);
    });

    test('getColorForExpiry should return correct color based on days', () {
      expect(ExpiryUtils.getColorForExpiry(-1), Colors.grey);
      expect(ExpiryUtils.getColorForExpiry(-10), Colors.grey);
      expect(ExpiryUtils.getColorForExpiry(0), AppTheme.alertOrange);
      expect(ExpiryUtils.getColorForExpiry(1), AppTheme.alertOrange);
      expect(ExpiryUtils.getColorForExpiry(2), AppTheme.alertOrange);
      expect(ExpiryUtils.getColorForExpiry(3), const Color(0xFFFFB74D));
      expect(ExpiryUtils.getColorForExpiry(4), const Color(0xFFFFB74D));
      expect(ExpiryUtils.getColorForExpiry(5), const Color(0xFFFFB74D));
      expect(ExpiryUtils.getColorForExpiry(6), AppTheme.primaryGreen);
      expect(ExpiryUtils.getColorForExpiry(100), AppTheme.primaryGreen);
    });
  });
}
