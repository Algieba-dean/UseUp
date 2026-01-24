// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '尽用';

  @override
  String get welcomeGreeting => '早上好';

  @override
  String get navHome => '首页';

  @override
  String get navSettings => '设置';

  @override
  String get history => '历史记录';

  @override
  String get sectionExpiringSoon => '即将过期';

  @override
  String get sectionAllItems => '所有物品';

  @override
  String get scanItem => '扫码录入';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '剩 $count 天',
      one: '明天',
      zero: '今天',
    );
    return '$_temp0';
  }

  @override
  String get expired => '已过期';

  @override
  String get statusUrgent => '紧急';

  @override
  String get statusWarning => '注意';

  @override
  String get statusSafe => '安全';

  @override
  String get name => '名称';

  @override
  String get quantity => '数量';

  @override
  String get category => '分类';

  @override
  String get location => '位置';

  @override
  String get price => '单价';

  @override
  String get expiryDate => '过期日期';

  @override
  String get productionDate => '生产日期';

  @override
  String get shelfLife => '保质期 (天)';

  @override
  String get purchaseDate => '购买日期';

  @override
  String get pickDate => '选择日期';

  @override
  String get toggleExpiryDate => '直接输入过期日';

  @override
  String get toggleProductionDate => '生产日期 + 保质期';

  @override
  String get reminderLabel => '过期提醒';

  @override
  String get reminder1Day => '提前 1 天';

  @override
  String get reminder3Days => '提前 3 天';

  @override
  String get reminder7Days => '提前 1 周';

  @override
  String get advancedDetails => '更多信息';

  @override
  String get advancedSubtitle => '数量、位置、价格等...';

  @override
  String calculatedExpiry(Object date) {
    return '计算出的过期日：$date';
  }

  @override
  String get testNotification => '测试通知';

  @override
  String get testNotificationSubtitle => '点击立即发送一条测试通知';

  @override
  String get addItem => '添加物品';

  @override
  String get editItem => '编辑物品';

  @override
  String get save => '保存';

  @override
  String get saveAndNext => '保存并添加下一条';

  @override
  String get updateItem => '更新物品';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get delete => '删除';

  @override
  String get markAsUsed => '标记已用';

  @override
  String get restock => '重新补货';

  @override
  String get filter => '筛选';

  @override
  String get reset => '重置';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get switchLanguage => '切换语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get manageCategories => '分类管理';

  @override
  String get manageLocations => '位置管理';

  @override
  String get manageMode => '管理模式';

  @override
  String get locationSelect => '选择位置';

  @override
  String get locationAdd => '新建位置';

  @override
  String get locationAddSub => '新建子位置';

  @override
  String get locationRename => '重命名位置';

  @override
  String get locationDeleteTitle => '删除位置？';

  @override
  String get locationName => '位置名称';

  @override
  String get categorySelect => '选择分类';

  @override
  String get categoryAdd => '新建分类';

  @override
  String get categoryAddSub => '新建子分类';

  @override
  String get categoryRename => '重命名分类';

  @override
  String get categoryDeleteTitle => '删除分类？';

  @override
  String get itemConsumed => '物品已标记为消耗！';

  @override
  String get deleteConfirm => '该位置/分类包含物品或子项，无法直接删除。';

  @override
  String get confirmDelete => '确认要删除吗？';

  @override
  String get deleteEmptyConfirm => '此项为空，将直接删除。';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return '包含 $count 个物品。物品将被移动到 $target。';
  }

  @override
  String get confirmAndMove => '确认并移动';

  @override
  String get cannotDeleteDefault => '无法删除默认项！';

  @override
  String get containsSubItems => '包含子项，请先删除子项。';

  @override
  String errorDefaultNotFound(Object name) {
    return '错误：未找到默认项 $name。';
  }

  @override
  String get errorNameExists => '该名称已存在。';

  @override
  String get searchHint => '搜索物品...';

  @override
  String get noItemsFound => '未找到物品';

  @override
  String noItemsFoundFor(Object query) {
    return '未找到 $query 相关物品';
  }

  @override
  String get filtersHeader => '筛选条件：';

  @override
  String get emptyList => '暂无数据';

  @override
  String get catVegetable => '蔬菜';

  @override
  String get catFruit => '水果';

  @override
  String get catMeat => '肉类';

  @override
  String get catDairy => '奶制品';

  @override
  String get catPantry => '储藏室';

  @override
  String get catSnack => '零食';

  @override
  String get catHealth => '药品/保健';

  @override
  String get catUtility => '日用品';

  @override
  String get unitPcs => '个';

  @override
  String get unitKg => '千克';

  @override
  String get unitG => '克';

  @override
  String get unitL => '升';

  @override
  String get unitMl => '毫升';

  @override
  String get unitPack => '包';

  @override
  String get unitBox => '盒';

  @override
  String get valOther => '其他';

  @override
  String get valMisc => '未分类';

  @override
  String get valKitchen => '厨房';

  @override
  String get valFridge => '冰箱';

  @override
  String get valPantry => '储藏室';

  @override
  String get valBathroom => '浴室';

  @override
  String get valFood => '食品';

  @override
  String get valBattery => '电池';
}
