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
  String get advancedSubtitle => 'Quantité, emplacement, prix...';

  @override
  String calculatedExpiry(Object date) {
    return 'Expiration calculée : $date';
  }

  @override
  String get testNotification => 'Notification de test';

  @override
  String get testNotificationSubtitle => 'Cliquez pour déclencher une alerte';

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
  String get markAsUsed => 'Utilisé';

  @override
  String get restock => 'Réapprovisionner';

  @override
  String get filter => 'Filtrer';

  @override
  String get reset => 'Réinitialiser';

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
  String get manageMode => 'Mode gestion';

  @override
  String get locationSelect => 'Choisir l\'emplacement';

  @override
  String get locationAdd => 'Ajouter un emplacement';

  @override
  String get locationAddSub => 'Ajouter un sous-emplacement';

  @override
  String get locationRename => 'Renommer l\'emplacement';

  @override
  String get locationDeleteTitle => 'Supprimer l\'emplacement ?';

  @override
  String get locationName => 'Nom de l\'emplacement';

  @override
  String get categorySelect => 'Choisir la catégorie';

  @override
  String get categoryAdd => 'Ajouter une catégorie';

  @override
  String get categoryAddSub => 'Ajouter une sous-catégorie';

  @override
  String get categoryRename => 'Renommer la catégorie';

  @override
  String get categoryDeleteTitle => 'Supprimer la catégorie ?';

  @override
  String get itemConsumed => 'Article marqué comme consommé !';

  @override
  String get deleteConfirm => 'Contient des articles. Suppression impossible.';

  @override
  String get confirmDelete => 'Voulez-vous vraiment supprimer ?';

  @override
  String get deleteEmptyConfirm => 'Cet article est vide et sera supprimé.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Déplacer $count articles vers $target.';
  }

  @override
  String get deleteMigrateTitle => 'Supprimer et migrer ?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Déplacer $items articles vers \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Confirmer et déplacer';

  @override
  String get cannotDeleteDefault =>
      'Impossible de supprimer l\'élément par défaut !';

  @override
  String get containsSubItems => 'Contient des sous-éléments.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Défaut $name non trouvé.';
  }

  @override
  String get errorNameExists => 'Ce nom existe déjà.';

  @override
  String get searchHint => 'Rechercher...';

  @override
  String get noItemsFound => 'Aucun article trouvé';

  @override
  String noItemsFoundFor(Object query) {
    return 'Rien trouvé pour $query';
  }

  @override
  String get filtersHeader => 'Filtres : ';

  @override
  String get emptyList => 'Vide';

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
  String get unitPack => 'paquet';

  @override
  String get unitBox => 'boîte';

  @override
  String get unitBag => 'sac';

  @override
  String get unitBottle => 'bouteille';

  @override
  String get valOther => 'Autre';

  @override
  String get valMisc => 'Divers';

  @override
  String get valKitchen => 'Cuisine';

  @override
  String get valFridge => 'Réfrigérateur';

  @override
  String get valPantry => 'Garde-manger';

  @override
  String get valBathroom => 'Salle de bain';

  @override
  String get valFood => 'Nourriture';

  @override
  String get valBattery => 'Pile';

  @override
  String get imageGallery => 'Galerie';

  @override
  String get imageCamera => 'Appareil photo';

  @override
  String get errorNameRequired => 'Nom requis';

  @override
  String get timeUnitDay => 'Jour';

  @override
  String get timeUnitWeek => 'Semaine';

  @override
  String get timeUnitMonth => 'Mois';

  @override
  String get timeUnitYear => 'An';

  @override
  String get addReminder => 'Ajouter un rappel';

  @override
  String get customReminderTitle => 'Rappel personnalisé';

  @override
  String get enterValue => 'Entrez une valeur';

  @override
  String get privacyPolicy => 'Confidentialité';

  @override
  String get errorExpiryRequired => 'Date d\'expiration requise';

  @override
  String get deleteItemTitle => 'Supprimer l\'article ?';

  @override
  String get deleteItemContent => 'Cette action est irréversible.';

  @override
  String get filterExpired => 'Expiré';

  @override
  String get filterExpiringSoon => 'Expire bientôt';

  @override
  String get emptyInventoryPrompt =>
      'Inventaire vide ! Ajoutez votre premier article.';

  @override
  String get noExpiringItems => 'Aucun article n\'expire bientôt';

  @override
  String get noExpiredItems => 'Aucun article expiré';

  @override
  String get feedbackTitle => 'Envoyer un avis';

  @override
  String get feedbackDialogTitle => 'Vous aimez UseUp ?';

  @override
  String get feedbackDialogContent => 'Votre avis nous aide à nous améliorer !';

  @override
  String get feedbackActionLove => 'J\'adore !';

  @override
  String get feedbackActionImprove => 'Peut mieux faire';
}
