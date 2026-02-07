// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'UseUp';

  @override
  String get welcomeGreeting => '안녕하세요';

  @override
  String get navHome => '홈';

  @override
  String get navSettings => '설정';

  @override
  String get history => '기록';

  @override
  String get sectionExpiringSoon => '만료 예정';

  @override
  String get sectionAllItems => '모든 품목';

  @override
  String get scanItem => '품목 스캔';

  @override
  String daysLeft(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count일 남음',
      one: '내일',
      zero: '오늘',
    );
    return '$_temp0';
  }

  @override
  String get expired => '만료됨';

  @override
  String get statusUrgent => '긴급';

  @override
  String get statusWarning => '경고';

  @override
  String get statusSafe => '안전';

  @override
  String get name => '이름';

  @override
  String get quantity => '수량';

  @override
  String get category => '카테고리';

  @override
  String get location => '위치';

  @override
  String get price => '단가';

  @override
  String get expiryDate => '유통기한';

  @override
  String get productionDate => '제조일자';

  @override
  String get shelfLife => '보관 기간 (일)';

  @override
  String get purchaseDate => '구매일자';

  @override
  String get pickDate => '날짜 선택';

  @override
  String get toggleExpiryDate => '유통기한';

  @override
  String get toggleProductionDate => '제조일 + 보관 기간';

  @override
  String get reminderLabel => '알림';

  @override
  String get reminder1Day => '1일 전';

  @override
  String get reminder3Days => '3일 전';

  @override
  String get reminder7Days => '1주일 전';

  @override
  String get advancedDetails => '상세 설정';

  @override
  String get advancedSubtitle => '수량, 위치, 가격 등...';

  @override
  String calculatedExpiry(Object date) {
    return '계산된 만료일: $date';
  }

  @override
  String get testNotification => '테스트 알림';

  @override
  String get testNotificationSubtitle => '알림을 테스트하려면 클릭';

  @override
  String get addItem => '품목 추가';

  @override
  String get editItem => '품목 수정';

  @override
  String get save => '저장';

  @override
  String get saveAndNext => '저장 후 다음';

  @override
  String get updateItem => '품목 업데이트';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get markAsUsed => '사용 완료';

  @override
  String get restock => '재입고';

  @override
  String get filter => '필터';

  @override
  String get reset => '초기화';

  @override
  String get settingsTitle => '설정';

  @override
  String get language => '언어';

  @override
  String get switchLanguage => '언어 전환';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get manageCategories => '카테고리 관리';

  @override
  String get manageLocations => '위치 관리';

  @override
  String get manageMode => '관리 모드';

  @override
  String get locationSelect => '위치 선택';

  @override
  String get locationAdd => '위치 추가';

  @override
  String get locationAddSub => '하위 위치 추가';

  @override
  String get locationRename => '이름 변경';

  @override
  String get locationDeleteTitle => '위치를 삭제할까요?';

  @override
  String get locationName => '위치 이름';

  @override
  String get categorySelect => '카테고리 선택';

  @override
  String get categoryAdd => '카테고리 추가';

  @override
  String get categoryAddSub => '하위 카테고리 추가';

  @override
  String get categoryRename => '카테고리 이름 변경';

  @override
  String get categoryDeleteTitle => '카테고리를 삭제할까요?';

  @override
  String get itemConsumed => '사용 완료로 표시됨!';

  @override
  String get deleteConfirm => '품목이 포함되어 있어 삭제할 수 없습니다.';

  @override
  String get confirmDelete => '정말 삭제하시겠습니까?';

  @override
  String get deleteEmptyConfirm => '이 품목은 비어 있어 즉시 삭제됩니다.';

  @override
  String deleteMoveConfirm(Object count, Object target) {
    return '$count개의 품목을 $target(으)로 이동합니다.';
  }

  @override
  String get deleteMigrateTitle => '삭제 및 이동?';

  @override
  String deleteMigrateContent(Object items, Object subs, Object target) {
    return '$items개의 품목을 \'$target\'(으)로 이동합니다.';
  }

  @override
  String get confirmAndMove => '확인 및 이동';

  @override
  String get cannotDeleteDefault => '기본 항목은 삭제할 수 없습니다!';

  @override
  String get containsSubItems => '하위 항목이 포함되어 있습니다.';

  @override
  String errorDefaultNotFound(Object name) {
    return '기본 $name을(를) 찾을 수 없습니다.';
  }

  @override
  String get errorNameExists => '이름이 이미 존재합니다.';

  @override
  String get searchHint => '검색...';

  @override
  String get noItemsFound => '품목을 찾을 수 없음';

  @override
  String noItemsFoundFor(Object query) {
    return '$query에 대한 결과 없음';
  }

  @override
  String get filtersHeader => '필터: ';

  @override
  String get emptyList => '비어 있음';

  @override
  String get catVegetable => '채소';

  @override
  String get catFruit => '과일';

  @override
  String get catMeat => '육류';

  @override
  String get catDairy => '유제품';

  @override
  String get catPantry => '식료품 보관실';

  @override
  String get catSnack => '간식';

  @override
  String get catHealth => '건강기능식품';

  @override
  String get catUtility => '생활용품';

  @override
  String get unitPcs => '개';

  @override
  String get unitKg => 'kg';

  @override
  String get unitG => 'g';

  @override
  String get unitL => 'L';

  @override
  String get unitMl => 'ml';

  @override
  String get unitPack => '팩';

  @override
  String get unitBox => '상자';

  @override
  String get unitBag => '봉지';

  @override
  String get unitBottle => '병';

  @override
  String get valOther => '기타';

  @override
  String get valMisc => '미분류';

  @override
  String get valKitchen => '주방';

  @override
  String get valFridge => '냉장고';

  @override
  String get valPantry => '팬트리';

  @override
  String get valBathroom => '욕실';

  @override
  String get valFood => '음식';

  @override
  String get valBattery => '배터리';

  @override
  String get imageGallery => '갤러리';

  @override
  String get imageCamera => '카메라';

  @override
  String get errorNameRequired => '이름을 입력하세요';

  @override
  String get timeUnitDay => '일';

  @override
  String get timeUnitWeek => '주';

  @override
  String get timeUnitMonth => '월';

  @override
  String get timeUnitYear => '년';

  @override
  String get addReminder => '알림 추가';

  @override
  String get customReminderTitle => '사용자 지정 알림';

  @override
  String get enterValue => '값 입력';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get errorExpiryRequired => '만료일은 필수입니다';

  @override
  String get deleteItemTitle => '품목을 삭제할까요?';

  @override
  String get deleteItemContent => '이 작업은 되돌릴 수 없습니다.';

  @override
  String get filterExpired => '만료됨';

  @override
  String get filterExpiringSoon => '만료 예정';

  @override
  String get emptyInventoryPrompt => '목록이 비어 있습니다! 첫 번째 품목을 추가해 보세요.';

  @override
  String get noExpiringItems => '만료 예정인 품목이 없습니다';

  @override
  String get noExpiredItems => '만료된 품목이 없습니다';

  @override
  String get feedbackTitle => '피드백 보내기';

  @override
  String get feedbackDialogTitle => 'UseUp이 마음에 드시나요?';

  @override
  String get feedbackDialogContent => '여러분의 피드백이 큰 힘이 됩니다!';

  @override
  String get feedbackActionLove => '좋아요!';

  @override
  String get feedbackActionImprove => '개선이 필요해요';
}
