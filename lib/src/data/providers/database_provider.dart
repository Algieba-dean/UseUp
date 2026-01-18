import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// 定义一个 Provider，初始抛出异常（将在 main.dart 中通过 override 注入真实实例）
// 这样做的好处是：测试时可以注入一个内存数据库，而不用修改业务代码。
final databaseProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Database must be initialized in main.dart');
});
