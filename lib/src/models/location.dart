import 'package:isar/isar.dart';

part 'location.g.dart';

@collection
class Location {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  // 父级ID，如果为 null 则表示是一级目录（如“厨房”）
  int? parentId; 

  // 层级深度 (0=Room, 1=Furniture, 2=Section)
  int level; 

  Location({
    required this.name,
    this.parentId,
    this.level = 0,
  });
}