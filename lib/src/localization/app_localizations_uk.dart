// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Доброго ранку';

  @override
  String get navHome => 'Головна';

  @override
  String get navSettings => 'Налаштування';

  @override
  String get history => 'Історія';

  @override
  String get sectionExpiringSoon => 'Скоро закінчиться';

  @override
  String get sectionAllItems => 'Усі предмети';

  @override
  String get scanItem => 'Сканувати предмет';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Залишилось $count дн.',
      one: 'Завтра',
      zero: 'Сьогодні',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Термін вийшов';

  @override
  String get statusUrgent => 'Терміново';

  @override
  String get statusWarning => 'Увага';

  @override
  String get statusSafe => 'Безпечно';

  @override
  String get name => 'Назва';

  @override
  String get quantity => 'Кількість';

  @override
  String get category => 'Категорія';

  @override
  String get location => 'Місце';

  @override
  String get price => 'Ціна за од.';

  @override
  String get expiryDate => 'Термін придатності';

  @override
  String get productionDate => 'Дата виробництва';

  @override
  String get shelfLife => 'Термін зберігання (дн.)';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get pickDate => 'Вибрати дату';

  @override
  String get toggleExpiryDate => 'Термін придатності';

  @override
  String get toggleProductionDate => 'Дата вир-ва + термін';

  @override
  String get reminderLabel => 'Нагадування';

  @override
  String get reminder1Day => 'За 1 день';

  @override
  String get reminder3Days => 'За 3 дні';

  @override
  String get reminder7Days => 'За 1 тиждень';

  @override
  String get advancedDetails => 'Додатково';

  @override
  String get advancedSubtitle => 'К-сть, місце, ціна...';

  @override
  String calculatedExpiry(Object date) {
    return 'Розрахунковий термін: $date';
  }

  @override
  String get testNotification => 'Тестове сповіщення';

  @override
  String get testNotificationSubtitle => 'Натисніть для перевірки';

  @override
  String get addItem => 'Додати предмет';

  @override
  String get editItem => 'Редагувати';

  @override
  String get save => 'Зберегти';

  @override
  String get saveAndNext => 'Зберегти і далі';

  @override
  String get updateItem => 'Оновити';

  @override
  String get cancel => 'Скасувати';

  @override
  String get confirm => 'Підтвердити';

  @override
  String get delete => 'Видалити';

  @override
  String get markAsUsed => 'Використано';

  @override
  String get restock => 'Поповнити';

  @override
  String get filter => 'Фільтр';

  @override
  String get reset => 'Скинути';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get language => 'Мова';

  @override
  String get switchLanguage => 'Змінити мову';

  @override
  String get selectLanguage => 'Вибрати мову';

  @override
  String get manageCategories => 'Керування категоріями';

  @override
  String get manageLocations => 'Керування місцями';

  @override
  String get manageMode => 'Режим керування';

  @override
  String get locationSelect => 'Вибрати місце';

  @override
  String get locationAdd => 'Додати місце';

  @override
  String get locationAddSub => 'Додати під-місце';

  @override
  String get locationRename => 'Перейменувати';

  @override
  String get locationDeleteTitle => 'Видалити місце?';

  @override
  String get locationName => 'Назва місця';

  @override
  String get categorySelect => 'Вибрати категорію';

  @override
  String get categoryAdd => 'Додати категорію';

  @override
  String get categoryAddSub => 'Добавить під-категорію';

  @override
  String get categoryRename => 'Перейменувати';

  @override
  String get categoryDeleteTitle => 'Видалити категорію?';

  @override
  String get itemConsumed => 'Предмет позначено як використаний!';

  @override
  String get deleteConfirm => 'Містить предмети. Видалення неможливе.';

  @override
  String get confirmDelete => 'Ви впевнені, що хочете видалити?';

  @override
  String get deleteEmptyConfirm => 'Цей предмет порожній і буде видалений.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Перемістити $count предм. у $target.';
  }

  @override
  String get deleteMigrateTitle => 'Видалити і перемістити?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Перемістити $items предм. у \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Підтвердити і перемістити';

  @override
  String get cannotDeleteDefault => 'Неможливо видалити стандартний елемент!';

  @override
  String get containsSubItems => 'Містить під-елементи.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Стандартний $name не знайдено.';
  }

  @override
  String get errorNameExists => 'Ім\'я вже існує.';

  @override
  String get searchHint => 'Пошук...';

  @override
  String get noItemsFound => 'Предмети не знайдено';

  @override
  String noItemsFoundFor(Object query) {
    return 'Нічого не знайдено за запитом $query';
  }

  @override
  String get filtersHeader => 'Фільтри: ';

  @override
  String get emptyList => 'Порожньо';

  @override
  String get catVegetable => 'Овочі';

  @override
  String get catFruit => 'Фрукти';

  @override
  String get catMeat => 'М\'ясо';

  @override
  String get catDairy => 'Молочні продукти';

  @override
  String get catPantry => 'Комора';

  @override
  String get catSnack => 'Снеки';

  @override
  String get catHealth => 'Здоров\'я';

  @override
  String get catUtility => 'Госптовари';

  @override
  String get unitPcs => 'шт';

  @override
  String get unitKg => 'кг';

  @override
  String get unitG => 'г';

  @override
  String get unitL => 'л';

  @override
  String get unitMl => 'мл';

  @override
  String get unitPack => 'уп';

  @override
  String get unitBox => 'кор';

  @override
  String get unitBag => 'пакет';

  @override
  String get unitBottle => 'пляшка';

  @override
  String get valOther => 'Інше';

  @override
  String get valMisc => 'Різне';

  @override
  String get valKitchen => 'Кухня';

  @override
  String get valFridge => 'Холодильник';

  @override
  String get valPantry => 'Комора';

  @override
  String get valBathroom => 'Ванна';

  @override
  String get valFood => 'Їжа';

  @override
  String get valBattery => 'Батарейка';

  @override
  String get imageGallery => 'Галерея';

  @override
  String get imageCamera => 'Камера';

  @override
  String get errorNameRequired => 'Введіть назву';

  @override
  String get timeUnitDay => 'День';

  @override
  String get timeUnitWeek => 'Тиждень';

  @override
  String get timeUnitMonth => 'Місяць';

  @override
  String get timeUnitYear => 'Рік';

  @override
  String get addReminder => 'Додати нагадування';

  @override
  String get customReminderTitle => 'Своє нагадування';

  @override
  String get enterValue => 'Введіть значення';

  @override
  String get privacyPolicy => 'Конфіденційність';

  @override
  String get errorExpiryRequired => 'Вкажіть термін придатності';

  @override
  String get deleteItemTitle => 'Видалити предмет?';

  @override
  String get deleteItemContent => 'Цю дію неможливо скасувати.';

  @override
  String get filterExpired => 'Термін вийшов';

  @override
  String get filterExpiringSoon => 'Скоро закінчиться';

  @override
  String get emptyInventoryPrompt =>
      'Ваш список порожній! Додайте перший предмет.';

  @override
  String get noExpiringItems => 'Немає предметів, термін яких добігає кінця';

  @override
  String get noExpiredItems => 'Немає прострочених предметів';

  @override
  String get feedbackTitle => 'Залишити відгук';

  @override
  String get feedbackDialogTitle => 'Подобається UseUp?';

  @override
  String get feedbackDialogContent =>
      'Ваш відгук допомагає нам ставати кращими!';

  @override
  String get feedbackActionLove => 'Дуже подобається!';

  @override
  String get feedbackActionImprove => 'Потрібно покращити';
}
