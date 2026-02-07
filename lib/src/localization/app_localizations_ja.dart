// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'おはようございます';

  @override
  String get navHome => 'ホーム';

  @override
  String get navSettings => '設定';

  @override
  String get history => '履歴';

  @override
  String get sectionExpiringSoon => 'もうすぐ期限切れ';

  @override
  String get sectionAllItems => 'すべてのアイテム';

  @override
  String get scanItem => 'アイテムをスキャン';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '残り $count 日',
      one: '明日',
      zero: '今日',
    );
    return '$_temp0';
  }

  @override
  String get expired => '期限切れ';

  @override
  String get statusUrgent => '緊急';

  @override
  String get statusWarning => '警告';

  @override
  String get statusSafe => '安全';

  @override
  String get name => '名前';

  @override
  String get quantity => '数量';

  @override
  String get category => 'カテゴリー';

  @override
  String get location => '場所';

  @override
  String get price => '単価';

  @override
  String get expiryDate => '消費期限';

  @override
  String get productionDate => '製造日';

  @override
  String get shelfLife => '賞味期限（日）';

  @override
  String get purchaseDate => '購入日';

  @override
  String get pickDate => '日付を選択';

  @override
  String get toggleExpiryDate => '消費期限';

  @override
  String get toggleProductionDate => '製造日 + 賞味期限';

  @override
  String get reminderLabel => 'リマインダー';

  @override
  String get reminder1Day => '1日前';

  @override
  String get reminder3Days => '3日前';

  @override
  String get reminder7Days => '1週間前';

  @override
  String get advancedDetails => '詳細設定';

  @override
  String get advancedSubtitle => '数量、場所、価格など...';

  @override
  String calculatedExpiry(Object date) {
    return '計算された期限: $date';
  }

  @override
  String get testNotification => 'テスト通知';

  @override
  String get testNotificationSubtitle => 'クリックして通知をテスト';

  @override
  String get addItem => 'アイテムを追加';

  @override
  String get editItem => 'アイテムを編集';

  @override
  String get save => '保存';

  @override
  String get saveAndNext => '保存して次へ';

  @override
  String get updateItem => 'アイテムを更新';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get markAsUsed => '使用済み';

  @override
  String get restock => '補充';

  @override
  String get filter => 'フィルター';

  @override
  String get reset => 'リセット';

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '言語';

  @override
  String get switchLanguage => '言語を切り替え';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get manageCategories => 'カテゴリー管理';

  @override
  String get manageLocations => '場所の管理';

  @override
  String get manageMode => '管理モード';

  @override
  String get locationSelect => '場所を選択';

  @override
  String get locationAdd => '場所を追加';

  @override
  String get locationAddSub => 'サブの場所を追加';

  @override
  String get locationRename => '名前を変更';

  @override
  String get locationDeleteTitle => '場所を削除しますか？';

  @override
  String get locationName => '場所の名前';

  @override
  String get categorySelect => 'カテゴリーを選択';

  @override
  String get categoryAdd => 'カテゴリーを追加';

  @override
  String get categoryAddSub => 'サブカテゴリーを追加';

  @override
  String get categoryRename => 'カテゴリー名を変更';

  @override
  String get categoryDeleteTitle => 'カテゴリーを削除しますか？';

  @override
  String get itemConsumed => '使用済みにしました！';

  @override
  String get deleteConfirm => 'アイテムが含まれているため削除できません。';

  @override
  String get confirmDelete => '本当に削除しますか？';

  @override
  String get deleteEmptyConfirm => 'このアイテムは空のため、直接削除されます。';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return '$count 個のアイテムを $target に移動します。';
  }

  @override
  String get deleteMigrateTitle => '削除して移行？';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return '$items 個のアイテムを \'$target\' に移動します。';
  }

  @override
  String get confirmAndMove => '確認して移動';

  @override
  String get cannotDeleteDefault => 'デフォルトの項目は削除できません！';

  @override
  String get containsSubItems => 'サブ項目が含まれています。';

  @override
  String errorDefaultNotFound(Object name) {
    return 'デフォルトの $name が見つかりません。';
  }

  @override
  String get errorNameExists => '名前が既に存在します。';

  @override
  String get searchHint => '検索...';

  @override
  String get noItemsFound => 'アイテムが見つかりません';

  @override
  String noItemsFoundFor(Object query) {
    return '$query の検索結果はありません';
  }

  @override
  String get filtersHeader => 'フィルター: ';

  @override
  String get emptyList => 'データなし';

  @override
  String get catVegetable => '野菜';

  @override
  String get catFruit => '果物';

  @override
  String get catMeat => '肉類';

  @override
  String get catDairy => '乳製品';

  @override
  String get catPantry => '食料庫';

  @override
  String get catSnack => 'お菓子';

  @override
  String get catHealth => '健康食品';

  @override
  String get catUtility => '日用品';

  @override
  String get unitPcs => '個';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'パック';

  @override
  String get unitBox => '箱';

  @override
  String get unitBag => '袋';

  @override
  String get unitBottle => '本';

  @override
  String get valOther => 'その他';

  @override
  String get valMisc => '未分類';

  @override
  String get valKitchen => '台所';

  @override
  String get valFridge => '冷蔵庫';

  @override
  String get valPantry => 'パントリー';

  @override
  String get valBathroom => '浴室';

  @override
  String get valFood => '食品';

  @override
  String get valBattery => '電池';

  @override
  String get imageGallery => 'ギャラリー';

  @override
  String get imageCamera => 'カメラ';

  @override
  String get errorNameRequired => '名前を入力してください';

  @override
  String get timeUnitDay => '日';

  @override
  String get timeUnitWeek => '週';

  @override
  String get timeUnitMonth => '月';

  @override
  String get timeUnitYear => '年';

  @override
  String get addReminder => 'リマインダーを追加';

  @override
  String get customReminderTitle => 'カスタムリマインダー';

  @override
  String get enterValue => '数値を入力';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get errorExpiryRequired => '期限日は必須です';

  @override
  String get deleteItemTitle => 'アイテムを削除しますか？';

  @override
  String get deleteItemContent => 'この操作は取り消せません。';

  @override
  String get filterExpired => '期限切れ';

  @override
  String get filterExpiringSoon => 'もうすぐ期限切れ';

  @override
  String get emptyInventoryPrompt => '在庫がありません！最初のアイテムを追加しましょう。';

  @override
  String get noExpiringItems => 'もうすぐ期限切れのアイテムはありません';

  @override
  String get noExpiredItems => '期限切れのアイテムはありません';

  @override
  String get feedbackTitle => 'フィードバックを送る';

  @override
  String get feedbackDialogTitle => 'UseUp を気に入りましたか？';

  @override
  String get feedbackDialogContent => 'フィードバックをお寄せください！';

  @override
  String get feedbackActionLove => '大好きです！';

  @override
  String get feedbackActionImprove => '改善してほしい';
}
