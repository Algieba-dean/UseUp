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
  String get shelfLife => 'Durata (giorni)';

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
  String get advancedSubtitle => 'Quantità, posizione, prezzo...';

  @override
  String calculatedExpiry(Object date) {
    return 'Scadenza calcolata: $date';
  }

  @override
  String get testNotification => 'Notifica di test';

  @override
  String get testNotificationSubtitle => 'Clicca per avviare un avviso';

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
  String get markAsUsed => 'Usato';

  @override
  String get restock => 'Rifornisci';

  @override
  String get filter => 'Filtro';

  @override
  String get reset => 'Ripristina';

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
  String get manageMode => 'Modalità gestione';

  @override
  String get locationSelect => 'Seleziona posizione';

  @override
  String get locationAdd => 'Aggiungi posizione';

  @override
  String get locationAddSub => 'Aggiungi sotto-posizione';

  @override
  String get locationRename => 'Rinomina posizione';

  @override
  String get locationDeleteTitle => 'Elimina posizione?';

  @override
  String get locationName => 'Nome posizione';

  @override
  String get categorySelect => 'Seleziona categoria';

  @override
  String get categoryAdd => 'Aggiungi categoria';

  @override
  String get categoryAddSub => 'Aggiungi sotto-categoria';

  @override
  String get categoryRename => 'Rinomina categoria';

  @override
  String get categoryDeleteTitle => 'Elimina categoria?';

  @override
  String get itemConsumed => 'Articolo segnato come consumato!';

  @override
  String get deleteConfirm => 'Contiene articoli. Impossibile eliminare.';

  @override
  String get confirmDelete => 'Vuoi davvero eliminare?';

  @override
  String get deleteEmptyConfirm => 'L\'articolo è vuoto e verrà eliminato.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Sposta $count articoli in $target.';
  }

  @override
  String get deleteMigrateTitle => 'Elimina e migra?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Sposta $items articoli in \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Conferma e sposta';

  @override
  String get cannotDeleteDefault =>
      'Impossibile eliminare l\'elemento predefinito!';

  @override
  String get containsSubItems => 'Contiene sotto-elementi.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Predefinito $name non trovato.';
  }

  @override
  String get errorNameExists => 'Nome già esistente.';

  @override
  String get searchHint => 'Cerca...';

  @override
  String get noItemsFound => 'Nessun articolo trovato';

  @override
  String noItemsFoundFor(Object query) {
    return 'Nessun risultato per $query';
  }

  @override
  String get filtersHeader => 'Filtri: ';

  @override
  String get emptyList => 'Vuoto';

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
  String get unitPcs => 'pz';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'confezione';

  @override
  String get unitBox => 'scatola';

  @override
  String get unitBag => 'sacchetto';

  @override
  String get unitBottle => 'bottiglia';

  @override
  String get valOther => 'Altro';

  @override
  String get valMisc => 'Varie';

  @override
  String get valKitchen => 'Cucina';

  @override
  String get valFridge => 'Frigorifero';

  @override
  String get valPantry => 'Dispensa';

  @override
  String get valBathroom => 'Bagno';

  @override
  String get valFood => 'Cibo';

  @override
  String get valBattery => 'Batteria';

  @override
  String get imageGallery => 'Galleria';

  @override
  String get imageCamera => 'Fotocamera';

  @override
  String get errorNameRequired => 'Nome richiesto';

  @override
  String get timeUnitDay => 'Giorno';

  @override
  String get timeUnitWeek => 'Settimana';

  @override
  String get timeUnitMonth => 'Mese';

  @override
  String get timeUnitYear => 'Anno';

  @override
  String get addReminder => 'Aggiungi promemoria';

  @override
  String get customReminderTitle => 'Promemoria personalizzato';

  @override
  String get enterValue => 'Inserisci valore';

  @override
  String get privacyPolicy => 'Privacy';

  @override
  String get errorExpiryRequired => 'Data di scadenza richiesta';

  @override
  String get deleteItemTitle => 'Elimina articolo?';

  @override
  String get deleteItemContent => 'L\'azione è irreversibile.';

  @override
  String get filterExpired => 'Scaduto';

  @override
  String get filterExpiringSoon => 'In scadenza';

  @override
  String get emptyInventoryPrompt =>
      'Inventario vuoto! Aggiungi il primo articolo.';

  @override
  String get noExpiringItems => 'Nessun articolo in scadenza';

  @override
  String get noExpiredItems => 'Nessun articolo scaduto';

  @override
  String get feedbackTitle => 'Invia feedback';

  @override
  String get feedbackDialogTitle => 'Ti piace UseUp?';

  @override
  String get feedbackDialogContent => 'Il tuo feedback ci aiuta a migliorare!';

  @override
  String get feedbackActionLove => 'Lo adoro!';

  @override
  String get feedbackActionImprove => 'Può migliorare';
}
