import 'package:isar/isar.dart';

part 'item.g.dart'; // Isar generator will build this

@collection
class Item {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  String? barcode; // Barcode for scanning

  double quantity; // Supports 1.5 kg etc.
  
  String unit; // "pcs", "kg", "L"

  DateTime? expiryDate; // Critical for UseUp logic
  
  DateTime purchaseDate;

  @Index()
  String category; // "Vegetable", "Dairy"
  
  @Index()
  String location; // "Fridge", "Pantry" - PRD 3.3

  String? imagePath; // Local path to image

  bool isConsumed; // For History/Archive - PRD 3.5

  Item({
    required this.name,
    this.barcode,
    this.quantity = 1.0,
    this.unit = 'pcs',
    this.expiryDate,
    required this.purchaseDate,
    this.category = 'Uncategorized',
    this.location = 'Pantry',
    this.imagePath,
    this.isConsumed = false,
  });
}
