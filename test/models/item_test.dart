import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/models/item.dart';

void main() {
  group('Item Model', () {
    test('should have correct default values', () {
      final now = DateTime.now();
      final item = Item(
        name: 'Test Item',
        purchaseDate: now,
      );

      expect(item.name, 'Test Item');
      expect(item.quantity, 1.0);
      expect(item.unit, 'pcs');
      expect(item.purchaseDate, now);
      expect(item.notifyDaysList, [1, 3]);
      expect(item.categoryName, 'Unknown');
      expect(item.locationName, 'Other');
      expect(item.isConsumed, false);
      expect(item.price, null);
      expect(item.expiryDate, null);
    });

    test('should accept custom values', () {
      final now = DateTime.now();
      final expiry = now.add(const Duration(days: 10));
      final item = Item(
        name: 'Milk',
        quantity: 2.0,
        unit: 'L',
        price: 5.0,
        purchaseDate: now,
        expiryDate: expiry,
        notifyDaysList: [1],
        categoryName: 'Dairy',
        locationName: 'Fridge',
        isConsumed: true,
        consumedDate: now,
        imagePath: '/path/to/image',
        barcode: '123456',
      );

      expect(item.name, 'Milk');
      expect(item.quantity, 2.0);
      expect(item.unit, 'L');
      expect(item.price, 5.0);
      expect(item.expiryDate, expiry);
      expect(item.notifyDaysList, [1]);
      expect(item.categoryName, 'Dairy');
      expect(item.locationName, 'Fridge');
      expect(item.isConsumed, true);
      expect(item.consumedDate, now);
      expect(item.imagePath, '/path/to/image');
      expect(item.barcode, '123456');
    });
  });
}
