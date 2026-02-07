// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Bom dia';

  @override
  String get navHome => 'Início';

  @override
  String get navSettings => 'Definições';

  @override
  String get history => 'Histórico';

  @override
  String get sectionExpiringSoon => 'Expira em breve';

  @override
  String get sectionAllItems => 'Todos os artigos';

  @override
  String get scanItem => 'Digitalizar artigo';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Amanhã',
      zero: 'Hoje',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Expirado';

  @override
  String get statusUrgent => 'Urgente';

  @override
  String get statusWarning => 'Aviso';

  @override
  String get statusSafe => 'Seguro';

  @override
  String get name => 'Nome';

  @override
  String get quantity => 'Quantidade';

  @override
  String get category => 'Categoria';

  @override
  String get location => 'Localização';

  @override
  String get price => 'Preço unitário';

  @override
  String get expiryDate => 'Data de validade';

  @override
  String get productionDate => 'Data de produção';

  @override
  String get shelfLife => 'Validade (dias)';

  @override
  String get purchaseDate => 'Data de compra';

  @override
  String get pickDate => 'Escolher data';

  @override
  String get toggleExpiryDate => 'Data de validade';

  @override
  String get toggleProductionDate => 'Data prod. + validade';

  @override
  String get reminderLabel => 'Lembrete';

  @override
  String get reminder1Day => '1 dia antes';

  @override
  String get reminder3Days => '3 dias antes';

  @override
  String get reminder7Days => '1 semana antes';

  @override
  String get advancedDetails => 'Detalhes avançados';

  @override
  String get advancedSubtitle => 'Quantidade, localização, preço...';

  @override
  String calculatedExpiry(Object date) {
    return 'Validade calculada: $date';
  }

  @override
  String get testNotification => 'Notificação de teste';

  @override
  String get testNotificationSubtitle => 'Clique para acionar um alerta';

  @override
  String get addItem => 'Adicionar artigo';

  @override
  String get editItem => 'Editar artigo';

  @override
  String get save => 'Guardar';

  @override
  String get saveAndNext => 'Guardar e Próximo';

  @override
  String get updateItem => 'Atualizar artigo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Eliminar';

  @override
  String get markAsUsed => 'Usado';

  @override
  String get restock => 'Repor';

  @override
  String get filter => 'Filtro';

  @override
  String get reset => 'Repor';

  @override
  String get settingsTitle => 'Definições';

  @override
  String get language => 'Idioma';

  @override
  String get switchLanguage => 'Alterar idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get manageCategories => 'Gerir categorias';

  @override
  String get manageLocations => 'Gerir localizações';

  @override
  String get manageMode => 'Modo de gestão';

  @override
  String get locationSelect => 'Selecionar localização';

  @override
  String get locationAdd => 'Adicionar localização';

  @override
  String get locationAddSub => 'Adicionar sub-localização';

  @override
  String get locationRename => 'Renomear localização';

  @override
  String get locationDeleteTitle => 'Eliminar localização?';

  @override
  String get locationName => 'Nome da localização';

  @override
  String get categorySelect => 'Selecionar categoria';

  @override
  String get categoryAdd => 'Adicionar categoria';

  @override
  String get categoryAddSub => 'Adicionar sub-categoria';

  @override
  String get categoryRename => 'Renomear categoria';

  @override
  String get categoryDeleteTitle => 'Eliminar categoria?';

  @override
  String get itemConsumed => 'Artigo marcado como consumido!';

  @override
  String get deleteConfirm => 'Contém artigos. Impossível eliminar.';

  @override
  String get confirmDelete => 'Tem a certeza que deseja eliminar?';

  @override
  String get deleteEmptyConfirm => 'Este artigo está vazio e será eliminado.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Mover $count artigos para $target.';
  }

  @override
  String get deleteMigrateTitle => 'Eliminar e migrar?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Mover $items artigos para \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Confirmar e mover';

  @override
  String get cannotDeleteDefault => 'Impossível eliminar o item predefinido!';

  @override
  String get containsSubItems => 'Contém sub-itens.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Predefinido $name não encontrado.';
  }

  @override
  String get errorNameExists => 'O nome já existe.';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get noItemsFound => 'Nenhum artigo encontrado';

  @override
  String noItemsFoundFor(Object query) {
    return 'Sem resultados para $query';
  }

  @override
  String get filtersHeader => 'Filtros: ';

  @override
  String get emptyList => 'Vazio';

  @override
  String get catVegetable => 'Vegetal';

  @override
  String get catFruit => 'Fruta';

  @override
  String get catMeat => 'Carne';

  @override
  String get catDairy => 'Laticínios';

  @override
  String get catPantry => 'Despensa';

  @override
  String get catSnack => 'Snack';

  @override
  String get catHealth => 'Saúde';

  @override
  String get catUtility => 'Utilidade';

  @override
  String get unitPcs => 'un';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'pacote';

  @override
  String get unitBox => 'caixa';

  @override
  String get unitBag => 'saco';

  @override
  String get unitBottle => 'garrafa';

  @override
  String get valOther => 'Outro';

  @override
  String get valMisc => 'Vários';

  @override
  String get valKitchen => 'Cozinha';

  @override
  String get valFridge => 'Frigorífico';

  @override
  String get valPantry => 'Despensa';

  @override
  String get valBathroom => 'Casa de banho';

  @override
  String get valFood => 'Comida';

  @override
  String get valBattery => 'Pilha';

  @override
  String get imageGallery => 'Galeria';

  @override
  String get imageCamera => 'Câmara';

  @override
  String get errorNameRequired => 'Nome obrigatório';

  @override
  String get timeUnitDay => 'Dia';

  @override
  String get timeUnitWeek => 'Semana';

  @override
  String get timeUnitMonth => 'Mês';

  @override
  String get timeUnitYear => 'Ano';

  @override
  String get addReminder => 'Adicionar lembrete';

  @override
  String get customReminderTitle => 'Lembrete personalizado';

  @override
  String get enterValue => 'Inserir valor';

  @override
  String get privacyPolicy => 'Privacidade';

  @override
  String get errorExpiryRequired => 'Data de validade obrigatória';

  @override
  String get deleteItemTitle => 'Eliminar artigo?';

  @override
  String get deleteItemContent => 'Esta ação não pode ser desfeita.';

  @override
  String get filterExpired => 'Expirado';

  @override
  String get filterExpiringSoon => 'Expira em breve';

  @override
  String get emptyInventoryPrompt =>
      'Inventário vazio! Adicione o seu primeiro artigo.';

  @override
  String get noExpiringItems => 'Sem artigos a expirar em breve';

  @override
  String get noExpiredItems => 'Sem artigos expirados';

  @override
  String get feedbackTitle => 'Enviar feedback';

  @override
  String get feedbackDialogTitle => 'Gosta do UseUp?';

  @override
  String get feedbackDialogContent => 'O seu feedback ajuda-nos a melhorar!';

  @override
  String get feedbackActionLove => 'Adoro!';

  @override
  String get feedbackActionImprove => 'Pode melhorar';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Bom dia';

  @override
  String get navHome => 'Início';

  @override
  String get navSettings => 'Configurações';

  @override
  String get history => 'Histórico';

  @override
  String get sectionExpiringSoon => 'Vencendo em breve';

  @override
  String get sectionAllItems => 'Todos os itens';

  @override
  String get scanItem => 'Escanear item';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Amanhã',
      zero: 'Hoje',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Vencido';

  @override
  String get statusUrgent => 'Urgente';

  @override
  String get statusWarning => 'Aviso';

  @override
  String get statusSafe => 'Seguro';

  @override
  String get name => 'Nome';

  @override
  String get quantity => 'Quantidade';

  @override
  String get category => 'Categoria';

  @override
  String get location => 'Localização';

  @override
  String get price => 'Preço unitário';

  @override
  String get expiryDate => 'Data de validade';

  @override
  String get productionDate => 'Data de produção';

  @override
  String get shelfLife => 'Validade (dias)';

  @override
  String get purchaseDate => 'Data de compra';

  @override
  String get pickDate => 'Escolher data';

  @override
  String get toggleExpiryDate => 'Data de validade';

  @override
  String get toggleProductionDate => 'Data prod. + validade';

  @override
  String get reminderLabel => 'Lembrete';

  @override
  String get reminder1Day => '1 dia antes';

  @override
  String get reminder3Days => '3 dias antes';

  @override
  String get reminder7Days => '1 semana antes';

  @override
  String get advancedDetails => 'Detalhes avançados';

  @override
  String get advancedSubtitle => 'Quantidade, localização, preço...';

  @override
  String calculatedExpiry(Object date) {
    return 'Validade calculada: $date';
  }

  @override
  String get testNotification => 'Notificação de teste';

  @override
  String get testNotificationSubtitle => 'Clique para acionar um alerta';

  @override
  String get addItem => 'Adicionar item';

  @override
  String get editItem => 'Editar item';

  @override
  String get save => 'Salvar';

  @override
  String get saveAndNext => 'Salvar e Próximo';

  @override
  String get updateItem => 'Atualizar item';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get delete => 'Excluir';

  @override
  String get markAsUsed => 'Usado';

  @override
  String get restock => 'Repor';

  @override
  String get filter => 'Filtro';

  @override
  String get reset => 'Redefinir';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get language => 'Idioma';

  @override
  String get switchLanguage => 'Alterar idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get manageCategories => 'Gerenciar categorias';

  @override
  String get manageLocations => 'Gerenciar localizações';

  @override
  String get manageMode => 'Modo de gerenciamento';

  @override
  String get locationSelect => 'Selecionar localização';

  @override
  String get locationAdd => 'Adicionar localização';

  @override
  String get locationAddSub => 'Adicionar sublocalização';

  @override
  String get locationRename => 'Renomear localização';

  @override
  String get locationDeleteTitle => 'Excluir localização?';

  @override
  String get locationName => 'Nome da localização';

  @override
  String get categorySelect => 'Selecionar categoria';

  @override
  String get categoryAdd => 'Adicionar categoria';

  @override
  String get categoryAddSub => 'Adicionar subcategoria';

  @override
  String get categoryRename => 'Renomear categoria';

  @override
  String get categoryDeleteTitle => 'Excluir categoria?';

  @override
  String get itemConsumed => 'Item marcado como consumido!';

  @override
  String get deleteConfirm => 'Contém itens. Não é possível excluir.';

  @override
  String get confirmDelete => 'Tem certeza que deseja excluir?';

  @override
  String get deleteEmptyConfirm => 'Este item está vazio e será excluído.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return 'Mover $count itens para $target.';
  }

  @override
  String get deleteMigrateTitle => 'Excluir e migrar?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return 'Mover $items itens para \'$target\'.';
  }

  @override
  String get confirmAndMove => 'Confirmar e mover';

  @override
  String get cannotDeleteDefault => 'Não é possível excluir o item padrão!';

  @override
  String get containsSubItems => 'Contém subitens.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Padrão $name não encontrado.';
  }

  @override
  String get errorNameExists => 'O nome já existe.';

  @override
  String get searchHint => 'Pesquisar...';

  @override
  String get noItemsFound => 'Nenhum item encontrado';

  @override
  String noItemsFoundFor(Object query) {
    return 'Sem resultados para $query';
  }

  @override
  String get filtersHeader => 'Filtros: ';

  @override
  String get emptyList => 'Vazio';

  @override
  String get catVegetable => 'Vegetal';

  @override
  String get catFruit => 'Fruta';

  @override
  String get catMeat => 'Carne';

  @override
  String get catDairy => 'Laticínios';

  @override
  String get catPantry => 'Despensa';

  @override
  String get catSnack => 'Lanche';

  @override
  String get catHealth => 'Saúde';

  @override
  String get catUtility => 'Utilidade';

  @override
  String get unitPcs => 'un';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'pacote';

  @override
  String get unitBox => 'caixa';

  @override
  String get unitBag => 'saco';

  @override
  String get unitBottle => 'garrafa';

  @override
  String get valOther => 'Outro';

  @override
  String get valMisc => 'Vários';

  @override
  String get valKitchen => 'Cozinha';

  @override
  String get valFridge => 'Geladeira';

  @override
  String get valPantry => 'Despensa';

  @override
  String get valBathroom => 'Banheiro';

  @override
  String get valFood => 'Comida';

  @override
  String get valBattery => 'Pilha';

  @override
  String get imageGallery => 'Galeria';

  @override
  String get imageCamera => 'Câmera';

  @override
  String get errorNameRequired => 'Nome obrigatório';

  @override
  String get timeUnitDay => 'Dia';

  @override
  String get timeUnitWeek => 'Semana';

  @override
  String get timeUnitMonth => 'Mês';

  @override
  String get timeUnitYear => 'Ano';

  @override
  String get addReminder => 'Adicionar lembrete';

  @override
  String get customReminderTitle => 'Lembrete personalizado';

  @override
  String get enterValue => 'Inserir valor';

  @override
  String get privacyPolicy => 'Privacidade';

  @override
  String get errorExpiryRequired => 'Data de validade obrigatória';

  @override
  String get deleteItemTitle => 'Excluir item?';

  @override
  String get deleteItemContent => 'Esta ação não pode ser desfeita.';

  @override
  String get filterExpired => 'Vencido';

  @override
  String get filterExpiringSoon => 'Vencendo em breve';

  @override
  String get emptyInventoryPrompt =>
      'Inventário vazio! Adicione seu primeiro item.';

  @override
  String get noExpiringItems => 'Sem itens vencendo em breve';

  @override
  String get noExpiredItems => 'Sem itens vencidos';

  @override
  String get feedbackTitle => 'Enviar feedback';

  @override
  String get feedbackDialogTitle => 'Gosta do UseUp?';

  @override
  String get feedbackDialogContent => 'Seu feedback nos ajuda a melhorar!';

  @override
  String get feedbackActionLove => 'Adoro!';

  @override
  String get feedbackActionImprove => 'Pode melhorar';
}
