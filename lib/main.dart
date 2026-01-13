import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'src/app.dart';
import 'src/models/item.dart';
import 'src/models/location.dart';
import 'src/models/category.dart';

// 定义一个全局 Provider 来获取 Isar 实例
late Isar isarInstance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 获取文档目录
  final dir = await getApplicationDocumentsDirectory();

  // 2. 打开 Isar 数据库
  isarInstance = await Isar.open(
    [ItemSchema, LocationSchema, CategorySchema], 
    directory: dir.path,
  );

  // 初始化默认位置数据
  await _seedDefaultLocations();
  await _seedDefaultCategories();

  runApp(
    const ProviderScope(
      child: UseUpApp(),
    ),
  );
}

Future<void> _seedDefaultLocations() async {
  final count = await isarInstance.locations.count();
  if (count == 0) {
    // 检测系统语言，如果是中文，初始化中文数据
    // 这里简单起见，我们直接写入中文
    
    await isarInstance.writeTxn(() async {
      // 1. 厨房 (一级)
      final kitchen = Location(name: '厨房', level: 0);
      await isarInstance.locations.put(kitchen);

      // 1.1 冰箱 (二级) -> 属于厨房
      final fridge = Location(name: '冰箱', parentId: kitchen.id, level: 1);
      await isarInstance.locations.put(fridge);
      
      // 1.2 橱柜 (二级) -> 属于厨房
      final cabinet = Location(name: '橱柜', parentId: kitchen.id, level: 1);
      await isarInstance.locations.put(cabinet);

      // 2. 浴室 (一级)
      final bathroom = Location(name: '浴室', level: 0);
      await isarInstance.locations.put(bathroom);
    });
  }
}

Future<void> _seedDefaultCategories() async {
  final count = await isarInstance.categorys.count(); // 注意 Isar 生成的复数可能是 categorys
  if (count == 0) {
    await isarInstance.writeTxn(() async {
      // 1. 食品 (一级)
      final food = Category(name: '食品', level: 0);
      await isarInstance.categorys.put(food);

      // 1.1 蔬菜 (二级)
      await isarInstance.categorys.put(Category(name: '蔬菜', parentId: food.id, level: 1));
      // 1.2 肉类 (二级)
      await isarInstance.categorys.put(Category(name: '肉类', parentId: food.id, level: 1));
      
      // 2. 日用品 (一级)
      final utility = Category(name: '日用品', level: 0);
      await isarInstance.categorys.put(utility);
      
      // 2.1 电池 (二级)
      await isarInstance.categorys.put(Category(name: '电池', parentId: utility.id, level: 1));
    });
  }
}
