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
  String get toggleProductionDate => 'Prod. Datum + Haltbarkeit';

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
  String get testNotificationSubtitle => 'Click to fire an instant alert';

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
  String get markAsUsed => 'Als verbraucht markieren';

  @override
  String get restock => 'Restock';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

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
  String get manageMode => 'Manage Mode';

  @override
  String get locationSelect => 'Select Location';

  @override
  String get locationAdd => 'Add Location';

  @override
  String get locationAddSub => 'Add Sub-Location';

  @override
  String get locationRename => 'Rename Location';

  @override
  String get locationDeleteTitle => 'Delete Location?';

  @override
  String get locationName => 'Location Name';

  @override
  String get categorySelect => 'Select Category';

  @override
  String get categoryAdd => 'Add Category';

  @override
  String get categoryAddSub => 'Add Sub-Category';

  @override
  String get categoryRename => 'Rename Category';

  @override
  String get categoryDeleteTitle => 'Delete Category?';

  @override
  String get itemConsumed => 'Item marked as consumed!';

  @override
  String get deleteConfirm =>
      'This location/category contains items or sub-items. Cannot delete.';

  @override
  String get confirmDelete => 'Are you sure you want to delete?';

  @override
  String get deleteEmptyConfirm =>
      'This item is empty and will be deleted directly.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Contains $count items. Items will be moved to $target.';
  }

  @override
  String get deleteMigrateTitle => 'Delete & Migrate?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'This item contains $items items and $subs sub-items.\nThey will be moved to \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Confirm & Move';

  @override
  String get cannotDeleteDefault => 'Cannot delete the default item!';

  @override
  String get containsSubItems => 'Contains sub-items. Delete them first.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Error: Default $name not found.';
  }

  @override
  String get errorNameExists => 'Name already exists in this level.';

  @override
  String get searchHint => 'Suchen...';

  @override
  String get noItemsFound => 'No items found';

  @override
  String noItemsFoundFor(Object query) {
    return 'No items found for $query';
  }

  @override
  String get filtersHeader => 'Filters: ';

  @override
  String get emptyList => 'Empty';

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
  String get unitPcs => 'pcs';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'pack';

  @override
  String get unitBox => 'box';

  @override
  String get unitBag => 'bag';

  @override
  String get unitBottle => 'bottle';

  @override
  String get valOther => 'Andere';

  @override
  String get valMisc => 'Verschiedenes';

  @override
  String get valKitchen => 'Küche';

  @override
  String get valFridge => 'Kühlschrank';

  @override
  String get valPantry => 'Pantry';

  @override
  String get valBathroom => 'Badezimmer';

  @override
  String get valFood => 'Food';

  @override
  String get valBattery => 'Battery';

  @override
  String get imageGallery => 'Gallery';

  @override
  String get imageCamera => 'Camera';

  @override
  String get errorNameRequired => 'Name is required';

  @override
  String get timeUnitDay => 'Day';

  @override
  String get timeUnitWeek => 'Week';

  @override
  String get timeUnitMonth => 'Month';

  @override
  String get timeUnitYear => 'Year';

  @override
  String get addReminder => 'Add Reminder';

  @override
  String get customReminderTitle => 'Custom Reminder';

  @override
  String get enterValue => 'Enter value';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get errorExpiryRequired => 'Expiry date is required';

  @override
  String get deleteItemTitle => 'Delete Item?';

  @override
  String get deleteItemContent => 'This cannot be undone.';

  @override
  String get filterExpired => 'Expired';

  @override
  String get filterExpiringSoon => 'Expiring Soon';

  @override
  String get emptyInventoryPrompt =>
      'Ihr Inventar ist leer! Fügen Sie den ersten Artikel hinzu.';

  @override
  String get noExpiringItems => 'No items expiring soon';

  @override
  String get noExpiredItems => 'No expired items';

  @override
  String get feedbackTitle => 'Send Feedback / Rate Us';

  @override
  String get feedbackDialogTitle => 'Enjoying UseUp?';

  @override
  String get feedbackDialogContent => 'Your feedback helps us improve!';

  @override
  String get feedbackActionLove => 'Love it!';

  @override
  String get feedbackActionImprove => 'Could be better';
}
