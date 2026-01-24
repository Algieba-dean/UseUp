import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  int? parentId;
  short level;

  double sortOrder;

  Category({
    required this.name,
    this.parentId,
    this.level = 0,
    this.sortOrder = 0.0,
  });
}
