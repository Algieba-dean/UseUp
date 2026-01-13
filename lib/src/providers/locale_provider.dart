import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 定义一个 StateProvider 来管理当前的 Locale
// 默认 null 表示跟随系统
final localeProvider = StateProvider<Locale?>((ref) => null);

// 辅助方法：切换语言
void toggleLocale(WidgetRef ref) {
  final current = ref.read(localeProvider);
  if (current == const Locale('en')) {
    ref.read(localeProvider.notifier).state = const Locale('zh');
  } else {
    ref.read(localeProvider.notifier).state = const Locale('en');
  }
}
