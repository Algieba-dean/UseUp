import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/features/inventory/providers/add_item_notifier.dart';

void main() {
  group('AddItemState', () {
    test('initial values', () {
      final state = AddItemState();
      expect(state.name, '');
      expect(state.quantity, 1.0);
      expect(state.unit, 'pcs');
      expect(state.isLoading, false);
      expect(state.isProductionMode, false);
    });

    test('copyWith updates fields', () {
      final state = AddItemState();
      final newState = state.copyWith(
        name: 'Milk',
        quantity: 2.0,
        unit: 'L',
        isLoading: true,
      );

      expect(newState.name, 'Milk');
      expect(newState.quantity, 2.0);
      expect(newState.unit, 'L');
      expect(newState.isLoading, true);
    });

    test('copyWith clearExpiryDate works', () {
      final now = DateTime.now();
      final state = AddItemState(expiryDate: now);
      expect(state.expiryDate, now);

      final newState = state.copyWith(clearExpiryDate: true);
      expect(newState.expiryDate, null);
    });
  });
}
