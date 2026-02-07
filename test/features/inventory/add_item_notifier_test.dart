import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/features/inventory/providers/add_item_notifier.dart';
import 'package:use_up/src/features/inventory/data/inventory_repository.dart';
import 'package:use_up/src/models/location.dart';
import 'package:use_up/src/models/category.dart';
import 'package:use_up/src/models/item.dart';

// Mock Repository
// Note: Isar native libraries might cause crashes in some test environments without proper setup.
class MockInventoryRepository implements InventoryRepository {
  @override
  Future<Location?> getDefaultLocation() async {
    return Location(name: 'DefaultLoc');
  }

  @override
  Future<Category?> getDefaultCategory() async {
    return Category(name: 'DefaultCat');
  }

  @override
  Future<void> loadLinks(Item item) async {}

  @override
  noSuchMethod(Invocation invocation) {
    return null;
  }
}

void main() {
  late AddItemNotifier notifier;
  late MockInventoryRepository mockRepo;

  setUp(() {
    mockRepo = MockInventoryRepository();
    notifier = AddItemNotifier(mockRepo);
  });

  group('AddItemNotifier - Basic Updates', () {
    test('updateName updates state', () {
      notifier.updateName('New Name');
      expect(notifier.debugState.name, 'New Name');
    });

    test('updateQuantity updates state', () {
      notifier.updateQuantity('5.5');
      expect(notifier.debugState.quantity, 5.5);
    });

    test('updateQuantity handles invalid input', () {
      notifier.updateQuantity('abc');
      expect(notifier.debugState.quantity, 1.0); // Default
    });

    test('updateUnit updates state', () {
      notifier.updateUnit('kg');
      expect(notifier.debugState.unit, 'kg');
    });

    test('updatePrice updates state', () {
      notifier.updatePrice('12.99');
      expect(notifier.debugState.price, 12.99);
    });
    
    test('toggleProductionMode updates state', () {
      notifier.toggleProductionMode(true);
      expect(notifier.debugState.isProductionMode, true);
    });
  });

  group('AddItemNotifier - Shelf Life & Unit Tests', () {
    test('Initial state is correct', () {
      final state = notifier.debugState;
      expect(state.shelfLifeUnit, TimeUnit.day);
      expect(state.shelfLifeDays, null);
    });

    test('updateShelfLifeAndUnit (Month) calculates days and expiry correctly', () {
      final now = DateTime(2023, 1, 1);
      notifier.toggleProductionMode(true);
      notifier.updateProductionDate(now);
      
      // Update to 2 Months (2 * 30 = 60 days)
      notifier.updateShelfLife('2');
      notifier.updateShelfLifeUnit(TimeUnit.month);
      
      final state = notifier.debugState;
      expect(state.shelfLifeDays, 60);
      expect(state.expiryDate, now.add(const Duration(days: 60)));
      expect(state.shelfLifeUnit, TimeUnit.month);
    });

    test('updateShelfLifeAndUnit (Year) calculates days and expiry correctly', () {
      final now = DateTime(2023, 1, 1);
      notifier.toggleProductionMode(true);
      notifier.updateProductionDate(now);
      
      // Update to 1 Year (365 days)
      notifier.updateShelfLife('1');
      notifier.updateShelfLifeUnit(TimeUnit.year);
      
      final state = notifier.debugState;
      expect(state.shelfLifeDays, 365);
      expect(state.expiryDate, now.add(const Duration(days: 365)));
      expect(state.shelfLifeUnit, TimeUnit.year);
    });
    
    test('updateShelfLifeAndUnit (Week) calculates days and expiry correctly', () {
      final now = DateTime(2023, 1, 1);
      notifier.toggleProductionMode(true);
      notifier.updateProductionDate(now);
      
      // Update to 3 Weeks (21 days)
      notifier.updateShelfLife('3');
      notifier.updateShelfLifeUnit(TimeUnit.week);
      
      final state = notifier.debugState;
      expect(state.shelfLifeDays, 21);
      expect(state.expiryDate, now.add(const Duration(days: 21)));
      expect(state.shelfLifeUnit, TimeUnit.week);
    });

    test('Updating production date recalculates expiry with existing shelf life', () {
      final now = DateTime(2023, 1, 1);
      notifier.toggleProductionMode(true);
      notifier.updateProductionDate(now);
      notifier.updateShelfLife('10');
      notifier.updateShelfLifeUnit(TimeUnit.day);
      
      var state = notifier.debugState;
      expect(state.expiryDate, DateTime(2023, 1, 11));

      // Change production date
      final newDate = DateTime(2023, 2, 1);
      notifier.updateProductionDate(newDate);
      
      state = notifier.debugState;
      expect(state.expiryDate, DateTime(2023, 2, 11));
    });
  });

  group('AddItemNotifier - Custom Reminder Tests', () {
    test('Initial notify days list', () {
      expect(notifier.debugState.notifyDaysList, [1, 3]);
    });

    test('addCustomNotifyDay adds week-based reminder correctly', () {
      // Add 2 Weeks (14 days)
      notifier.addCustomNotifyDay(2, TimeUnit.week);
      
      final list = notifier.debugState.notifyDaysList;
      expect(list, contains(14));
      expect(list.length, 3); // 1, 3, 14
    });

    test('addCustomNotifyDay adds month-based reminder correctly', () {
      // Add 1 Month (30 days)
      notifier.addCustomNotifyDay(1, TimeUnit.month);
      
      final list = notifier.debugState.notifyDaysList;
      expect(list, contains(30));
    });
    
    test('addCustomNotifyDay sorts the list', () {
      notifier.addCustomNotifyDay(2, TimeUnit.day); // Add 2
      
      final list = notifier.debugState.notifyDaysList;
      expect(list, [1, 2, 3]); // Sorted
    });

    test('addCustomNotifyDay does not add duplicates', () {
      notifier.addCustomNotifyDay(1, TimeUnit.week); // 7 days
      notifier.addCustomNotifyDay(7, TimeUnit.day); // 7 days again
      
      final list = notifier.debugState.notifyDaysList;
      expect(list.where((e) => e == 7).length, 1);
    });
    
    test('toggleNotifyDay removes existing day', () {
      notifier.toggleNotifyDay(1); // Remove default 1
      expect(notifier.debugState.notifyDaysList, isNot(contains(1)));
    });
  });
}
