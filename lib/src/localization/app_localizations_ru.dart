// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Доброе утро';

  @override
  String get navHome => 'Главная';

  @override
  String get navSettings => 'Настройки';

  @override
  String get history => 'История';

  @override
  String get sectionExpiringSoon => 'Истекают скоро';

  @override
  String get sectionAllItems => 'Все предметы';

  @override
  String get scanItem => 'Сканировать предмет';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось $count дн.',
      one: 'Завтра',
      zero: 'Сегодня',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Истек срок';

  @override
  String get statusUrgent => 'Срочно';

  @override
  String get statusWarning => 'Внимание';

  @override
  String get statusSafe => 'Безопасно';

  @override
  String get name => 'Название';

  @override
  String get quantity => 'Количество';

  @override
  String get category => 'Категория';

  @override
  String get location => 'Местоположение';

  @override
  String get price => 'Цена за единицу';

  @override
  String get expiryDate => 'Срок годности';

  @override
  String get productionDate => 'Дата производства';

  @override
  String get shelfLife => 'Срок хранения (дн.)';

  @override
  String get purchaseDate => 'Дата покупки';

  @override
  String get pickDate => 'Выбрать дату';

  @override
  String get toggleExpiryDate => 'Срок годности';

  @override
  String get toggleProductionDate => 'Дата пр-ва + срок';

  @override
  String get reminderLabel => 'Напоминание';

  @override
  String get reminder1Day => 'За 1 день';

  @override
  String get reminder3Days => 'За 3 дня';

  @override
  String get reminder7Days => 'За 1 неделю';

  @override
  String get advancedDetails => 'Дополнительно';

  @override
  String get advancedSubtitle => 'Кол-во, место, цена...';

  @override
  String calculatedExpiry(Object date) {
    return 'Расчетный срок: $date';
  }

  @override
  String get testNotification => 'Тестовое уведомление';

  @override
  String get testNotificationSubtitle => 'Нажмите для проверки оповещения';

  @override
  String get addItem => 'Добавить предмет';

  @override
  String get editItem => 'Редактировать';

  @override
  String get save => 'Сохранить';

  @override
  String get saveAndNext => 'Сохранить и след.';

  @override
  String get updateItem => 'Обновить';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get delete => 'Удалить';

  @override
  String get markAsUsed => 'Использовано';

  @override
  String get restock => 'Пополнить';

  @override
  String get filter => 'Фильтр';

  @override
  String get reset => 'Сброс';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get switchLanguage => 'Сменить язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get manageCategories => 'Управление категориями';

  @override
  String get manageLocations => 'Управление местами';

  @override
  String get manageMode => 'Режим управления';

  @override
  String get locationSelect => 'Выбрать место';

  @override
  String get locationAdd => 'Добавить место';

  @override
  String get locationAddSub => 'Добавить под-место';

  @override
  String get locationRename => 'Переименовать';

  @override
  String get locationDeleteTitle => 'Удалить место?';

  @override
  String get locationName => 'Название места';

  @override
  String get categorySelect => 'Выбрать категорию';

  @override
  String get categoryAdd => 'Добавить категорию';

  @override
  String get categoryAddSub => 'Добавить под-категорию';

  @override
  String get categoryRename => 'Переименовать';

  @override
  String get categoryDeleteTitle => 'Удалить категорию?';

  @override
  String get itemConsumed => 'Предмет отмечен как использованный!';

  @override
  String get deleteConfirm => 'Содержит предметы. Удаление невозможно.';

  @override
  String get confirmDelete => 'Вы уверены, что хотите удалить?';

  @override
  String get deleteEmptyConfirm => 'Предмет пуст и будет удален.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Переместить $count предм. в $target.';
  }

  @override
  String get deleteMigrateTitle => 'Удалить и переместить?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Переместить $items предм. в \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Подтвердить и переместить';

  @override
  String get cannotDeleteDefault => 'Нельзя удалить стандартный элемент!';

  @override
  String get containsSubItems => 'Содержит под-элементы.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Стандартный $name не найден.';
  }

  @override
  String get errorNameExists => 'Имя уже существует.';

  @override
  String get searchHint => 'Поиск...';

  @override
  String get noItemsFound => 'Предметы не найдены';

  @override
  String noItemsFoundFor(Object query) {
    return 'Ничего не найдено по запросу $query';
  }

  @override
  String get filtersHeader => 'Фильтры: ';

  @override
  String get emptyList => 'Пусто';

  @override
  String get catVegetable => 'Овощи';

  @override
  String get catFruit => 'Фрукты';

  @override
  String get catMeat => 'Мясо';

  @override
  String get catDairy => 'Молочные продукты';

  @override
  String get catPantry => 'Кладовая';

  @override
  String get catSnack => 'Снеки';

  @override
  String get catHealth => 'Здоровье';

  @override
  String get catUtility => 'Хозтовары';

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
  String get unitBottle => 'бут';

  @override
  String get valOther => 'Другое';

  @override
  String get valMisc => 'Разное';

  @override
  String get valKitchen => 'Кухня';

  @override
  String get valFridge => 'Холодильник';

  @override
  String get valPantry => 'Кладовая';

  @override
  String get valBathroom => 'Ванная';

  @override
  String get valFood => 'Еда';

  @override
  String get valBattery => 'Батарейки';

  @override
  String get imageGallery => 'Галерея';

  @override
  String get imageCamera => 'Камера';

  @override
  String get errorNameRequired => 'Введите название';

  @override
  String get timeUnitDay => 'День';

  @override
  String get timeUnitWeek => 'Неделя';

  @override
  String get timeUnitMonth => 'Месяц';

  @override
  String get timeUnitYear => 'Год';

  @override
  String get addReminder => 'Добавить напоминание';

  @override
  String get customReminderTitle => 'Свое напоминание';

  @override
  String get enterValue => 'Введите значение';

  @override
  String get privacyPolicy => 'Конфиденциальность';

  @override
  String get errorExpiryRequired => 'Укажите срок годности';

  @override
  String get deleteItemTitle => 'Удалить предмет?';

  @override
  String get deleteItemContent => 'Это действие нельзя отменить.';

  @override
  String get filterExpired => 'Истек срок';

  @override
  String get filterExpiringSoon => 'Истекают скоро';

  @override
  String get emptyInventoryPrompt =>
      'Ваш список пуст! Добавьте первый предмет.';

  @override
  String get noExpiringItems => 'Нет предметов с истекающим сроком';

  @override
  String get noExpiredItems => 'Нет просроченных предметов';

  @override
  String get feedbackTitle => 'Оставить отзыв';

  @override
  String get feedbackDialogTitle => 'Нравится UseUp?';

  @override
  String get feedbackDialogContent => 'Ваш отзыв помогает нам стать лучше!';

  @override
  String get feedbackActionLove => 'Очень нравится!';

  @override
  String get feedbackActionImprove => 'Нужно улучшить';
}
