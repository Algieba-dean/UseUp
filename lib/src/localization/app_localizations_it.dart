// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Buongiorno';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get history => 'Cronologia';

  @override
  String get sectionExpiringSoon => 'In scadenza';

  @override
  String get sectionAllItems => 'Tutti gli articoli';

  @override
  String get scanItem => 'Scansiona articolo';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni rimasti',
      one: 'Domani',
      zero: 'Oggi',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Scaduto';

  @override
  String get statusUrgent => 'Urgente';

  @override
  String get statusWarning => 'Avviso';

  @override
  String get statusSafe => 'Sicuro';

  @override
  String get name => 'Nome';

  @override
  String get quantity => 'Quantità';

  @override
  String get category => 'Categoria';

  @override
  String get location => 'Posizione';

  @override
  String get price => 'Prezzo unitario';

  @override
  String get expiryDate => 'Data di scadenza';

  @override
  String get productionDate => 'Data di produzione';

  @override
  String get shelfLife => 'Durata di conservazione (giorni)';

  @override
  String get purchaseDate => 'Data d\'acquisto';

  @override
  String get pickDate => 'Scegli data';

  @override
  String get toggleExpiryDate => 'Data di scadenza';

  @override
  String get toggleProductionDate => 'Data prod. + durata';

  @override
  String get reminderLabel => 'Promemoria';

  @override
  String get reminder1Day => '1 giorno prima';

  @override
  String get reminder3Days => '3 giorni prima';

  @override
  String get reminder7Days => '1 settimana prima';

  @override
  String get advancedDetails => 'Dettagli avanzati';

  @override
  String get advancedSubtitle => 'Quantità, Posizione, Prezzo...';

  @override
  String calculatedExpiry(Object date) {
    return 'Scadenza calcolata: $date';
  }

  @override
  String get testNotification => 'Notifica di test';

  @override
  String get testNotificationSubtitle => 'Click to fire an instant alert';

  @override
  String get addItem => 'Aggiungi articolo';

  @override
  String get editItem => 'Modifica articolo';

  @override
  String get save => 'Salva';

  @override
  String get saveAndNext => 'Salva e Prossimo';

  @override
  String get updateItem => 'Aggiorna articolo';

  @override
  String get cancel => 'Annulla';

  @override
  String get confirm => 'Conferma';

  @override
  String get delete => 'Elimina';

  @override
  String get markAsUsed => 'Segna come consumato';

  @override
  String get restock => 'Restock';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get switchLanguage => 'Cambia lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get manageCategories => 'Gestisci categorie';

  @override
  String get manageLocations => 'Gestisci posizioni';

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
  String get searchHint => 'Cerca...';

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
  String get catVegetable => 'Verdura';

  @override
  String get catFruit => 'Frutta';

  @override
  String get catMeat => 'Carne';

  @override
  String get catDairy => 'Latticini';

  @override
  String get catPantry => 'Dispensa';

  @override
  String get catSnack => 'Snack';

  @override
  String get catHealth => 'Salute';

  @override
  String get catUtility => 'Utilità';

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
  String get valOther => 'Altro';

  @override
  String get valMisc => 'Varie';

  @override
  String get valKitchen => 'Cucina';

  @override
  String get valFridge => 'Frigorifero';

  @override
  String get valPantry => 'Pantry';

  @override
  String get valBathroom => 'Bagno';

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
      'Il tuo inventario è vuoto! Aggiungi il primo articolo.';

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
