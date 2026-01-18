import 'package:isar/isar.dart';
import 'location.dart';
import 'category.dart'; 

part 'item.g.dart';

 @collection
class Item {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name; // 一级：物品名

  double quantity; // 二级：数量 (默认 1)
  String unit; // 二级：单位

  double? price; // 二级：单价 (新增)

  DateTime? productionDate; // 二级：生产日期 (新增)
  int? shelfLifeDays; // 二级：保质期天数 (新增，用于计算)

  DateTime purchaseDate; // 二级：购买日期 (默认今天)
  DateTime? expiryDate; // 一级：到期时间 (核心)

  List<int> notifyDaysList; // 一级：提前几天提醒 (支持多选)

  // 关联
  final categoryLink = IsarLink<Category>();
  String categoryName; 

  final locationLink = IsarLink<Location>(); 
  String locationName;

  String? imagePath; // Local path to image

  // 状态
  @Index()
  bool isConsumed; 
  DateTime? consumedDate; 

  String? barcode; // 保留之前的 barcode 字段

  Item({
    required this.name,
    this.quantity = 1.0,
    this.unit = 'pcs',
    this.price,
    required this.purchaseDate,
    this.expiryDate,
    this.productionDate,
    this.shelfLifeDays,
    this.notifyDaysList = const [1, 3], // 默认提前1天和3天
    this.categoryName = 'Unknown',
    this.locationName = 'Other', // 默认位置名为 Other
    this.isConsumed = false, 
    this.consumedDate,
    this.imagePath,
    this.barcode,
  });
}