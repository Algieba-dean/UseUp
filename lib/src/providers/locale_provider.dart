import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/app_setting.dart';
import '../data/providers/database_provider.dart';
import '../config/constants.dart';

class LocaleNotifier extends StateNotifier<Locale?> {
  final Isar _isar;

  LocaleNotifier(this._isar, [Locale? initial]) : super(initial);

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    await _isar.writeTxn(() async {
      final settings = await _isar.appSettings.get(AppConstants.settingRecordId) ?? AppSetting();
      settings.languageCode = locale?.languageCode;
      await _isar.appSettings.put(settings);
    });
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final isar = ref.watch(databaseProvider);
  return LocaleNotifier(isar);
});
