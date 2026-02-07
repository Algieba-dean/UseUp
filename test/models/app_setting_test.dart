import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/models/app_setting.dart';

void main() {
  group('AppSetting Model', () {
    test('should have default values', () {
      final setting = AppSetting();
      expect(setting.id, 0);
      expect(setting.languageCode, null);
    });

    test('should allow setting language code', () {
      final setting = AppSetting();
      setting.languageCode = 'zh';
      expect(setting.languageCode, 'zh');
    });
  });
}
