// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Goedemorgen';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Instellingen';

  @override
  String get history => 'Geschiedenis';

  @override
  String get sectionExpiringSoon => 'Verloopt binnenkort';

  @override
  String get sectionAllItems => 'Alle items';

  @override
  String get scanItem => 'Item scannen';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nog $count dagen',
      one: 'Morgen',
      zero: 'Vandaag',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Verlopen';

  @override
  String get statusUrgent => 'Dringend';

  @override
  String get statusWarning => 'Waarschuwing';

  @override
  String get statusSafe => 'Veilig';

  @override
  String get name => 'Naam';

  @override
  String get quantity => 'Aantal';

  @override
  String get category => 'Categorie';

  @override
  String get location => 'Locatie';

  @override
  String get price => 'Prijs per stuk';

  @override
  String get expiryDate => 'Vervaldatum';

  @override
  String get productionDate => 'Productiedatum';

  @override
  String get shelfLife => 'Houdbaarheid (Dagen)';

  @override
  String get purchaseDate => 'Aankoopdatum';

  @override
  String get pickDate => 'Datum kiezen';

  @override
  String get toggleExpiryDate => 'Vervaldatum';

  @override
  String get toggleProductionDate => 'Productiedatum + houdbaarheid';

  @override
  String get reminderLabel => 'Herinnering';

  @override
  String get reminder1Day => '1 dag van tevoren';

  @override
  String get reminder3Days => '3 dagen van tevoren';

  @override
  String get reminder7Days => '1 week van tevoren';

  @override
  String get advancedDetails => 'Geavanceerde details';

  @override
  String get advancedSubtitle => 'Aantal, locatie, prijs...';

  @override
  String calculatedExpiry(Object date) {
    return 'Berekende vervaldatum: $date';
  }

  @override
  String get testNotification => 'Testmelding';

  @override
  String get testNotificationSubtitle => 'Klik om een melding te testen';

  @override
  String get addItem => 'Item toevoegen';

  @override
  String get editItem => 'Item bewerken';

  @override
  String get save => 'Opslaan';

  @override
  String get saveAndNext => 'Opslaan & Volgende';

  @override
  String get updateItem => 'Item bijwerken';

  @override
  String get cancel => 'Annuleren';

  @override
  String get confirm => 'Bevestigen';

  @override
  String get delete => 'Verwijderen';

  @override
  String get markAsUsed => 'Gebruikt';

  @override
  String get restock => 'Aanvullen';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

  @override
  String get settingsTitle => 'Instellingen';

  @override
  String get language => 'Taal';

  @override
  String get switchLanguage => 'Taal wijzigen';

  @override
  String get selectLanguage => 'Taal selecteren';

  @override
  String get manageCategories => 'Categorieën beheren';

  @override
  String get manageLocations => 'Locaties beheren';

  @override
  String get manageMode => 'Beheermodus';

  @override
  String get locationSelect => 'Locatie selecteren';

  @override
  String get locationAdd => 'Locatie toevoegen';

  @override
  String get locationAddSub => 'Sublocatie toevoegen';

  @override
  String get locationRename => 'Locatie hernoemen';

  @override
  String get locationDeleteTitle => 'Locatie verwijderen?';

  @override
  String get locationName => 'Locatienaam';

  @override
  String get categorySelect => 'Categorie selecteren';

  @override
  String get categoryAdd => 'Categorie toevoegen';

  @override
  String get categoryAddSub => 'Subcategorie toevoegen';

  @override
  String get categoryRename => 'Categorie hernoemen';

  @override
  String get categoryDeleteTitle => 'Categorie verwijderen?';

  @override
  String get itemConsumed => 'Item gemarkeerd als verbruikt!';

  @override
  String get deleteConfirm => 'Bevat items. Kan niet verwijderen.';

  @override
  String get confirmDelete => 'Weet u zeker dat u wilt verwijderen?';

  @override
  String get deleteEmptyConfirm =>
      'Dit item is leeg en wordt direct verwijderd.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Verplaats $count items naar $target.';
  }

  @override
  String get deleteMigrateTitle => 'Verwijderen & Migreren?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Verplaats $items items naar \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Bevestigen & Verplaatsen';

  @override
  String get cannotDeleteDefault => 'Kan het standaarditem nicht verwijderen!';

  @override
  String get containsSubItems => 'Bevat subitems.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Standaard $name niet gevonden.';
  }

  @override
  String get errorNameExists => 'Naam bestaat al.';

  @override
  String get searchHint => 'Zoeken...';

  @override
  String get noItemsFound => 'Geen items gevonden';

  @override
  String noItemsFoundFor(Object query) {
    return 'Niets gevonden voor $query';
  }

  @override
  String get filtersHeader => 'Filters: ';

  @override
  String get emptyList => 'Leeg';

  @override
  String get catVegetable => 'Groente';

  @override
  String get catFruit => 'Fruit';

  @override
  String get catMeat => 'Vlees';

  @override
  String get catDairy => 'Zuivel';

  @override
  String get catPantry => 'Voorraadkast';

  @override
  String get catSnack => 'Snack';

  @override
  String get catHealth => 'Gezondheid';

  @override
  String get catUtility => 'Hulpmiddelen';

  @override
  String get unitPcs => 'stk';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'pak';

  @override
  String get unitBox => 'doos';

  @override
  String get unitBag => 'zak';

  @override
  String get unitBottle => 'fles';

  @override
  String get valOther => 'Andere';

  @override
  String get valMisc => 'Diversen';

  @override
  String get valKitchen => 'Keuken';

  @override
  String get valFridge => 'Koelkast';

  @override
  String get valPantry => 'Voorraadkast';

  @override
  String get valBathroom => 'Badkamer';

  @override
  String get valFood => 'Voedsel';

  @override
  String get valBattery => 'Batterij';

  @override
  String get imageGallery => 'Galerij';

  @override
  String get imageCamera => 'Camera';

  @override
  String get errorNameRequired => 'Naam is verplicht';

  @override
  String get timeUnitDay => 'Dag';

  @override
  String get timeUnitWeek => 'Week';

  @override
  String get timeUnitMonth => 'Maand';

  @override
  String get timeUnitYear => 'Jaar';

  @override
  String get addReminder => 'Herinnering toevoegen';

  @override
  String get customReminderTitle => 'Aangepaste herinnering';

  @override
  String get enterValue => 'Voer waarde in';

  @override
  String get privacyPolicy => 'Privacybeleid';

  @override
  String get errorExpiryRequired => 'Vervaldatum is verplicht';

  @override
  String get deleteItemTitle => 'Item verwijderen?';

  @override
  String get deleteItemContent => 'Dit kan niet ongedaan worden gemaakt.';

  @override
  String get filterExpired => 'Verlopen';

  @override
  String get filterExpiringSoon => 'Verloopt binnenkort';

  @override
  String get emptyInventoryPrompt => 'Voorraad leeg! Voeg uw eerste item toe.';

  @override
  String get noExpiringItems => 'Geen items die binnenkort verlopen';

  @override
  String get noExpiredItems => 'Geen verlopen items';

  @override
  String get feedbackTitle => 'Feedback sturen';

  @override
  String get feedbackDialogTitle => 'Geniet u van UseUp?';

  @override
  String get feedbackDialogContent => 'Uw feedback helpt ons te verbeteren!';

  @override
  String get feedbackActionLove => 'Heerlijk!';

  @override
  String get feedbackActionImprove => 'Kan beter';
}
