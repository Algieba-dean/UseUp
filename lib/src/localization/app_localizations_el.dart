// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Καλημέρα';

  @override
  String get navHome => 'Αρχική';

  @override
  String get navSettings => 'Ρυθμίσεις';

  @override
  String get history => 'Ιστορικό';

  @override
  String get sectionExpiringSoon => 'Λήγουν σύντομα';

  @override
  String get sectionAllItems => 'Όλα τα είδη';

  @override
  String get scanItem => 'Σάρωση είδους';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Απομένουν $count ημέρες',
      one: 'Αύριο',
      zero: 'Σήμερα',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Έληξε';

  @override
  String get statusUrgent => 'Επείγον';

  @override
  String get statusWarning => 'Προειδοποίηση';

  @override
  String get statusSafe => 'Ασφαλές';

  @override
  String get name => 'Όνομα';

  @override
  String get quantity => 'Ποσότητα';

  @override
  String get category => 'Κατηγορία';

  @override
  String get location => 'Τοποθεσία';

  @override
  String get price => 'Τιμή μονάδας';

  @override
  String get expiryDate => 'Ημερομηνία λήξης';

  @override
  String get productionDate => 'Ημερομηνία παραγωγής';

  @override
  String get shelfLife => 'Διάρκεια ζωής (Ημέρες)';

  @override
  String get purchaseDate => 'Ημερομηνία αγοράς';

  @override
  String get pickDate => 'Επιλογή ημερομηνίας';

  @override
  String get toggleExpiryDate => 'Ημερομηνία λήξης';

  @override
  String get toggleProductionDate => 'Ημ. παραγωγής + Διάρκεια';

  @override
  String get reminderLabel => 'Υπενθύμιση';

  @override
  String get reminder1Day => '1 ημέρα πριν';

  @override
  String get reminder3Days => '3 ημέρες πριν';

  @override
  String get reminder7Days => '1 εβδομάδα πριν';

  @override
  String get advancedDetails => 'Προηγμένες λεπτομέρειες';

  @override
  String get advancedSubtitle => 'Ποσότητα, τοποθεσία, τιμή...';

  @override
  String calculatedExpiry(Object date) {
    return 'Υπολογισμένη λήξη: $date';
  }

  @override
  String get testNotification => 'Δοκιμαστική ειδοποίηση';

  @override
  String get testNotificationSubtitle => 'Κάντε κλικ για ενεργοποίηση';

  @override
  String get addItem => 'Προσθήκη είδους';

  @override
  String get editItem => 'Επεξεργασία είδους';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get saveAndNext => 'Αποθήκευση & Επόμενο';

  @override
  String get updateItem => 'Ενημέρωση είδους';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get confirm => 'Επιβεβαίωση';

  @override
  String get delete => 'Διαγραφή';

  @override
  String get markAsUsed => 'Χρησιμοποιήθηκε';

  @override
  String get restock => 'Αναπλήρωση';

  @override
  String get filter => 'Φίλτρο';

  @override
  String get reset => 'Επαναφορά';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get language => 'Γλώσσα';

  @override
  String get switchLanguage => 'Αλλαγή γλώσσας';

  @override
  String get selectLanguage => 'Επιλογή γλώσσας';

  @override
  String get manageCategories => 'Διαχείριση κατηγοριών';

  @override
  String get manageLocations => 'Διαχείριση τοποθεσιών';

  @override
  String get manageMode => 'Λειτουργία διαχείρισης';

  @override
  String get locationSelect => 'Επιλογή τοποθεσίας';

  @override
  String get locationAdd => 'Προσθήκη τοποθεσίας';

  @override
  String get locationAddSub => 'Προσθήκη υπο-τοποθεσίας';

  @override
  String get locationRename => 'Μετονομασία τοποθεσίας';

  @override
  String get locationDeleteTitle => 'Διαγραφή τοποθεσίας;';

  @override
  String get locationName => 'Όνομα τοποθεσίας';

  @override
  String get categorySelect => 'Επιλογή κατηγορίας';

  @override
  String get categoryAdd => 'Προσθήκη κατηγορίας';

  @override
  String get categoryAddSub => 'Προσθήκη υπο-κατηγορίας';

  @override
  String get categoryRename => 'Μετονομασία κατηγορίας';

  @override
  String get categoryDeleteTitle => 'Διαγραφή κατηγορίας;';

  @override
  String get itemConsumed => 'Το είδος σημειώθηκε ως αναλωμένο!';

  @override
  String get deleteConfirm => 'Περιέχει είδη. Αδύνατη η διαγραφή.';

  @override
  String get confirmDelete => 'Είστε σίγουροι για τη διαγραφή;';

  @override
  String get deleteEmptyConfirm =>
      'Αυτό το είδος είναι άδειο και θα διαγραφεί.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Μεταφορά $count ειδών στο $target.';
  }

  @override
  String get deleteMigrateTitle => 'Διαγραφή & Μεταφορά;';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Μεταφορά $items ειδών στο \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Επιβεβαίωση & Μεταφορά';

  @override
  String get cannotDeleteDefault => 'Αδύνατη η διαγραφή του προεπιλεγμένου!';

  @override
  String get containsSubItems => 'Περιέχει υπο-στοιχεία.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Το προεπιλεγμένο $name δεν βρέθηκε.';
  }

  @override
  String get errorNameExists => 'Το όνομα υπάρχει ήδη.';

  @override
  String get searchHint => 'Αναζήτηση...';

  @override
  String get noItemsFound => 'Δεν βρέθηκαν είδη';

  @override
  String noItemsFoundFor(Object query) {
    return 'Κανένα αποτέλεσμα για $query';
  }

  @override
  String get filtersHeader => 'Φίλτρα: ';

  @override
  String get emptyList => 'Κενό';

  @override
  String get catVegetable => 'Λαχανικά';

  @override
  String get catFruit => 'Φρούτα';

  @override
  String get catMeat => 'Κρέας';

  @override
  String get catDairy => 'Γαλακτοκομικά';

  @override
  String get catPantry => 'Ντουλάπι';

  @override
  String get catSnack => 'Σνακ';

  @override
  String get catHealth => 'Υγεία';

  @override
  String get catUtility => 'Χρηστικά';

  @override
  String get unitPcs => 'τμχ';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'πακέτο';

  @override
  String get unitBox => 'κουτί';

  @override
  String get unitBag => 'σακούλα';

  @override
  String get unitBottle => 'μπουκάλι';

  @override
  String get valOther => 'Άλλο';

  @override
  String get valMisc => 'Διάφορα';

  @override
  String get valKitchen => 'Κουζίνα';

  @override
  String get valFridge => 'Ψυγείο';

  @override
  String get valPantry => 'Ντουλάπι';

  @override
  String get valBathroom => 'Μπάνιο';

  @override
  String get valFood => 'Φαγητό';

  @override
  String get valBattery => 'Μπαταρία';

  @override
  String get imageGallery => 'Συλλογή';

  @override
  String get imageCamera => 'Κάμερα';

  @override
  String get errorNameRequired => 'Το όνομα είναι υποχρεωτικό';

  @override
  String get timeUnitDay => 'Ημέρα';

  @override
  String get timeUnitWeek => 'Εβδομάδα';

  @override
  String get timeUnitMonth => 'Μήνας';

  @override
  String get timeUnitYear => 'Έτος';

  @override
  String get addReminder => 'Προσθήκη υπενθύμισης';

  @override
  String get customReminderTitle => 'Προσαρμοσμένη υπενθύμιση';

  @override
  String get enterValue => 'Εισάγετε τιμή';

  @override
  String get privacyPolicy => 'Πολιτική απορρήτου';

  @override
  String get errorExpiryRequired => 'Η ημερομηνία λήξης είναι υποχρεωτική';

  @override
  String get deleteItemTitle => 'Διαγραφή είδους;';

  @override
  String get deleteItemContent => 'Αυτή η ενέργεια δεν αναιρείται.';

  @override
  String get filterExpired => 'Έληξε';

  @override
  String get filterExpiringSoon => 'Λήγουν σύντομα';

  @override
  String get emptyInventoryPrompt =>
      'Το απόθεμα είναι άδειο! Προσθέστε το πρώτο είδος.';

  @override
  String get noExpiringItems => 'Δεν υπάρχουν είδη που λήγουν σύντομα';

  @override
  String get noExpiredItems => 'Δεν υπάρχουν ληγμένα είδη';

  @override
  String get feedbackTitle => 'Αποστολή σχολίων';

  @override
  String get feedbackDialogTitle => 'Σας αρέσει το UseUp;';

  @override
  String get feedbackDialogContent =>
      'Τα σχόλιά σας μας βοηθούν να βελτιωθούμε!';

  @override
  String get feedbackActionLove => 'Το λατρεύω!';

  @override
  String get feedbackActionImprove => 'Θέλει βελτίωση';
}
