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
    
    // 智能推断保质期单位
    TimeUnit bestUnit = TimeUnit.day;
    int displayShelfLife = item.shelfLifeDays ?? 0;
    
    if (item.shelfLifeDays != null && item.shelfLifeDays! > 0) {
      if (item.shelfLifeDays! % 365 == 0) {
        bestUnit = TimeUnit.year;
      } else if (item.shelfLifeDays! % 30 == 0) {
        bestUnit = TimeUnit.month;
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
  
  // 更新保质期数值
  void updateShelfLife(String val) {
    final valInt = int.tryParse(val);
    if (valInt == null) {
      state = state.copyWith(shelfLifeDays: null);
      return; 
    }
    _updateShelfLifeWithUnit(valInt, state.shelfLifeUnit);
  }

  // 更新保质期单位
  void updateShelfLifeUnit(TimeUnit unit) {
    // 获取当前显示的值（需要反向计算出当前输入框里的值，或者在 State 里存 input value，
    // 但为了简单，我们假设调用此方法前，UI 会把当前的 converted days 重新根据新 unit 计算并不太对。
    // 更好的方式是：UI 层的 Controller 保持数字不变，只改变单位，然后重新计算总天数。
    
    // 这里我们假设当前的 shelfLifeDays 已经是最新的总天数
    // 但这个逻辑有点绕，因为 shelfLifeDays 存的是总天数。
    // 如果用户输入 "1" 选 "年"，总天数是 365。
    // 然后用户改为 "月"，由于 Controller 里的字还是 "1"，所以逻辑应该是：
    // 保持输入的数字不变，改变单位乘数。
    
    // 所以我们需要 UI 传过来当前的输入值，或者我们存一个 inputValue。
    // 鉴于目前架构，我们在 updateShelfLifeUnit 时，并不改变 shelfLifeDays，
    // 而是等待 updateShelfLife 被再次调用（通常 UI 会联动），
    // 或者我们在此处重新计算：
    // 但这里拿不到 Input 的值。
    
    // 修正策略：State 里存 unit，计算逻辑在 helper。
    state = state.copyWith(shelfLifeUnit: unit);
    // 注意：这里没有重新计算 expiry，因为必须配合具体的数值。
    // 我们依赖 UI 在改变 Unit 后，手动触发一次 updateShelfLife (带上当前的 text) 或者在 UI 上触发 _calculateExpiry。
    // 为了简化，我们在下面提供一个 helper 给 UI 调用。
  }
  
  // 供 UI 调用：同时更新数值和单位
  void updateShelfLifeAndUnit(String val, TimeUnit unit) {
     final valInt = int.tryParse(val);
     state = state.copyWith(shelfLifeUnit: unit); // 先更新单位
     if (valInt != null) {
       _updateShelfLifeWithUnit(valInt, unit);
     } else {
        state = state.copyWith(shelfLifeDays: null);
     }
  }

  void _updateShelfLifeWithUnit(int val, TimeUnit unit) {
    int totalDays = val;
    switch (unit) {
      case TimeUnit.week: totalDays = val * 7; break;
      case TimeUnit.month: totalDays = val * 30; break;
      case TimeUnit.year: totalDays = val * 365; break;
      case TimeUnit.day: default: totalDays = val; break;
    }
    state = state.copyWith(shelfLifeDays: totalDays);
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
    final String fileName = p.basename(pickedFile.path);
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
      await NotificationService().scheduleExpiryNotification(item);

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
