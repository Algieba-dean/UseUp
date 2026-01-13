import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../../main.dart'; // 引入全局 isarInstance
import '../../../models/item.dart';

// 这个 Provider 会监听 Isar 数据库的变化
// 一旦数据库有变动（添加/删除），它会自动通知 UI 刷新
final inventoryProvider = StreamProvider<List<Item>>((ref) {
  // 1. 查询所有物品
  // 2. 按过期时间排序 (expiryDate)
  // 3. 监听变化 (.watch(fireImmediately: true))
  return isarInstance.items
      .where()
      .sortByExpiryDate() // Isar 自动生成的方法
      .watch(fireImmediately: true);
});
