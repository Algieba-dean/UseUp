import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale('zh', 'TW'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'UseUp'**
  String get appTitle;

  /// No description provided for @welcomeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get welcomeGreeting;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @sectionExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get sectionExpiringSoon;

  /// No description provided for @sectionAllItems.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get sectionAllItems;

  /// No description provided for @scanItem.
  ///
  /// In en, this message translates to:
  /// **'Scan Item'**
  String get scanItem;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{Tomorrow} other{{count} days left}}'**
  String daysLeft(num count);

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @statusUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get statusUrgent;

  /// No description provided for @statusWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get statusWarning;

  /// No description provided for @statusSafe.
  ///
  /// In en, this message translates to:
  /// **'Safe'**
  String get statusSafe;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get price;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @productionDate.
  ///
  /// In en, this message translates to:
  /// **'Production Date'**
  String get productionDate;

  /// No description provided for @shelfLife.
  ///
  /// In en, this message translates to:
  /// **'Shelf Life (Days)'**
  String get shelfLife;

  /// No description provided for @purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchaseDate;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @toggleExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get toggleExpiryDate;

  /// No description provided for @toggleProductionDate.
  ///
  /// In en, this message translates to:
  /// **'Prod. Date + Shelf Life'**
  String get toggleProductionDate;

  /// No description provided for @reminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderLabel;

  /// No description provided for @reminder1Day.
  ///
  /// In en, this message translates to:
  /// **'1 day before'**
  String get reminder1Day;

  /// No description provided for @reminder3Days.
  ///
  /// In en, this message translates to:
  /// **'3 days before'**
  String get reminder3Days;

  /// No description provided for @reminder7Days.
  ///
  /// In en, this message translates to:
  /// **'1 week before'**
  String get reminder7Days;

  /// No description provided for @advancedDetails.
  ///
  /// In en, this message translates to:
  /// **'Advanced Details'**
  String get advancedDetails;

  /// No description provided for @advancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quantity, Location, Price...'**
  String get advancedSubtitle;

  /// No description provided for @calculatedExpiry.
  ///
  /// In en, this message translates to:
  /// **'Calculated Expiry: {date}'**
  String calculatedExpiry(Object date);

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @testNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Click to fire an instant alert'**
  String get testNotificationSubtitle;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAndNext.
  ///
  /// In en, this message translates to:
  /// **'Save & Next'**
  String get saveAndNext;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @markAsUsed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Used'**
  String get markAsUsed;

  /// No description provided for @restock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @manageLocations.
  ///
  /// In en, this message translates to:
  /// **'Manage Locations'**
  String get manageLocations;

  /// No description provided for @manageMode.
  ///
  /// In en, this message translates to:
  /// **'Manage Mode'**
  String get manageMode;

  /// No description provided for @locationSelect.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get locationSelect;

  /// No description provided for @locationAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get locationAdd;

  /// No description provided for @locationAddSub.
  ///
  /// In en, this message translates to:
  /// **'Add Sub-Location'**
  String get locationAddSub;

  /// No description provided for @locationRename.
  ///
  /// In en, this message translates to:
  /// **'Rename Location'**
  String get locationRename;

  /// No description provided for @locationDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Location?'**
  String get locationDeleteTitle;

  /// No description provided for @locationName.
  ///
  /// In en, this message translates to:
  /// **'Location Name'**
  String get locationName;

  /// No description provided for @categorySelect.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get categorySelect;

  /// No description provided for @categoryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get categoryAdd;

  /// No description provided for @categoryAddSub.
  ///
  /// In en, this message translates to:
  /// **'Add Sub-Category'**
  String get categoryAddSub;

  /// No description provided for @categoryRename.
  ///
  /// In en, this message translates to:
  /// **'Rename Category'**
  String get categoryRename;

  /// No description provided for @categoryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category?'**
  String get categoryDeleteTitle;

  /// No description provided for @itemConsumed.
  ///
  /// In en, this message translates to:
  /// **'Item marked as consumed!'**
  String get itemConsumed;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This location/category contains items or sub-items. Cannot delete.'**
  String get deleteConfirm;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @deleteEmptyConfirm.
  ///
  /// In en, this message translates to:
  /// **'This item is empty and will be deleted directly.'**
  String get deleteEmptyConfirm;

  /// No description provided for @deleteMoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Contains {count} items. Items will be moved to {target}.'**
  String deleteMoveConfirm(Object count, Object target);

  /// No description provided for @deleteMigrateTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete & Migrate?'**
  String get deleteMigrateTitle;

  /// No description provided for @deleteMigrateContent.
  ///
  /// In en, this message translates to:
  /// **'This item contains {items} items and {subs} sub-items.\nThey will be moved to \'{target}\'.'**
  String deleteMigrateContent(Object items, Object subs, Object target);

  /// No description provided for @confirmAndMove.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Move'**
  String get confirmAndMove;

  /// No description provided for @cannotDeleteDefault.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the default item!'**
  String get cannotDeleteDefault;

  /// No description provided for @containsSubItems.
  ///
  /// In en, this message translates to:
  /// **'Contains sub-items. Delete them first.'**
  String get containsSubItems;

  /// No description provided for @errorDefaultNotFound.
  ///
  /// In en, this message translates to:
  /// **'Error: Default {name} not found.'**
  String errorDefaultNotFound(Object name);

  /// No description provided for @errorNameExists.
  ///
  /// In en, this message translates to:
  /// **'Name already exists in this level.'**
  String get errorNameExists;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search items...'**
  String get searchHint;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @noItemsFoundFor.
  ///
  /// In en, this message translates to:
  /// **'No items found for {query}'**
  String noItemsFoundFor(Object query);

  /// No description provided for @filtersHeader.
  ///
  /// In en, this message translates to:
  /// **'Filters: '**
  String get filtersHeader;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyList;

  /// No description provided for @catVegetable.
  ///
  /// In en, this message translates to:
  /// **'Vegetable'**
  String get catVegetable;

  /// No description provided for @catFruit.
  ///
  /// In en, this message translates to:
  /// **'Fruit'**
  String get catFruit;

  /// No description provided for @catMeat.
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get catMeat;

  /// No description provided for @catDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get catDairy;

  /// No description provided for @catPantry.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get catPantry;

  /// No description provided for @catSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get catSnack;

  /// No description provided for @catHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get catHealth;

  /// No description provided for @catUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get catUtility;

  /// No description provided for @unitPcs.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitPcs;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitG.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get unitG;

  /// No description provided for @unitL.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitL;

  /// No description provided for @unitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get unitMl;

  /// No description provided for @unitPack.
  ///
  /// In en, this message translates to:
  /// **'pack'**
  String get unitPack;

  /// No description provided for @unitBox.
  ///
  /// In en, this message translates to:
  /// **'box'**
  String get unitBox;

  /// No description provided for @unitBag.
  ///
  /// In en, this message translates to:
  /// **'bag'**
  String get unitBag;

  /// No description provided for @unitBottle.
  ///
  /// In en, this message translates to:
  /// **'bottle'**
  String get unitBottle;

  /// No description provided for @valOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get valOther;

  /// No description provided for @valMisc.
  ///
  /// In en, this message translates to:
  /// **'Misc'**
  String get valMisc;

  /// No description provided for @valKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get valKitchen;

  /// No description provided for @valFridge.
  ///
  /// In en, this message translates to:
  /// **'Fridge'**
  String get valFridge;

  /// No description provided for @valPantry.
  ///
  /// In en, this message translates to:
  /// **'Pantry'**
  String get valPantry;

  /// No description provided for @valBathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get valBathroom;

  /// No description provided for @valFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get valFood;

  /// No description provided for @valBattery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get valBattery;

  /// No description provided for @imageGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get imageGallery;

  /// No description provided for @imageCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get imageCamera;

  /// No description provided for @errorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get errorNameRequired;

  /// No description provided for @timeUnitDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get timeUnitDay;

  /// No description provided for @timeUnitWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get timeUnitWeek;

  /// No description provided for @timeUnitMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get timeUnitMonth;

  /// No description provided for @timeUnitYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get timeUnitYear;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// No description provided for @customReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom Reminder'**
  String get customReminderTitle;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValue;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @errorExpiryRequired.
  ///
  /// In en, this message translates to:
  /// **'Expiry date is required'**
  String get errorExpiryRequired;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemContent.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone.'**
  String get deleteItemContent;

  /// No description provided for @filterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// No description provided for @filterExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get filterExpiringSoon;

  /// No description provided for @emptyInventoryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Your fridge is empty! Try adding the first item.'**
  String get emptyInventoryPrompt;

  /// No description provided for @noExpiringItems.
  ///
  /// In en, this message translates to:
  /// **'No items expiring soon'**
  String get noExpiringItems;

  /// No description provided for @noExpiredItems.
  ///
  /// In en, this message translates to:
  /// **'No expired items'**
  String get noExpiredItems;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback / Rate Us'**
  String get feedbackTitle;

  /// No description provided for @feedbackDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying UseUp?'**
  String get feedbackDialogTitle;

  /// No description provided for @feedbackDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve!'**
  String get feedbackDialogContent;

  /// No description provided for @feedbackActionLove.
  ///
  /// In en, this message translates to:
  /// **'Love it!'**
  String get feedbackActionLove;

  /// No description provided for @feedbackActionImprove.
  ///
  /// In en, this message translates to:
  /// **'Could be better'**
  String get feedbackActionImprove;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'el',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'nl',
    'pl',
    'pt',
    'ru',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
