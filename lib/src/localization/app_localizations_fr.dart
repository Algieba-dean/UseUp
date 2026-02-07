// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Bonjour';

  @override
  String get navHome => 'Accueil';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get history => 'Historique';

  @override
  String get sectionExpiringSoon => 'Expire bientôt';

  @override
  String get sectionAllItems => 'Tous les articles';

  @override
  String get scanItem => 'Scanner un article';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours restants',
      one: 'Demain',
      zero: 'Aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Expiré';

  @override
  String get statusUrgent => 'Urgent';

  @override
  String get statusWarning => 'Avertissement';

  @override
  String get statusSafe => 'Sûr';

  @override
  String get name => 'Nom';

  @override
  String get quantity => 'Quantité';

  @override
  String get category => 'Catégorie';

  @override
  String get location => 'Emplacement';

  @override
  String get price => 'Prix unitaire';

  @override
  String get expiryDate => 'Date d\'expiration';

  @override
  String get productionDate => 'Date de production';

  @override
  String get shelfLife => 'Durée de conservation (jours)';

  @override
  String get purchaseDate => 'Date d\'achat';

  @override
  String get pickDate => 'Choisir une date';

  @override
  String get toggleExpiryDate => 'Date d\'expiration';

  @override
  String get toggleProductionDate => 'Date de prod. + durée';

  @override
  String get reminderLabel => 'Rappel';

  @override
  String get reminder1Day => '1 jour avant';

  @override
  String get reminder3Days => '3 jours avant';

  @override
  String get reminder7Days => '1 semaine avant';

  @override
  String get advancedDetails => 'Détails avancés';

  @override
  String get advancedSubtitle => 'Quantité, Emplacement, Prix...';

  @override
  String calculatedExpiry(Object date) {
    return 'Expiration calculée : $date';
  }

  @override
  String get testNotification => 'Notification de test';

  @override
  String get testNotificationSubtitle => 'Click to fire an instant alert';

  @override
  String get addItem => 'Ajouter un article';

  @override
  String get editItem => 'Modifier l\'article';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveAndNext => 'Suivant';

  @override
  String get updateItem => 'Mettre à jour';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get markAsUsed => 'Marquer comme utilisé';

  @override
  String get restock => 'Restock';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get switchLanguage => 'Changer de langue';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String get manageCategories => 'Gérer les catégories';

  @override
  String get manageLocations => 'Gérer les emplacements';

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
  String get searchHint => 'Rechercher...';

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
  String get catVegetable => 'Légumes';

  @override
  String get catFruit => 'Fruits';

  @override
  String get catMeat => 'Viande';

  @override
  String get catDairy => 'Produits laitiers';

  @override
  String get catPantry => 'Garde-manger';

  @override
  String get catSnack => 'Snacks';

  @override
  String get catHealth => 'Santé';

  @override
  String get catUtility => 'Utilité';

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
  String get valOther => 'Autre';

  @override
  String get valMisc => 'Divers';

  @override
  String get valKitchen => 'Cuisine';

  @override
  String get valFridge => 'Réfrigérateur';

  @override
  String get valPantry => 'Pantry';

  @override
  String get valBathroom => 'Salle de bain';

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
      'Votre inventaire est vide ! Ajoutez votre premier article.';

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
