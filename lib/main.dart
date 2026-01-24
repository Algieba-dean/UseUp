import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/app.dart';
import 'src/models/item.dart';
import 'src/models/location.dart';
import 'src/models/category.dart';
import 'src/models/app_setting.dart';
import 'src/services/notification_service.dart';
import 'src/providers/locale_provider.dart';
import 'src/data/providers/database_provider.dart';
import 'src/config/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    [ItemSchema, LocationSchema, CategorySchema, AppSettingSchema], 
    directory: dir.path,
  );

  final prefs = await SharedPreferences.getInstance();
  const kIsDataSeededV1 = 'is_data_seeded_v1';
  final isSeeded = prefs.getBool(kIsDataSeededV1) ?? false;

  if (!isSeeded) {
    // 初始化数据
    await _seedDefaultLocations(isar);
    await _seedDefaultCategories(isar);

    // --- Merge duplicate "Misc" categories ---
    // Only merge if we have multiple system defaults (key = 'Misc')
    final miscCats = await isar.categorys
        .filter()
        .nameEqualTo(AppConstants.defaultCategoryMisc)
        .findAll();

    if (miscCats.length > 1) {
      final targetCat = miscCats.first;
      final sourceCats = miscCats.sublist(1);

      await isar.writeTxn(() async {
        for (var source in sourceCats) {
          // Move Items
          final items = await isar.items
              .filter()
              .categoryLink((q) => q.idEqualTo(source.id))
              .findAll();
          for (var item in items) {
            item.categoryLink.value = targetCat;
            item.categoryName = targetCat.name;
            await item.categoryLink.save();
            await isar.items.put(item);
          }
          // Move Sub-categories
          final subCats = await isar.categorys
              .filter()
              .parentIdEqualTo(source.id)
              .findAll();
          for (var sub in subCats) {
             sub.parentId = targetCat.id;
             await isar.categorys.put(sub);
          }
          // Delete Duplicate
          await isar.categorys.delete(source.id);
        }
      });
    }
    // ----------------------------------------
    
    await prefs.setBool(kIsDataSeededV1, true);
  }

  // 初始化通知
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  // 预读取语言设置
  final savedSettings = await isar.appSettings.get(AppConstants.settingRecordId);
  Locale? initialLocale;
  if (savedSettings?.languageCode != null && savedSettings!.languageCode!.isNotEmpty) {
    try {
      initialLocale = Locale(savedSettings.languageCode!);
    } catch (_) {
      // 如果解析失败，回退到默认（null 表示跟随系统）
      initialLocale = null;
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(isar),
        localeProvider.overrideWith((ref) => LocaleNotifier(isar, initialLocale)),
      ],
      child: const UseUpApp(),
    ),
  );
}

Future<void> _seedDefaultLocations(Isar isar) async {
  final count = await isar.locations.count();
  final hasOther = await isar.locations.filter()
      .nameEqualTo('其他').or().nameEqualTo(AppConstants.defaultLocationOther)
      .findFirst();
  
  await isar.writeTxn(() async {
    if (hasOther == null) {
      await isar.locations.put(Location(name: AppConstants.defaultLocationOther, level: 0));
    }
    if (count == 0) {
      final kitchen = Location(name: AppConstants.locKitchen, level: 0);
      await isar.locations.put(kitchen);
      await isar.locations.put(Location(name: AppConstants.locFridge, parentId: kitchen.id, level: 1));
      await isar.locations.put(Location(name: AppConstants.locPantry, parentId: kitchen.id, level: 1));
      await isar.locations.put(Location(name: AppConstants.locBathroom, level: 0));
    }
  });
}

Future<void> _seedDefaultCategories(Isar isar) async {
  final count = await isar.categorys.count(); 
  final hasMisc = await isar.categorys.filter()
      .nameEqualTo('杂物').or().nameEqualTo(AppConstants.defaultCategoryMisc)
      .findFirst();

  await isar.writeTxn(() async {
    if (hasMisc == null) {
      await isar.categorys.put(Category(name: AppConstants.defaultCategoryMisc, level: 0));
    }
    if (count == 0) {
      final food = Category(name: AppConstants.catFood, level: 0);
      await isar.categorys.put(food);
      await isar.categorys.put(Category(name: AppConstants.catVegetable, parentId: food.id, level: 1));
      await isar.categorys.put(Category(name: AppConstants.catMeat, parentId: food.id, level: 1));
      await isar.categorys.put(Category(name: AppConstants.catUtility, level: 0));
    }
  });
}
