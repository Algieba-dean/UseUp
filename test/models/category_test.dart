import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/models/category.dart';

void main() {
  group('Category Model', () {
    test('should have correct default values', () {
      final category = Category(name: 'Food');

      expect(category.name, 'Food');
      expect(category.parentId, null);
      expect(category.level, 0);
      expect(category.sortOrder, 0.0);
    });

    test('should accept custom values', () {
      final category = Category(
        name: 'Dairy',
        parentId: 1,
        level: 1,
        sortOrder: 1.0,
      );

      expect(category.name, 'Dairy');
      expect(category.parentId, 1);
      expect(category.level, 1);
      expect(category.sortOrder, 1.0);
    });
  });
}
