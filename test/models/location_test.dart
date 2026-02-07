import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/models/location.dart';

void main() {
  group('Location Model', () {
    test('should have correct default values', () {
      final location = Location(name: 'Kitchen');

      expect(location.name, 'Kitchen');
      expect(location.parentId, null);
      expect(location.level, 0);
      expect(location.sortOrder, 0.0);
    });

    test('should accept custom values', () {
      final location = Location(
        name: 'Fridge',
        parentId: 1,
        level: 1,
        sortOrder: 1.0,
      );

      expect(location.name, 'Fridge');
      expect(location.parentId, 1);
      expect(location.level, 1);
      expect(location.sortOrder, 1.0);
    });
  });
}
