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
  String get deleteMigrateTitle => '删除并迁移？';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return '包含 $items 个物品和 $subs 个子项。\n它们将被移动到“$target”。';
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
  String get unitBag => '袋';

  @override
  String get unitBottle => '瓶';

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

  @override
  String get imageGallery => '相册';

  @override
  String get imageCamera => '相机';

  @override
  String get errorNameRequired => '请输入名称';

  @override
  String get timeUnitDay => '天';

  @override
  String get timeUnitWeek => '周';

  @override
  String get timeUnitMonth => '月';

  @override
  String get timeUnitYear => '年';

  @override
  String get addReminder => '添加提醒';

  @override
  String get customReminderTitle => '自定义提醒';

  @override
  String get enterValue => '输入数值';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get errorExpiryRequired => '必须设置过期日期';

  @override
  String get deleteItemTitle => '删除物品？';

  @override
  String get deleteItemContent => '此操作无法撤销。';

  @override
  String get filterExpired => '已过期';

  @override
  String get filterExpiringSoon => '临期';

  @override
  String get emptyInventoryPrompt => '你的冰箱空空如也！试着添加第一件物品吧。';

  @override
  String get noExpiringItems => '暂无临期物品';

  @override
  String get noExpiredItems => '暂无过期物品';

  @override
  String get feedbackTitle => '发送反馈 / 给个好评';

  @override
  String get feedbackDialogTitle => '喜欢 UseUp 吗？';

  @override
  String get feedbackDialogContent => '您的反馈能帮助我们做得更好！';

  @override
  String get feedbackActionLove => '非常喜欢！';

  @override
  String get feedbackActionImprove => '有待改进';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => '早安';

  @override
  String get navHome => '首頁';

  @override
  String get navSettings => '設定';

  @override
  String get history => '歷史記錄';

  @override
  String get sectionExpiringSoon => '即將過期';

  @override
  String get sectionAllItems => '所有物品';

  @override
  String get scanItem => '掃碼錄入';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '剩餘 $count 天',
      one: '明天',
      zero: '今天',
    );
    return '$_temp0';
  }

  @override
  String get expired => '已過期';

  @override
  String get statusUrgent => '緊急';

  @override
  String get statusWarning => '注意';

  @override
  String get statusSafe => '安全';

  @override
  String get name => '名稱';

  @override
  String get quantity => '數量';

  @override
  String get category => '分類';

  @override
  String get location => '位置';

  @override
  String get price => '單價';

  @override
  String get expiryDate => '過期日期';

  @override
  String get productionDate => '生產日期';

  @override
  String get shelfLife => '保質期 (天)';

  @override
  String get purchaseDate => '購買日期';

  @override
  String get pickDate => '選擇日期';

  @override
  String get toggleExpiryDate => '直接輸入過期日';

  @override
  String get toggleProductionDate => '生產日期 + 保質期';

  @override
  String get reminderLabel => '過期提醒';

  @override
  String get reminder1Day => '提前 1 天';

  @override
  String get reminder3Days => '提前 3 天';

  @override
  String get reminder7Days => '提前 1 週';

  @override
  String get advancedDetails => '更多資訊';

  @override
  String get advancedSubtitle => '數量、位置、價格等...';

  @override
  String calculatedExpiry(Object date) {
    return '計算出的過期日：$date';
  }

  @override
  String get testNotification => '測試通知';

  @override
  String get testNotificationSubtitle => '點擊立即發送一條測試通知';

  @override
  String get addItem => '新增物品';

  @override
  String get editItem => '編輯物品';

  @override
  String get save => '儲存';

  @override
  String get saveAndNext => '儲存並新增下一條';

  @override
  String get updateItem => '更新物品';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get delete => '刪除';

  @override
  String get markAsUsed => '標記已用';

  @override
  String get restock => '重新補貨';

  @override
  String get filter => '篩選';

  @override
  String get reset => '重置';

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '語言';

  @override
  String get switchLanguage => '切換語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get manageCategories => '分類管理';

  @override
  String get manageLocations => '位置管理';

  @override
  String get manageMode => '管理模式';

  @override
  String get locationSelect => '選擇位置';

  @override
  String get locationAdd => '新建位置';

  @override
  String get locationAddSub => '新建子位置';

  @override
  String get locationRename => '重新命名位置';

  @override
  String get locationDeleteTitle => '刪除位置？';

  @override
  String get locationName => '位置名稱';

  @override
  String get categorySelect => '選擇分類';

  @override
  String get categoryAdd => '新建分類';

  @override
  String get categoryAddSub => '新建子分類';

  @override
  String get categoryRename => '重新命名分類';

  @override
  String get categoryDeleteTitle => '刪除分類？';

  @override
  String get itemConsumed => '物品已標記為消耗！';

  @override
  String get deleteConfirm => '該位置/分類包含物品或子項，無法直接刪除。';

  @override
  String get confirmDelete => '確認要刪除嗎？';

  @override
  String get deleteEmptyConfirm => '此項為空，將直接刪除。';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return '包含 $count 個物品。物品將被移動到 $target。';
  }

  @override
  String get deleteMigrateTitle => '刪除並遷移？';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return '包含 $items 個物品和 $subs 個子項。\n它們將被移動到「$target」。';
  }

  @override
  String get confirmAndMove => '確認並移動';

  @override
  String get cannotDeleteDefault => '無法刪除預設項！';

  @override
  String get containsSubItems => '包含子項，請先刪除子項。';

  @override
  String errorDefaultNotFound(Object name) {
    return '錯誤：未找到預設項 $name。';
  }

  @override
  String get errorNameExists => '該名稱已存在。';

  @override
  String get searchHint => '搜尋物品...';

  @override
  String get noItemsFound => '未找到物品';

  @override
  String noItemsFoundFor(Object query) {
    return '未找到 $query 相關物品';
  }

  @override
  String get filtersHeader => '篩選條件：';

  @override
  String get emptyList => '暫無數據';

  @override
  String get catVegetable => '蔬菜';

  @override
  String get catFruit => '水果';

  @override
  String get catMeat => '肉類';

  @override
  String get catDairy => '奶製品';

  @override
  String get catPantry => '儲藏室';

  @override
  String get catSnack => '零食';

  @override
  String get catHealth => '藥品/保健';

  @override
  String get catUtility => '日用品';

  @override
  String get unitPcs => '個';

  @override
  String get unitKg => '公斤';

  @override
  String get unitG => '克';

  @override
  String get unitL => '公升';

  @override
  String get unitMl => '毫升';

  @override
  String get unitPack => '包';

  @override
  String get unitBox => '盒';

  @override
  String get unitBag => '袋';

  @override
  String get unitBottle => '瓶';

  @override
  String get valOther => '其他';

  @override
  String get valMisc => '未分類';

  @override
  String get valKitchen => '廚房';

  @override
  String get valFridge => '冰箱';

  @override
  String get valPantry => '儲藏室';

  @override
  String get valBathroom => '浴室';

  @override
  String get valFood => '食品';

  @override
  String get valBattery => '電池';

  @override
  String get imageGallery => '相册';

  @override
  String get imageCamera => '相機';

  @override
  String get errorNameRequired => '請輸入名稱';

  @override
  String get timeUnitDay => '天';

  @override
  String get timeUnitWeek => '週';

  @override
  String get timeUnitMonth => '月';

  @override
  String get timeUnitYear => '年';

  @override
  String get addReminder => '新增提醒';

  @override
  String get customReminderTitle => '自訂提醒';

  @override
  String get enterValue => '輸入數值';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get errorExpiryRequired => '必須設置過期日期';

  @override
  String get deleteItemTitle => '刪除物品？';

  @override
  String get deleteItemContent => '此操作無法撤回。';

  @override
  String get filterExpired => '已過期';

  @override
  String get filterExpiringSoon => '臨期';

  @override
  String get emptyInventoryPrompt => '您的冰箱空空如也！試著新增第一件物品吧。';

  @override
  String get noExpiringItems => '暫無臨期物品';

  @override
  String get noExpiredItems => '暫無過期物品';

  @override
  String get feedbackTitle => '發送回饋 / 給個好評';

  @override
  String get feedbackDialogTitle => '喜歡 UseUp 嗎？';

  @override
  String get feedbackDialogContent => '您的回饋能幫助我們做得更好！';

  @override
  String get feedbackActionLove => '非常喜歡！';

  @override
  String get feedbackActionImprove => '有待改進';
}
