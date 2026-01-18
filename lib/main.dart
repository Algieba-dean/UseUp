import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'src/models/item.dart';
import 'src/models/location.dart';
import 'src/models/category.dart';
import 'src/models/app_setting.dart';
import 'src/services/notification_service.dart';
import 'src/providers/locale_provider.dart';

// 定义一个全局 Provider 来获取 Isar 实例
late Isar isarInstance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 获取文档目录
  final dir = await getApplicationDocumentsDirectory();

  // 2. 打开 Isar 数据库
  isarInstance = await Isar.open(
    [ItemSchema, LocationSchema, CategorySchema, AppSettingSchema], 
    directory: dir.path,
  );

  // 初始化默认位置数据
  await _seedDefaultLocations();
  await _seedDefaultCategories();

  // --- Data Migration (Fix missing links) ---
  final allItems = await isarInstance.items.where().findAll();
  final otherLoc = await isarInstance.locations.filter().nameEqualTo('Other').or().nameEqualTo('其他').findFirst();
  final miscCat = await isarInstance.categorys.filter().nameEqualTo('Misc').or().nameEqualTo('杂物').findFirst();

  if (otherLoc != null && miscCat != null) {
    await isarInstance.writeTxn(() async {
      for (var item in allItems) {
        await item.locationLink.load();
        await item.categoryLink.load();
        
        bool changed = false;
        if (item.locationLink.value == null) {
          item.locationLink.value = otherLoc;
          item.locationName = otherLoc.name;
          await item.locationLink.save();
          changed = true;
        }
        if (item.categoryLink.value == null) {
          item.categoryLink.value = miscCat;
          item.categoryName = miscCat.name;
          await item.categoryLink.save();
          changed = true;
        }
        if (changed) {
           await isarInstance.items.put(item);
        }
      }
    });
  }
  // ----------------------------------------

  // 3. 初始化通知服务
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermissions();

  // 4. 预读取语言设置
  final savedSettings = await isarInstance.appSettings.get(0);
  Locale? initialLocale;
  if (savedSettings?.languageCode != null) {
    initialLocale = Locale(savedSettings!.languageCode!);
  }

  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith((ref) => LocaleNotifier(initialLocale)),
      ],
      child: const UseUpApp(),
    ),
  );
}

Future<void> _seedDefaultLocations() async {
  final count = await isarInstance.locations.count();
  
  // Ensure "Other" exists
  final hasOther = await isarInstance.locations.filter().nameEqualTo('其他').or().nameEqualTo('Other').findFirst();
  
  await isarInstance.writeTxn(() async {
    if (hasOther == null) {
      final otherLoc = Location(name: 'Other', level: 0);
      await isarInstance.locations.put(otherLoc);
    }

    if (count == 0) {
      // 1. 厨房 (一级)
      final kitchen = Location(name: 'Kitchen', level: 0);
      await isarInstance.locations.put(kitchen);

      // 1.1 冰箱 (二级) -> 属于厨房
      final fridge = Location(name: 'Fridge', parentId: kitchen.id, level: 1);
      await isarInstance.locations.put(fridge);
      
      // 1.2 橱柜 (二级) -> 属于厨房
      final cabinet = Location(name: 'Pantry', parentId: kitchen.id, level: 1);
      await isarInstance.locations.put(cabinet);

      // 2. 浴室 (一级)
      final bathroom = Location(name: 'Bathroom', level: 0);
      await isarInstance.locations.put(bathroom);
    }
  });
}

Future<void> _seedDefaultCategories() async {
  final count = await isarInstance.categorys.count(); 
  
  // Ensure "Misc" exists
  final hasMisc = await isarInstance.categorys.filter().nameEqualTo('杂物').or().nameEqualTo('Misc').findFirst();

  await isarInstance.writeTxn(() async {
    if (hasMisc == null) {
      final misc = Category(name: 'Misc', level: 0);
      await isarInstance.categorys.put(misc);
    }

    if (count == 0) {
      // 1. 食品 (一级)
      final food = Category(name: 'Food', level: 0);
      await isarInstance.categorys.put(food);

      // 1.1 蔬菜 (二级)
      await isarInstance.categorys.put(Category(name: 'Vegetable', parentId: food.id, level: 1));
      // 1.2 肉类 (二级)
      await isarInstance.categorys.put(Category(name: 'Meat', parentId: food.id, level: 1));
      
      // 2. 日用品 (一级)
      final utility = Category(name: 'Utility', level: 0);
      await isarInstance.categorys.put(utility);
    }
  });
}
