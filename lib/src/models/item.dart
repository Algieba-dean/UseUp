import 'package:isar/isar.dart';
import 'location.dart';
import 'category.dart';

part 'item.g.dart';

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

  final categoryLink = IsarLink<Category>();
  String categoryName; // 缓存显示用
  
  // locationName 只是为了在列表页显示方便（缓存）
  @Index()
  String locationName; 
  
  final locationLink = IsarLink<Location>(); 

  String? imagePath; // Local path to image

  bool isConsumed; // For History/Archive - PRD 3.5
  
  DateTime? consumedDate; // Time when consumed

  Item({
    required this.name,
    this.barcode,
    this.quantity = 1.0,
    this.unit = 'pcs',
    this.expiryDate,
    required this.purchaseDate,
    this.categoryName = 'Unknown',
    this.locationName = 'Unknown', 
    this.imagePath,
    this.isConsumed = false,
    this.consumedDate,
  });
}
