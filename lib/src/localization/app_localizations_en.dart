// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Good Morning';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get sectionExpiringSoon => 'Expiring Soon';

  @override
  String get sectionAllItems => 'All Items';

  @override
  String get scanItem => 'Scan Item';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Expired';

  @override
  String get statusUrgent => 'Urgent';

  @override
  String get statusWarning => 'Warning';

  @override
  String get statusSafe => 'Safe';

  @override
  String get name => 'Name';

  @override
  String get quantity => 'Quantity';

  @override
  String get category => 'Category';

  @override
  String get location => 'Location';

  @override
  String get price => 'Unit Price';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get productionDate => 'Production Date';

  @override
  String get shelfLife => 'Shelf Life (Days)';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get toggleExpiryDate => 'Expiry Date';

  @override
  String get toggleProductionDate => 'Prod. Date + Shelf Life';

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get reminder1Day => '1 day before';

  @override
  String get reminder3Days => '3 days before';

  @override
  String get reminder7Days => '1 week before';

  @override
  String get advancedDetails => 'Advanced Details';

  @override
  String get advancedSubtitle => 'Quantity, Location, Price...';

  @override
  String calculatedExpiry(Object date) {
    return 'Calculated Expiry: $date';
  }

  @override
  String get testNotification => 'Test Notification';

  @override
  String get testNotificationSubtitle => 'Click to fire an instant alert';

  @override
  String get addItem => 'Add Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get save => 'Save';

  @override
  String get saveAndNext => 'Save & Next';

  @override
  String get updateItem => 'Update Item';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get markAsUsed => 'Mark as Used';

  @override
  String get restock => 'Restock';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get manageLocations => 'Manage Locations';

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
  String get searchHint => 'Search items...';

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
  String get catVegetable => 'Vegetable';

  @override
  String get catFruit => 'Fruit';

  @override
  String get catMeat => 'Meat';

  @override
  String get catDairy => 'Dairy';

  @override
  String get catPantry => 'Pantry';

  @override
  String get catSnack => 'Snack';

  @override
  String get catHealth => 'Health';

  @override
  String get catUtility => 'Utility';

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
  String get valOther => 'Other';

  @override
  String get valMisc => 'Misc';

  @override
  String get valKitchen => 'Kitchen';

  @override
  String get valFridge => 'Fridge';

  @override
  String get valPantry => 'Pantry';

  @override
  String get valBathroom => 'Bathroom';

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
}
