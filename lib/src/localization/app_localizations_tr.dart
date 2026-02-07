// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => 'Günaydın';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get history => 'Geçmiş';

  @override
  String get sectionExpiringSoon => 'Süresi Yaklaşanlar';

  @override
  String get sectionAllItems => 'Tüm Ürünler';

  @override
  String get scanItem => 'Ürünü Tara';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün kaldı',
      one: 'Yarın',
      zero: 'Bugün',
    );
    return '$_temp0';
  }

  @override
  String get expired => 'Süresi Doldu';

  @override
  String get statusUrgent => 'Acil';

  @override
  String get statusWarning => 'Uyarı';

  @override
  String get statusSafe => 'Güvenli';

  @override
  String get name => 'İsim';

  @override
  String get quantity => 'Miktar';

  @override
  String get category => 'Kategori';

  @override
  String get location => 'Konum';

  @override
  String get price => 'Birim Fiyat';

  @override
  String get expiryDate => 'Son Kullanma Tarihi';

  @override
  String get productionDate => 'Üretim Tarihi';

  @override
  String get shelfLife => 'Raf Ömrü (Gün)';

  @override
  String get purchaseDate => 'Satın Alma Tarihi';

  @override
  String get pickDate => 'Tarih Seç';

  @override
  String get toggleExpiryDate => 'Son Kullanma Tarihi';

  @override
  String get toggleProductionDate => 'Üretim Tarihi + Raf Ömrü';

  @override
  String get reminderLabel => 'Hatırlatıcı';

  @override
  String get reminder1Day => '1 gün önce';

  @override
  String get reminder3Days => '3 gün önce';

  @override
  String get reminder7Days => '1 hafta önce';

  @override
  String get advancedDetails => 'Gelişmiş Detaylar';

  @override
  String get advancedSubtitle => 'Miktar, konum, fiyat...';

  @override
  String calculatedExpiry(Object date) {
    return 'Hesaplanan SKT: $date';
  }

  @override
  String get testNotification => 'Test Bildirimi';

  @override
  String get testNotificationSubtitle => 'Uyarıyı tetiklemek için tıkla';

  @override
  String get addItem => 'Ürün Ekle';

  @override
  String get editItem => 'Ürünü Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get saveAndNext => 'Kaydet ve Sonraki';

  @override
  String get updateItem => 'Ürünü Güncelle';

  @override
  String get cancel => 'İptal';

  @override
  String get confirm => 'Onayla';

  @override
  String get delete => 'Sil';

  @override
  String get markAsUsed => 'Kullanıldı';

  @override
  String get restock => 'Stok Yenile';

  @override
  String get filter => 'Filtre';

  @override
  String get reset => 'Sıfırla';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get language => 'Dil';

  @override
  String get switchLanguage => 'Dili Değiştir';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String get manageCategories => 'Kategorileri Yönet';

  @override
  String get manageLocations => 'Konumları Yönet';

  @override
  String get manageMode => 'Yönetim Modu';

  @override
  String get locationSelect => 'Konum Seç';

  @override
  String get locationAdd => 'Konum Ekle';

  @override
  String get locationAddSub => 'Alt Konum Ekle';

  @override
  String get locationRename => 'Konumu Yeniden Adlandır';

  @override
  String get locationDeleteTitle => 'Konumu Sil?';

  @override
  String get locationName => 'Konum Adı';

  @override
  String get categorySelect => 'Kategori Seç';

  @override
  String get categoryAdd => 'Kategori Ekle';

  @override
  String get categoryAddSub => 'Alt Kategori Ekle';

  @override
  String get categoryRename => 'Kategoriyi Yeniden Adlandır';

  @override
  String get categoryDeleteTitle => 'Kategoriyi Sil?';

  @override
  String get itemConsumed => 'Ürün tüketildi olarak işaretlendi!';

  @override
  String get deleteConfirm => 'Ürün içeriyor. Silinemez.';

  @override
  String get confirmDelete => 'Silmek istediğinizden emin misiniz?';

  @override
  String get deleteEmptyConfirm => 'Bu ürün boş ve doğrudan silinecek.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return '$count ürünü $target konumuna taşı.';
  }

  @override
  String get deleteMigrateTitle => 'Sil ve Taşı?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return '$items ürünü \'$target\' konumuna taşı.';
  }

  @override
  String get confirmAndMove => 'Onayla ve Taşı';

  @override
  String get cannotDeleteDefault => 'Varsayılan öğe silinemez!';

  @override
  String get containsSubItems => 'Alt öğeler içeriyor.';

  @override
  String errorDefaultNotFound(Object name) {
    return 'Varsayılan $name bulunamadı.';
  }

  @override
  String get errorNameExists => 'Bu isim zaten mevcut.';

  @override
  String get searchHint => 'Ara...';

  @override
  String get noItemsFound => 'Ürün bulunamadı';

  @override
  String noItemsFoundFor(Object query) {
    return '$query için sonuç bulunamadı';
  }

  @override
  String get filtersHeader => 'Filtreler: ';

  @override
  String get emptyList => 'Boş';

  @override
  String get catVegetable => 'Sebze';

  @override
  String get catFruit => 'Meyve';

  @override
  String get catMeat => 'Et';

  @override
  String get catDairy => 'Süt Ürünleri';

  @override
  String get catPantry => 'Kiler';

  @override
  String get catSnack => 'Atıştırmalık';

  @override
  String get catHealth => 'Sağlık';

  @override
  String get catUtility => 'Gereçler';

  @override
  String get unitPcs => 'adet';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => 'paket';

  @override
  String get unitBox => 'kutu';

  @override
  String get unitBag => 'torba';

  @override
  String get unitBottle => 'şişe';

  @override
  String get valOther => 'Diğer';

  @override
  String get valMisc => 'Çeşitli';

  @override
  String get valKitchen => 'Mutfak';

  @override
  String get valFridge => 'Buzdolabı';

  @override
  String get valPantry => 'Kiler';

  @override
  String get valBathroom => 'Banyo';

  @override
  String get valFood => 'Gıda';

  @override
  String get valBattery => 'Pil';

  @override
  String get imageGallery => 'Galeri';

  @override
  String get imageCamera => 'Kamera';

  @override
  String get errorNameRequired => 'İsim gerekli';

  @override
  String get timeUnitDay => 'Gün';

  @override
  String get timeUnitWeek => 'Hafta';

  @override
  String get timeUnitMonth => 'Ay';

  @override
  String get timeUnitYear => 'Yıl';

  @override
  String get addReminder => 'Hatırlatıcı Ekle';

  @override
  String get customReminderTitle => 'Özel Hatırlatıcı';

  @override
  String get enterValue => 'Değer girin';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get errorExpiryRequired => 'SKT gerekli';

  @override
  String get deleteItemTitle => 'Ürünü Sil?';

  @override
  String get deleteItemContent => 'Bu işlem geri alınamaz.';

  @override
  String get filterExpired => 'Süresi Doldu';

  @override
  String get filterExpiringSoon => 'Süresi Yaklaşanlar';

  @override
  String get emptyInventoryPrompt => 'Envanter boş! İlk ürünü eklemeyi dene.';

  @override
  String get noExpiringItems => 'Süresi yaklaşan ürün yok';

  @override
  String get noExpiredItems => 'Süresi dolmuş ürün yok';

  @override
  String get feedbackTitle => 'Geri Bildirim Gönder';

  @override
  String get feedbackDialogTitle => 'UseUp\'ı sevdiniz mi?';

  @override
  String get feedbackDialogContent =>
      'Geri bildirimleriniz gelişmemize yardımcı olur!';

  @override
  String get feedbackActionLove => 'Çok sevdim!';

  @override
  String get feedbackActionImprove => 'Daha iyi olabilir';
}
