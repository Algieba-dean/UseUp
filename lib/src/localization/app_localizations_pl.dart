// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Dzień dobry';

  @override
  String get navHome => 'Główna';

  @override
  String get navSettings => 'Ustawienia';

  @override
  String get history => 'Historia';

  @override
  String get sectionExpiringSoon => 'Wkrótce wygaśnie';

  @override
  String get sectionAllItems => 'Wszystkie przedmioty';

  @override
  String get scanItem => 'Skanuj przedmiot';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pozostało $count dni',
      one: 'Jutro',
      zero: 'Dzisiaj',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Wygasło';

  @override
  String get statusUrgent => 'Pilne';

  @override
  String get statusWarning => 'Ostrzeżenie';

  @override
  String get statusSafe => 'Bezpieczne';

  @override
  String get name => 'Nazwa';

  @override
  String get quantity => 'Ilość';

  @override
  String get category => 'Kategoria';

  @override
  String get location => 'Lokalizacja';

  @override
  String get price => 'Cena jedn.';

  @override
  String get expiryDate => 'Data ważności';

  @override
  String get productionDate => 'Data produkcji';

  @override
  String get shelfLife => 'Okres trwałości (dni)';

  @override
  String get purchaseDate => 'Data zakupu';

  @override
  String get pickDate => 'Wybierz datę';

  @override
  String get toggleExpiryDate => 'Data ważności';

  @override
  String get toggleProductionDate => 'Data prod. + trwałość';

  @override
  String get reminderLabel => 'Przypomnienie';

  @override
  String get reminder1Day => '1 dzień wcześniej';

  @override
  String get reminder3Days => '3 dni wcześniej';

  @override
  String get reminder7Days => '1 tydzień wcześniej';

  @override
  String get advancedDetails => 'Szczegóły zaawansowane';

  @override
  String get advancedSubtitle => 'Ilość, lokalizacja, cena...';

  @override
  String calculatedExpiry(Object date) {
    return 'Obliczone wygaśnięcie: $date';
  }

  @override
  String get testNotification => 'Powiadomienie testowe';

  @override
  String get testNotificationSubtitle => 'Kliknij, aby wywołać alert';

  @override
  String get addItem => 'Dodaj przedmiot';

  @override
  String get editItem => 'Edytuj przedmiot';

  @override
  String get save => 'Zapisz';

  @override
  String get saveAndNext => 'Zapisz i następny';

  @override
  String get updateItem => 'Aktualizuj przedmiot';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get delete => 'Usuń';

  @override
  String get markAsUsed => 'Zużyte';

  @override
  String get restock => 'Uzupełnij';

  @override
  String get filter => 'Filtr';

  @override
  String get reset => 'Resetuj';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get language => 'Język';

  @override
  String get switchLanguage => 'Zmień język';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get manageCategories => 'Zarządzaj kategoriami';

  @override
  String get manageLocations => 'Zarządzaj lokalizacjami';

  @override
  String get manageMode => 'Tryb zarządzania';

  @override
  String get locationSelect => 'Wybierz lokalizację';

  @override
  String get locationAdd => 'Dodaj lokalizację';

  @override
  String get locationAddSub => 'Dodaj podlokalizację';

  @override
  String get locationRename => 'Zmień nazwę';

  @override
  String get locationDeleteTitle => 'Usunąć lokalizację?';

  @override
  String get locationName => 'Nazwa lokalizacji';

  @override
  String get categorySelect => 'Wybierz kategorię';

  @override
  String get categoryAdd => 'Dodaj kategorię';

  @override
  String get categoryAddSub => 'Dodaj podkategorię';

  @override
  String get categoryRename => 'Zmień nazwę';

  @override
  String get categoryDeleteTitle => 'Usunąć kategorię?';

  @override
  String get itemConsumed => 'Przedmiot oznaczony jako zużyty!';

  @override
  String get deleteConfirm => 'Zawiera przedmioty. Nie można usunąć.';

  @override
  String get confirmDelete => 'Czy na pewno chcesz usunąć?';

  @override
  String get deleteEmptyConfirm =>
      'Ten przedmiot jest pusty i zostanie usunięty.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Przenieś $count przedm. do $target.';
  }

  @override
  String get deleteMigrateTitle => 'Usuń i przenieś?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Przenieś $items przedm. do \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Potwierdź i przenieś';

  @override
  String get cannotDeleteDefault => 'Nie można usunąć elementu domyślnego!';

  @override
  String get containsSubItems => 'Zawiera podpozycje.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Domyślny $name nieznaleziony.';
  }

  @override
  String get errorNameExists => 'Nazwa już istnieje.';

  @override
  String get searchHint => 'Szukaj...';

  @override
  String get noItemsFound => 'Nie znaleziono przedmiotów';

  @override
  String noItemsFoundFor(Object query) {
    return 'Brak wyników dla $query';
  }

  @override
  String get filtersHeader => 'Filtry: ';

  @override
  String get emptyList => 'Puste';

  @override
  String get catVegetable => 'Warzywa';

  @override
  String get catFruit => 'Owoce';

  @override
  String get catMeat => 'Mięso';

  @override
  String get catDairy => 'Nabiał';

  @override
  String get catPantry => 'Spiżarnia';

  @override
  String get catSnack => 'Przekąski';

  @override
  String get catHealth => 'Zdrowie';

  @override
  String get catUtility => 'Narzędzia';

  @override
  String get unitPcs => 'szt';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'opakowanie';

  @override
  String get unitBox => 'pudełko';

  @override
  String get unitBag => 'torba';

  @override
  String get unitBottle => 'butelka';

  @override
  String get valOther => 'Inne';

  @override
  String get valMisc => 'Różne';

  @override
  String get valKitchen => 'Kuchnia';

  @override
  String get valFridge => 'Lodówka';

  @override
  String get valPantry => 'Spiżarnia';

  @override
  String get valBathroom => 'Łazienka';

  @override
  String get valFood => 'Żywność';

  @override
  String get valBattery => 'Bateria';

  @override
  String get imageGallery => 'Galeria';

  @override
  String get imageCamera => 'Aparat';

  @override
  String get errorNameRequired => 'Nazwa jest wymagana';

  @override
  String get timeUnitDay => 'Dzień';

  @override
  String get timeUnitWeek => 'Tydzień';

  @override
  String get timeUnitMonth => 'Miesiąc';

  @override
  String get timeUnitYear => 'Rok';

  @override
  String get addReminder => 'Dodaj przypomnienie';

  @override
  String get customReminderTitle => 'Własne przypomnienie';

  @override
  String get enterValue => 'Wprowadź wartość';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get errorExpiryRequired => 'Data ważności jest wymagana';

  @override
  String get deleteItemTitle => 'Usunąć przedmiot?';

  @override
  String get deleteItemContent => 'Tej operacji nie można cofnąć.';

  @override
  String get filterExpired => 'Wygasło';

  @override
  String get filterExpiringSoon => 'Wkrótce wygaśnie';

  @override
  String get emptyInventoryPrompt =>
      'Inwentarz pusty! Dodaj swój pierwszy przedmiot.';

  @override
  String get noExpiringItems => 'Brak przedmiotów kończących ważność';

  @override
  String get noExpiredItems => 'Brak przeterminowanych przedmiotów';

  @override
  String get feedbackTitle => 'Wyślij opinię';

  @override
  String get feedbackDialogTitle => 'Podoba Ci się UseUp?';

  @override
  String get feedbackDialogContent => 'Twoja opinia pomaga nam się rozwijać!';

  @override
  String get feedbackActionLove => 'Uwielbiam!';

  @override
  String get feedbackActionImprove => 'Może być lepiej';
}
