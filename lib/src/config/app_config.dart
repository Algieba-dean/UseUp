import 'package:flutter/foundation.dart';

class AppConfig {
  /// 是否显示开发者选项
  /// 在 Release 模式下自动关闭
  /// 如果需要手动强制开启，可以改为 true
  static const bool showDeveloperOptions = !kReleaseMode;
}
