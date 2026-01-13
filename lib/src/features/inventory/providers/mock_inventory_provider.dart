import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/item.dart';

final mockInventoryProvider = Provider<List<Item>>((ref) {
  final now = DateTime.now();
  return [
    Item(
      name: 'Milk',
      quantity: 1,
      unit: 'L',
      categoryName: 'Dairy',
      locationName: 'Fridge',
      purchaseDate: now.subtract(const Duration(days: 2)),
      expiryDate: now.add(const Duration(days: 1)), // 1天后过期 (紧急)
    ),
    Item(
      name: 'Face Mask', // Changed from Spinach
      quantity: 50,
      unit: 'pcs',
      categoryName: 'Health', // Changed from Vegetable
      locationName: 'Cabinet', // Changed from Fridge
      purchaseDate: now.subtract(const Duration(days: 1)),
      expiryDate: now.add(const Duration(days: 4)), // 4天后过期 (警告)
    ),
    Item(
      name: 'Batteries (AA)', // Changed from Pasta Sauce
      quantity: 12,
      unit: 'pcs',
      categoryName: 'Utility', // Changed from Pantry
      locationName: 'Drawer', // Changed from Pantry
      purchaseDate: now.subtract(const Duration(days: 10)),
      expiryDate: now.add(const Duration(days: 365)), // 很久 (安全)
    ),
    Item(
      name: 'Yogurt',
      quantity: 6,
      unit: 'pcs',
      categoryName: 'Dairy',
      locationName: 'Fridge',
      purchaseDate: now.subtract(const Duration(days: 5)),
      expiryDate: now.subtract(const Duration(days: 1)), // 已过期
    ),
  ];
});