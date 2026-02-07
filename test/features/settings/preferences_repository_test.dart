import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:use_up/src/features/settings/data/preferences_repository.dart';
import 'package:use_up/src/config/constants.dart';

void main() {
  group('PreferencesRepository', () {
    late PreferencesRepository repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = PreferencesRepository();
    });

    test('getDefaultLocationId returns null initially', () async {
      final id = await repository.getDefaultLocationId();
      expect(id, null);
    });

    test('setDefaultLocationId saves value', () async {
      await repository.setDefaultLocationId(123);
      final id = await repository.getDefaultLocationId();
      expect(id, 123);
    });

    test('getDefaultCategoryId returns null initially', () async {
      final id = await repository.getDefaultCategoryId();
      expect(id, null);
    });

    test('setDefaultCategoryId saves value', () async {
      await repository.setDefaultCategoryId(456);
      final id = await repository.getDefaultCategoryId();
      expect(id, 456);
    });
  });
}
