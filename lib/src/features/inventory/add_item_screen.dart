import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:use_up/src/localization/app_localizations.dart';

import '../../config/theme.dart';
import '../../models/item.dart';
import '../../utils/localized_utils.dart';
import 'category_selector.dart';
import 'location_selector.dart';
import 'providers/add_item_notifier.dart';

class AddItemScreen extends ConsumerStatefulWidget {
  final Item? itemToEdit;
  const AddItemScreen({super.key, this.itemToEdit});

  @override
  ConsumerState<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends ConsumerState<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _shelfLifeController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(addItemProvider.notifier).init(widget.itemToEdit);
      final state = ref.read(addItemProvider);
      _nameController.text = state.name;
      _priceController.text = state.price?.toString() ?? '';
      _shelfLifeController.text = state.shelfLifeDays?.toString() ?? '';
      _quantityController.text = state.quantity % 1 == 0 
          ? state.quantity.toInt().toString() 
          : state.quantity.toString();
    });
    
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _shelfLifeController = TextEditingController();
    _quantityController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _shelfLifeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String _getUnitDisplayName(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'pcs': return l10n.unitPcs;
      case 'kg': return l10n.unitKg;
      case 'g': return l10n.unitG;
      case 'L': return l10n.unitL;
      case 'ml': return l10n.unitMl;
      case 'pack': return l10n.unitPack;
      case 'box': return l10n.unitBox;
      default: return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addItemProvider);
    final notifier = ref.read(addItemProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    String currency = Localizations.localeOf(context).languageCode == 'zh' ? '¥' : '\$';

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(widget.itemToEdit != null ? l10n.editItem : l10n.addItem, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), 
          children: [
            _buildImagePicker(state, notifier),

            _buildSection(children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(labelText: "${l10n.name} *", border: InputBorder.none, prefixIcon: const Icon(Icons.edit_outlined)),
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const Divider(),
              _buildDateModeTabs(state, notifier, l10n),
              _buildDateInputArea(state, notifier, l10n),
              const Divider(),
              _buildReminderSection(state, notifier, l10n),
            ]),

            _buildSection(isAdvanced: true, children: [
              _buildQuantityRow(state, notifier, l10n),
              const Divider(),
              _buildSelectorRow(
                label: l10n.category, 
                value: state.selectedCategory?.name ?? 'Unknown',
                icon: Icons.category_outlined,
                onTap: () => _showCategoryPicker(context, notifier),
              ),
              const Divider(),
              _buildSelectorRow(
                label: l10n.location, 
                value: state.selectedLocation?.name ?? 'Other',
                icon: Icons.kitchen_outlined,
                onTap: () => _showLocationPicker(context, notifier),
              ),
              const Divider(),
              _buildPurchaseDateRow(state, notifier, l10n),
              const Divider(),
              _buildPriceInput(state, notifier, l10n, currency),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(state, notifier, l10n),
    );
  }

  Widget _buildImagePicker(AddItemState state, AddItemNotifier notifier) {
    return Center(
      child: GestureDetector(
        onTap: () => _showImageSourceSheet(notifier),
        child: Container(
          width: 100, height: 100,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20),
            image: state.imagePath != null ? DecorationImage(image: FileImage(File(state.imagePath!)), fit: BoxFit.cover) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: state.imagePath == null ? Icon(Icons.add_a_photo, size: 30, color: Colors.grey[300]) : null,
        ),
      ),
    );
  }

  Widget _buildDateModeTabs(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildTab(l10n.toggleExpiryDate, !state.isProductionMode, () => notifier.toggleProductionMode(false)),
          const SizedBox(width: 12),
          _buildTab(l10n.toggleProductionDate, state.isProductionMode, () => notifier.toggleProductionMode(true)),
        ],
      ),
    );
  }

  Widget _buildDateInputArea(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    if (!state.isProductionMode) {
      return _buildDateRow(
        label: "${l10n.expiryDate} *",
        value: state.expiryDate,
        onTap: () async {
          final d = await showDatePicker(context: context, initialDate: state.expiryDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
          if (d != null) notifier.updateExpiryDate(d);
        },
      );
    }
    return Column(
      children: [
        _buildDateRow(
          label: l10n.productionDate,
          value: state.productionDate,
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: state.productionDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
            if (d != null) notifier.updateProductionDate(d);
          },
        ),
        TextFormField(
          controller: _shelfLifeController,
          onChanged: notifier.updateShelfLife,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.shelfLife, border: InputBorder.none, prefixIcon: const Icon(Icons.timer_outlined)),
        ),
        if (state.expiryDate != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(l10n.calculatedExpiry(DateFormat('yyyy-MM-dd').format(state.expiryDate!)), 
              style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildReminderSection(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.reminderLabel, style: const TextStyle(color: Colors.black87)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [1, 3, 7].map((d) => FilterChip(
            label: Text(d == 1 ? l10n.reminder1Day : d == 3 ? l10n.reminder3Days : l10n.reminder7Days),
            selected: state.notifyDaysList.contains(d),
            onSelected: (_) => notifier.toggleNotifyDay(d),
            selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
            checkmarkColor: AppTheme.primaryGreen,
          )).toList(),
        ),
      ],
    );
  }

  void _showImageSourceSheet(AddItemNotifier notifier) {
    showModalBottomSheet(context: context, builder: (_) => SafeArea(child: Wrap(children: [
      ListTile(leading: const Icon(Icons.photo_library), title: const Text('Gallery'), onTap: () { Navigator.pop(context); notifier.pickImage(ImageSource.gallery); }),
      ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Camera'), onTap: () { Navigator.pop(context); notifier.pickImage(ImageSource.camera); }),
    ])));
  }

  void _showCategoryPicker(BuildContext context, AddItemNotifier notifier) {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => CategorySelector(onSelected: (c) {
      notifier.updateCategory(c);
      Navigator.pop(context);
    }));
  }

  void _showLocationPicker(BuildContext context, AddItemNotifier notifier) {
    showModalBottomSheet(context: context, isScrollControlled: true, useSafeArea: true, builder: (_) => LocationSelector(onSelected: (l) {
      notifier.updateLocation(l);
      Navigator.pop(context);
    }));
  }

  Widget _buildSection({required List<Widget> children, bool isAdvanced = false}) {
    final l10n = AppLocalizations.of(context)!;
    if (isAdvanced) {
      return Container(
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent), child: ExpansionTile(
          title: Text(l10n.advancedDetails, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          subtitle: Text(l10n.advancedSubtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: children,
        )),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildTab(String text, bool active, VoidCallback onTap) {
    return Expanded(child: GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8), alignment: Alignment.center,
      decoration: BoxDecoration(color: active ? AppTheme.primaryGreen.withOpacity(0.1) : Colors.grey[100], borderRadius: BorderRadius.circular(8), border: active ? Border.all(color: AppTheme.primaryGreen) : null),
      child: Text(text, style: TextStyle(color: active ? AppTheme.primaryGreen : Colors.grey[600], fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
    )));
  }

  Widget _buildDateRow({required String label, required DateTime? value, required VoidCallback onTap}) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [
      const Icon(Icons.calendar_today_outlined, color: Colors.grey), const SizedBox(width: 12),
      Text(label), const Spacer(),
      Text(value == null ? l10n.pickDate : DateFormat('yyyy-MM-dd').format(value), style: TextStyle(fontWeight: value == null ? FontWeight.normal : FontWeight.bold, color: value == null ? Colors.grey : AppTheme.primaryGreen)),
      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
    ])));
  }

  Widget _buildSelectorRow({required String label, required String value, required IconData icon, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Row(children: [
      Icon(icon, color: Colors.grey), const SizedBox(width: 12),
      Text(label), const Spacer(),
      Text(LocalizedUtils.getLocalizedName(context, value), style: const TextStyle(fontWeight: FontWeight.bold)),
      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
    ])));
  }

  Widget _buildQuantityRow(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    return Row(children: [
      const Icon(Icons.shopping_bag_outlined, color: Colors.grey), const SizedBox(width: 12),
      Expanded(child: TextFormField(controller: _quantityController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l10n.quantity, border: InputBorder.none))),
      DropdownButton<String>(value: state.unit, underline: const SizedBox(), items: ['pcs', 'kg', 'g', 'L', 'ml', 'pack', 'box'].map((u) => DropdownMenuItem(value: u, child: Text(_getUnitDisplayName(u)))).toList(), onChanged: (v) => notifier.updateUnit(v!)),
    ]);
  }

  Widget _buildPurchaseDateRow(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    return _buildDateRow(label: l10n.purchaseDate, value: state.purchaseDate, onTap: () async {
      final d = await showDatePicker(context: context, initialDate: state.purchaseDate, firstDate: DateTime(2020), lastDate: DateTime.now());
      if (d != null) notifier.updatePurchaseDate(d);
    });
  }

  Widget _buildPriceInput(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n, String currency) {
    return Row(children: [
      const Icon(Icons.attach_money, color: Colors.grey), const SizedBox(width: 12),
      Expanded(child: TextFormField(controller: _priceController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l10n.price, border: InputBorder.none, prefixText: currency))),
    ]);
  }

  Widget _buildBottomButtons(AddItemState state, AddItemNotifier notifier, AppLocalizations l10n) {
    final isEditing = widget.itemToEdit != null;
    return Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]), child: SafeArea(child: Row(children: [
      if (!isEditing) Expanded(child: OutlinedButton(onPressed: () async {
        // Sync before save
        notifier.updateName(_nameController.text);
        notifier.updateQuantity(_quantityController.text);
        notifier.updatePrice(_priceController.text);
        notifier.updateShelfLife(_shelfLifeController.text);
        
        if (_formKey.currentState!.validate()) {
           if (await notifier.save(addNext: true)) {
             HapticFeedback.mediumImpact();
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.saveAndNext)));
             // Clear controllers
             _nameController.clear();
             _priceController.clear();
             _shelfLifeController.clear();
             _quantityController.text = '1';
           }
        }
      }, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: AppTheme.primaryGreen), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(l10n.saveAndNext, style: const TextStyle(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)))),
      if (!isEditing) const SizedBox(width: 12),
      Expanded(child: FilledButton(onPressed: () async {
        // Sync before save
        notifier.updateName(_nameController.text);
        notifier.updateQuantity(_quantityController.text);
        notifier.updatePrice(_priceController.text);
        notifier.updateShelfLife(_shelfLifeController.text);

        if (_formKey.currentState!.validate()) {
           if (await notifier.save(itemToEdit: widget.itemToEdit)) context.pop();
        }
      }, style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: AppTheme.primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(isEditing ? l10n.updateItem : l10n.save, style: const TextStyle(fontWeight: FontWeight.bold)))),
    ])));
  }
}