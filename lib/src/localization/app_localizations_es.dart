// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Buenos días';

  @override
  String get navHome => 'Inicio';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get history => 'Historial';

  @override
  String get sectionExpiringSoon => 'Caduca pronto';

  @override
  String get sectionAllItems => 'Todos los artículos';

  @override
  String get scanItem => 'Escanear artículo';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltan $count días',
      one: 'Mañana',
      zero: 'Hoy',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Caducado';

  @override
  String get statusUrgent => 'Urgente';

  @override
  String get statusWarning => 'Aviso';

  @override
  String get statusSafe => 'Seguro';

  @override
  String get name => 'Nombre';

  @override
  String get quantity => 'Cantidad';

  @override
  String get category => 'Categoría';

  @override
  String get location => 'Ubicación';

  @override
  String get price => 'Precio unitario';

  @override
  String get expiryDate => 'Fecha de caducidad';

  @override
  String get productionDate => 'Fecha de producción';

  @override
  String get shelfLife => 'Vida útil (días)';

  @override
  String get purchaseDate => 'Fecha de compra';

  @override
  String get pickDate => 'Elegir fecha';

  @override
  String get toggleExpiryDate => 'Fecha de caducidad';

  @override
  String get toggleProductionDate => 'Fecha prod. + vida útil';

  @override
  String get reminderLabel => 'Recordatorio';

  @override
  String get reminder1Day => '1 día antes';

  @override
  String get reminder3Days => '3 días antes';

  @override
  String get reminder7Days => '1 semana antes';

  @override
  String get advancedDetails => 'Detalles avanzados';

  @override
  String get advancedSubtitle => 'Cantidad, ubicación, precio...';

  @override
  String calculatedExpiry(Object date) {
    return 'Caducidad calculada: $date';
  }

  @override
  String get testNotification => 'Notificación de prueba';

  @override
  String get testNotificationSubtitle => 'Haz clic para activar una alerta';

  @override
  String get addItem => 'Añadir artículo';

  @override
  String get editItem => 'Editar artículo';

  @override
  String get save => 'Guardar';

  @override
  String get saveAndNext => 'Guardar y Siguiente';

  @override
  String get updateItem => 'Actualizar artículo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get markAsUsed => 'Usado';

  @override
  String get restock => 'Reponer';

  @override
  String get filter => 'Filtro';

  @override
  String get reset => 'Restablecer';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get switchLanguage => 'Cambiar idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get manageCategories => 'Gestionar categorías';

  @override
  String get manageLocations => 'Gestionar ubicaciones';

  @override
  String get manageMode => 'Modo gestión';

  @override
  String get locationSelect => 'Seleccionar ubicación';

  @override
  String get locationAdd => 'Añadir ubicación';

  @override
  String get locationAddSub => 'Añadir sub-ubicación';

  @override
  String get locationRename => 'Renombrar ubicación';

  @override
  String get locationDeleteTitle => '¿Eliminar ubicación?';

  @override
  String get locationName => 'Nombre de la ubicación';

  @override
  String get categorySelect => 'Seleccionar categoría';

  @override
  String get categoryAdd => 'Añadir categoría';

  @override
  String get categoryAddSub => 'Añadir sub-categoría';

  @override
  String get categoryRename => 'Renombrar categoría';

  @override
  String get categoryDeleteTitle => '¿Eliminar categoría?';

  @override
  String get itemConsumed => '¡Artículo marcado como consumido!';

  @override
  String get deleteConfirm => 'Contiene artículos. No se puede eliminar.';

  @override
  String get confirmDelete => '¿Estás seguro de que quieres eliminar?';

  @override
  String get deleteEmptyConfirm => 'Este artículo está vacío y se eliminará.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Mover $count artículos a $target.';
  }

  @override
  String get deleteMigrateTitle => '¿Eliminar y migrar?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Mover $items artículos a \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Confirmar y mover';

  @override
  String get cannotDeleteDefault =>
      '¡No se puede eliminar el elemento por defecto!';

  @override
  String get containsSubItems => 'Contiene sub-elementos.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Predeterminado $name no encontrado.';
  }

  @override
  String get errorNameExists => 'El nombre ya existe.';

  @override
  String get searchHint => 'Buscar...';

  @override
  String get noItemsFound => 'No se encontraron artículos';

  @override
  String noItemsFoundFor(Object query) {
    return 'Sin resultados para $query';
  }

  @override
  String get filtersHeader => 'Filtros: ';

  @override
  String get emptyList => 'Vacío';

  @override
  String get catVegetable => 'Verdura';

  @override
  String get catFruit => 'Fruta';

  @override
  String get catMeat => 'Carne';

  @override
  String get catDairy => 'Lácteos';

  @override
  String get catPantry => 'Despensa';

  @override
  String get catSnack => 'Snack';

  @override
  String get catHealth => 'Salud';

  @override
  String get catUtility => 'Utilidad';

  @override
  String get unitPcs => 'uds';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'paquete';

  @override
  String get unitBox => 'caja';

  @override
  String get unitBag => 'bolsa';

  @override
  String get unitBottle => 'botella';

  @override
  String get valOther => 'Otro';

  @override
  String get valMisc => 'Varios';

  @override
  String get valKitchen => 'Cocina';

  @override
  String get valFridge => 'Nevera';

  @override
  String get valPantry => 'Despensa';

  @override
  String get valBathroom => 'Baño';

  @override
  String get valFood => 'Comida';

  @override
  String get valBattery => 'Batería';

  @override
  String get imageGallery => 'Galería';

  @override
  String get imageCamera => 'Cámara';

  @override
  String get errorNameRequired => 'Nombre obligatorio';

  @override
  String get timeUnitDay => 'Día';

  @override
  String get timeUnitWeek => 'Semana';

  @override
  String get timeUnitMonth => 'Mes';

  @override
  String get timeUnitYear => 'Año';

  @override
  String get addReminder => 'Añadir recordatorio';

  @override
  String get customReminderTitle => 'Recordatorio personalizado';

  @override
  String get enterValue => 'Introduce valor';

  @override
  String get privacyPolicy => 'Privacidad';

  @override
  String get errorExpiryRequired => 'Fecha de caducidad obligatoria';

  @override
  String get deleteItemTitle => '¿Eliminar artículo?';

  @override
  String get deleteItemContent => 'Esta acción no se puede deshacer.';

  @override
  String get filterExpired => 'Caducado';

  @override
  String get filterExpiringSoon => 'Caduca pronto';

  @override
  String get emptyInventoryPrompt =>
      '¡Inventario vacío! Añade tu primer artículo.';

  @override
  String get noExpiringItems => 'No hay artículos que caduquen pronto';

  @override
  String get noExpiredItems => 'No hay artículos caducados';

  @override
  String get feedbackTitle => 'Enviar comentarios';

  @override
  String get feedbackDialogTitle => '¿Te gusta UseUp?';

  @override
  String get feedbackDialogContent => '¡Tus comentarios nos ayudan a mejorar!';

  @override
  String get feedbackActionLove => '¡Me encanta!';

  @override
  String get feedbackActionImprove => 'Puede mejorar';
}
