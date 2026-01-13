import 'package:isar/isar.dart';

part 'category.g.dart';

@collection
class Category {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String name;

  int? parentId; // 父级ID

  short level; // 0=大类, 1=子类

  Category({
    required this.name,
    this.parentId,
    this.level = 0,
  });
}
