// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Guten Morgen';

  @override
  String get navHome => 'Startseite';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get history => 'Verlauf';

  @override
  String get sectionExpiringSoon => 'Läuft bald ab';

  @override
  String get sectionAllItems => 'Alle Artikel';

  @override
  String get scanItem => 'Artikel scannen';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage',
      one: 'Morgen',
      zero: 'Heute',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Abgelaufen';

  @override
  String get statusUrgent => 'Dringend';

  @override
  String get statusWarning => 'Warnung';

  @override
  String get statusSafe => 'Sicher';

  @override
  String get name => 'Name';

  @override
  String get quantity => 'Menge';

  @override
  String get category => 'Kategorie';

  @override
  String get location => 'Ort';

  @override
  String get price => 'Einzelpreis';

  @override
  String get expiryDate => 'Ablaufdatum';

  @override
  String get productionDate => 'Herstellungsdatum';

  @override
  String get shelfLife => 'Haltbarkeit (Tage)';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get pickDate => 'Datum wählen';

  @override
  String get toggleExpiryDate => 'Ablaufdatum';

  @override
  String get toggleProductionDate => 'Herstellungsdatum + Haltbarkeit';

  @override
  String get reminderLabel => 'Erinnerung';

  @override
  String get reminder1Day => '1 Tag vorher';

  @override
  String get reminder3Days => '3 Tage vorher';

  @override
  String get reminder7Days => '1 Woche vorher';

  @override
  String get advancedDetails => 'Erweiterte Details';

  @override
  String get advancedSubtitle => 'Menge, Ort, Preis...';

  @override
  String calculatedExpiry(Object date) {
    return 'Berechneter Ablauf: $date';
  }

  @override
  String get testNotification => 'Test Benachrichtigung';

  @override
  String get testNotificationSubtitle => 'Klicken, um Alarm auszulösen';

  @override
  String get addItem => 'Artikel hinzufügen';

  @override
  String get editItem => 'Artikel bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get saveAndNext => 'Speichern & Weiter';

  @override
  String get updateItem => 'Artikel aktualisieren';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get markAsUsed => 'Verbraucht';

  @override
  String get restock => 'Nachfüllen';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get switchLanguage => 'Sprache wechseln';

  @override
  String get selectLanguage => 'Sprache wählen';

  @override
  String get manageCategories => 'Kategorien verwalten';

  @override
  String get manageLocations => 'Orte verwalten';

  @override
  String get manageMode => 'Verwaltungsmodus';

  @override
  String get locationSelect => 'Ort auswählen';

  @override
  String get locationAdd => 'Ort hinzufügen';

  @override
  String get locationAddSub => 'Unterort hinzufügen';

  @override
  String get locationRename => 'Ort umbenennen';

  @override
  String get locationDeleteTitle => 'Ort löschen?';

  @override
  String get locationName => 'Ortsname';

  @override
  String get categorySelect => 'Kategorie auswählen';

  @override
  String get categoryAdd => 'Kategorie hinzufügen';

  @override
  String get categoryAddSub => 'Unterkategorie hinzufügen';

  @override
  String get categoryRename => 'Kategorie umbenennen';

  @override
  String get categoryDeleteTitle => 'Kategorie löschen?';

  @override
  String get itemConsumed => 'Artikel als verbraucht markiert!';

  @override
  String get deleteConfirm => 'Enthält Artikel. Löschen nicht möglich.';

  @override
  String get confirmDelete => 'Wirklich löschen?';

  @override
  String get deleteEmptyConfirm => 'Artikel ist leer und wird gelöscht.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Verschiebe $count Artikel nach $target.';
  }

  @override
  String get deleteMigrateTitle => 'Löschen & Migrieren?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Verschiebe $items Artikel nach \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Bestätigen & Verschieben';

  @override
  String get cannotDeleteDefault => 'Standard kann nicht gelöscht werden!';

  @override
  String get containsSubItems => 'Enthält Unterkategorien.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Standard $name nicht gefunden.';
  }

  @override
  String get errorNameExists => 'Name existiert bereits.';

  @override
  String get searchHint => 'Suchen...';

  @override
  String get noItemsFound => 'Keine Artikel gefunden';

  @override
  String noItemsFoundFor(Object query) {
    return 'Nichts gefunden für $query';
  }

  @override
  String get filtersHeader => 'Filter: ';

  @override
  String get emptyList => 'Leer';

  @override
  String get catVegetable => 'Gemüse';

  @override
  String get catFruit => 'Obst';

  @override
  String get catMeat => 'Fleisch';

  @override
  String get catDairy => 'Milchprodukte';

  @override
  String get catPantry => 'Vorratskammer';

  @override
  String get catSnack => 'Snacks';

  @override
  String get catHealth => 'Gesundheit';

  @override
  String get catUtility => 'Nützliches';

  @override
  String get unitPcs => 'Stk';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'Packung';

  @override
  String get unitBox => 'Box';

  @override
  String get unitBag => 'Beutel';

  @override
  String get unitBottle => 'Flasche';

  @override
  String get valOther => 'Andere';

  @override
  String get valMisc => 'Verschiedenes';

  @override
  String get valKitchen => 'Küche';

  @override
  String get valFridge => 'Kühlschrank';

  @override
  String get valPantry => 'Vorratskammer';

  @override
  String get valBathroom => 'Badezimmer';

  @override
  String get valFood => 'Essen';

  @override
  String get valBattery => 'Batterie';

  @override
  String get imageGallery => 'Galerie';

  @override
  String get imageCamera => 'Kamera';

  @override
  String get errorNameRequired => 'Name erforderlich';

  @override
  String get timeUnitDay => 'Tag';

  @override
  String get timeUnitWeek => 'Woche';

  @override
  String get timeUnitMonth => 'Monat';

  @override
  String get timeUnitYear => 'Jahr';

  @override
  String get addReminder => 'Erinnerung hinzufügen';

  @override
  String get customReminderTitle => 'Eigene Erinnerung';

  @override
  String get enterValue => 'Wert eingeben';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get errorExpiryRequired => 'Ablaufdatum erforderlich';

  @override
  String get deleteItemTitle => 'Artikel löschen?';

  @override
  String get deleteItemContent => 'Kann nicht rückgängig gemacht werden.';

  @override
  String get filterExpired => 'Abgelaufen';

  @override
  String get filterExpiringSoon => 'Läuft bald ab';

  @override
  String get emptyInventoryPrompt =>
      'Inventar leer! Ersten Artikel hinzufügen.';

  @override
  String get noExpiringItems => 'Keine ablaufenden Artikel';

  @override
  String get noExpiredItems => 'Keine abgelaufenen Artikel';

  @override
  String get feedbackTitle => 'Feedback senden';

  @override
  String get feedbackDialogTitle => 'Gefällt Ihnen UseUp?';

  @override
  String get feedbackDialogContent => 'Ihr Feedback hilft uns!';

  @override
  String get feedbackActionLove => 'Liebe es!';

  @override
  String get feedbackActionImprove => 'Könnte besser sein';
}
