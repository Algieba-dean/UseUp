import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/features/dashboard/providers/dashboard_filter_provider.dart';

void main() {
  group('DashboardFilter', () {
    test('Initial state', () {
      final filter = DashboardFilter();
      expect(filter.searchQuery, '');
      expect(filter.categoryId, null);
      expect(filter.locationId, null);
      expect(filter.status, FilterStatus.all);
    });

    test('copyWith updates fields', () {
      final filter = DashboardFilter();
      final newFilter = filter.copyWith(
        searchQuery: 'apple',
        categoryId: 1,
        categoryName: 'Fruit',
        status: FilterStatus.expiringSoon,
      );

      expect(newFilter.searchQuery, 'apple');
      expect(newFilter.categoryId, 1);
      expect(newFilter.categoryName, 'Fruit');
      expect(newFilter.status, FilterStatus.expiringSoon);
      expect(newFilter.locationId, null); // Unchanged
    });

    test('clearCategory clears category fields', () {
      final filter = DashboardFilter(
        categoryId: 1,
        categoryName: 'Fruit',
        searchQuery: 'apple',
      );
      
      final cleared = filter.clearCategory();
      
      expect(cleared.categoryId, null);
      expect(cleared.categoryName, null);
      expect(cleared.searchQuery, 'apple'); // Preserved
    });
    
    test('clearLocation clears location fields', () {
      final filter = DashboardFilter(
        locationId: 1,
        locationName: 'Fridge',
        searchQuery: 'apple',
      );
      
      final cleared = filter.clearLocation();
      
      expect(cleared.locationId, null);
      expect(cleared.locationName, null);
      expect(cleared.searchQuery, 'apple'); // Preserved
    });
  });

  group('dashboardFilterProvider', () {
    test('defaults to empty filter', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final filter = container.read(dashboardFilterProvider);
      expect(filter.searchQuery, '');
      expect(filter.categoryId, null);
    });
  });
}
