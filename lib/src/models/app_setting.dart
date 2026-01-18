import 'package:isar/isar.dart';

part 'app_setting.g.dart';

@collection
class AppSetting {
  Id id = 0; // 固定 ID = 0，确保只有一个配置对象 (单例模式)

  String? languageCode; // 'en', 'zh' 或 null (null 代表跟随系统)
}
