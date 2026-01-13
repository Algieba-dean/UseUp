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
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get addItem => 'Add Item';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get name => 'Name';

  @override
  String get quantity => 'Quantity';

  @override
  String get category => 'Category';

  @override
  String get location => 'Location';

  @override
  String get expiryDate => 'Expiry Date';

  @override
  String get pickDate => 'Pick Date';

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
  String get locationSelect => 'Select Location';

  @override
  String get locationAdd => 'Add Location';

  @override
  String get locationName => 'Location Name';

  @override
  String get delete => 'Delete';

  @override
  String get deleteConfirm =>
      'This location contains items or sub-locations. Cannot delete.';

  @override
  String get confirm => 'Confirm';
}
