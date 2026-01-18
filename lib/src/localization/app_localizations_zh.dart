// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => '早上好';

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
  String get navHome => '首页';

  @override
  String get navSettings => '设置';

  @override
  String get addItem => '添加物品';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get switchLanguage => '切换语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get name => '名称';

  @override
  String get quantity => '数量';

  @override
  String get category => '分类';

  @override
  String get location => '位置';

  @override
  String get expiryDate => '过期日期';

  @override
  String get pickDate => '选择日期';

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
  String get catUtility => '杂物';

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
  String get locationSelect => '选择位置';

  @override
  String get locationAdd => '新建位置';

  @override
  String get locationName => '位置名称';

  @override
  String get delete => '删除';

  @override
  String get deleteConfirm => '该位置包含物品或子位置，无法删除。';

  @override
  String get confirm => '确认';

  @override
  String get markAsUsed => '标记已用';

  @override
  String get itemConsumed => '物品已标记为消耗！';

  @override
  String get history => '历史记录';

  @override
  String get restock => '重新补货';
}
