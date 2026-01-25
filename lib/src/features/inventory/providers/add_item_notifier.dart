import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../../models/item.dart';
import '../../../models/category.dart';
import '../../../models/location.dart';
import '../data/inventory_repository.dart';
import '../../../services/notification_service.dart';

enum TimeUnit { day, week, month, year }

// UI 状态模型
class AddItemState {
  final String name;
  final double quantity;
  final String unit;
  final double? price;
  final DateTime? expiryDate;
  final DateTime purchaseDate;
  final DateTime? productionDate;
  final int? shelfLifeDays;
  final TimeUnit shelfLifeUnit; // 新增：当前保质期单位
  final String shelfLifeInputValue; // 新增：输入框的值，作为 Single Source of Truth
  final List<int> notifyDaysList;
  final String? imagePath;
  final Category? selectedCategory;
  final Location? selectedLocation;
  final bool isProductionMode;
  final bool isLoading;

  AddItemState({
    this.name = '',
    this.quantity = 1.0,
    this.unit = 'pcs',
    this.price,
    this.expiryDate,
    DateTime? purchaseDate,
    this.productionDate,
    this.shelfLifeDays,
    this.shelfLifeUnit = TimeUnit.day,
    this.shelfLifeInputValue = '',
    this.notifyDaysList = const [1, 3],
    this.imagePath,
    this.selectedCategory,
    this.selectedLocation,
    this.isProductionMode = false,
    this.isLoading = false,
  }) : purchaseDate = purchaseDate ?? DateTime.now();

  AddItemState copyWith({
    String? name,
    double? quantity,
    String? unit,
    double? price,
    DateTime? expiryDate,
    DateTime? purchaseDate,
    DateTime? productionDate,
    int? shelfLifeDays,
    TimeUnit? shelfLifeUnit,
    String? shelfLifeInputValue,
    List<int>? notifyDaysList,
    String? imagePath,
    Category? selectedCategory,
    Location? selectedLocation,
    bool? isProductionMode,
    bool? isLoading,
  }) {
    return AddItemState(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      expiryDate: expiryDate ?? this.expiryDate,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      productionDate: productionDate ?? this.productionDate,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      shelfLifeUnit: shelfLifeUnit ?? this.shelfLifeUnit,
      shelfLifeInputValue: shelfLifeInputValue ?? this.shelfLifeInputValue,
      notifyDaysList: notifyDaysList ?? this.notifyDaysList,
      imagePath: imagePath ?? this.imagePath,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      isProductionMode: isProductionMode ?? this.isProductionMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AddItemNotifier extends StateNotifier<AddItemState> {
  final InventoryRepository _repository;
  final ImagePicker _picker = ImagePicker();

  AddItemNotifier(this._repository) : super(AddItemState());

  // 1. 初始化（编辑模式）
  Future<void> init(Item? item, {bool isRestock = false}) async {
    if (item == null) {
      state = state.copyWith(isLoading: true);
      final defLoc = await _repository.getDefaultLocation();
      final defCat = await _repository.getDefaultCategory();
      state = state.copyWith(
        selectedLocation: defLoc,
        selectedCategory: defCat,
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(isLoading: true);
    // 如果是补货（临时对象），不要从数据库加载 Link，因为它们还没存进去，
    // 而是直接使用 item 中已经赋值的 value。
    if (!isRestock) {
      await _repository.loadLinks(item);
    }
    
    // 智能推断保质期单位和初始输入值
    TimeUnit bestUnit = TimeUnit.day;
    String initialInput = '';
    
    if (item.shelfLifeDays != null && item.shelfLifeDays! > 0) {
      if (item.shelfLifeDays! % 365 == 0) {
        bestUnit = TimeUnit.year;
        initialInput = (item.shelfLifeDays! ~/ 365).toString();
      } else if (item.shelfLifeDays! % 30 == 0) {
        bestUnit = TimeUnit.month;
        initialInput = (item.shelfLifeDays! ~/ 30).toString();
      } else if (item.shelfLifeDays! % 7 == 0) {
        bestUnit = TimeUnit.week;
        initialInput = (item.shelfLifeDays! ~/ 7).toString();
      } else {
        initialInput = item.shelfLifeDays!.toString();
      }
    }

    state = AddItemState(
      name: item.name,
      quantity: item.quantity,
      unit: item.unit,
      price: item.price,
      expiryDate: item.expiryDate,
      purchaseDate: item.purchaseDate,
      productionDate: item.productionDate,
      shelfLifeDays: item.shelfLifeDays,
      shelfLifeUnit: bestUnit,
      shelfLifeInputValue: initialInput, // 初始化输入值
      notifyDaysList: List.from(item.notifyDaysList),
      imagePath: item.imagePath,
      selectedCategory: item.categoryLink.value,
      selectedLocation: item.locationLink.value,
      isProductionMode: item.productionDate != null,
      isLoading: false,
    );
  }

  // 2. 状态更新方法
  void updateName(String val) => state = state.copyWith(name: val);
  void updateQuantity(String val) => state = state.copyWith(quantity: double.tryParse(val) ?? 1.0);
  void updateUnit(String val) => state = state.copyWith(unit: val);
  void updatePrice(String val) => state = state.copyWith(price: double.tryParse(val));
  void updateExpiryDate(DateTime date) => state = state.copyWith(expiryDate: date);
  void updatePurchaseDate(DateTime date) => state = state.copyWith(purchaseDate: date);
  
  void updateProductionDate(DateTime date) {
    state = state.copyWith(productionDate: date);
    _calculateExpiry();
  }
  
  // 更新保质期数值 (Input changed)
  void updateShelfLife(String val) {
    state = state.copyWith(shelfLifeInputValue: val);
    _recalculateShelfLifeDays();
  }

  // 更新保质期单位 (Unit changed)
  void updateShelfLifeUnit(TimeUnit unit) {
    state = state.copyWith(shelfLifeUnit: unit);
    _recalculateShelfLifeDays();
  }
  
  // 统一计算逻辑：根据 inputValue 和 unit 计算 days
  void _recalculateShelfLifeDays() {
    final valInt = int.tryParse(state.shelfLifeInputValue);
    if (valInt == null) {
      state = state.copyWith(shelfLifeDays: null);
    } else {
      int totalDays = valInt;
      switch (state.shelfLifeUnit) {
        case TimeUnit.week: totalDays = valInt * 7; break;
        case TimeUnit.month: totalDays = valInt * 30; break;
        case TimeUnit.year: totalDays = valInt * 365; break;
        case TimeUnit.day: default: totalDays = valInt; break;
      }
      state = state.copyWith(shelfLifeDays: totalDays);
    }
    _calculateExpiry();
  }

  void toggleProductionMode(bool val) => state = state.copyWith(isProductionMode: val);
  
  void toggleNotifyDay(int day) {
    final list = List<int>.from(state.notifyDaysList);
    if (list.contains(day)) list.remove(day);
    else list.add(day);
    // 排序，保持美观
    list.sort();
    state = state.copyWith(notifyDaysList: list);
  }
  
  void addCustomNotifyDay(int val, TimeUnit unit) {
    int days = val;
    switch (unit) {
      case TimeUnit.week: days = val * 7; break;
      case TimeUnit.month: days = val * 30; break;
      case TimeUnit.year: days = val * 365; break;
      case TimeUnit.day: default: days = val; break;
    }
    
    if (days > 0 && !state.notifyDaysList.contains(days)) {
      final list = List<int>.from(state.notifyDaysList);
      list.add(days);
      list.sort();
      state = state.copyWith(notifyDaysList: list);
    }
  }

  void updateCategory(Category cat) => state = state.copyWith(selectedCategory: cat);
  void updateLocation(Location loc) => state = state.copyWith(selectedLocation: loc);

  void _calculateExpiry() {
    if (state.productionDate != null && state.shelfLifeDays != null) {
      state = state.copyWith(
        expiryDate: state.productionDate!.add(Duration(days: state.shelfLifeDays!))
      );
    }
  }

  // 3. 图片处理
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile == null) return;
    
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String savedPath = '${directory.path}/$fileName';
    await File(pickedFile.path).copy(savedPath);
    state = state.copyWith(imagePath: savedPath);
  }

  // 4. 业务：保存逻辑
  Future<bool> save({Item? itemToEdit, bool addNext = false}) async {
    if (state.expiryDate == null) return false;

    state = state.copyWith(isLoading: true);
    try {
      Item item;
      if (itemToEdit != null && !addNext) {
        item = itemToEdit;
        item.name = state.name;
        item.quantity = state.quantity;
        item.unit = state.unit;
        item.price = state.price;
        item.purchaseDate = state.purchaseDate;
        item.expiryDate = state.expiryDate;
        item.productionDate = state.isProductionMode ? state.productionDate : null;
        item.shelfLifeDays = state.isProductionMode ? state.shelfLifeDays : null;
        item.notifyDaysList = state.notifyDaysList;
        item.imagePath = state.imagePath;
      } else {
        item = Item(
          name: state.name,
          quantity: state.quantity,
          unit: state.unit,
          price: state.price,
          purchaseDate: state.purchaseDate,
          expiryDate: state.expiryDate,
          productionDate: state.isProductionMode ? state.productionDate : null,
          shelfLifeDays: state.isProductionMode ? state.shelfLifeDays : null,
          notifyDaysList: state.notifyDaysList,
          imagePath: state.imagePath,
        );
      }

      await _repository.saveItem(item, state.selectedCategory, state.selectedLocation);
      await NotificationService().scheduleNotifications(item);

      if (addNext) {
        final defLoc = await _repository.getDefaultLocation();
        final defCat = await _repository.getDefaultCategory();
        // 重置状态但保留一些偏好
        state = AddItemState(
          selectedLocation: state.selectedLocation ?? defLoc,
          selectedCategory: state.selectedCategory ?? defCat,
          // 保留当前选择的单位，方便连续录入
          shelfLifeUnit: state.shelfLifeUnit,
        );
      } else {
        // 如果是关闭页面，不需要重置 state，但要关闭 loading
        state = state.copyWith(isLoading: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // 可以考虑这里 rethrow 或者返回 false 并在 UI 处理
      // print('Save error: $e'); 
      return false;
    }
  }
}

final addItemProvider = StateNotifierProvider.autoDispose<AddItemNotifier, AddItemState>((ref) {
  final repo = ref.watch(inventoryRepositoryProvider);
  return AddItemNotifier(repo);
});
