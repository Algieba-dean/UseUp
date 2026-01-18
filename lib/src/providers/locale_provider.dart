import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../main.dart'; 
import '../models/app_setting.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  // 初始状态为 null (跟随系统)，或者由 main 注入
  LocaleNotifier([Locale? initial]) : super(initial);

  // 1. 初始化：从数据库读取设置
  Future<void> loadSettings() async {
    final settings = await isarInstance.appSettings.get(0);
    if (settings?.languageCode != null) {
      state = Locale(settings!.languageCode!);
    } else {
      state = null; // 数据库没存，就跟随系统
    }
  }

  // 2. 修改：设置并保存
  Future<void> setLocale(Locale? locale) async {
    state = locale; // 立即更新 UI
    
    // 异步存入数据库
    await isarInstance.writeTxn(() async {
      final settings = await isarInstance.appSettings.get(0) ?? AppSetting();
      settings.languageCode = locale?.languageCode;
      await isarInstance.appSettings.put(settings);
    });
  }
}

// 定义 Provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});