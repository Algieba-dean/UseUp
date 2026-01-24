import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:use_up/src/localization/app_localizations.dart'; 
import '../inventory/providers/inventory_provider.dart'; 
import 'providers/dashboard_filter_provider.dart';
import 'widgets/expiring_card.dart';
import '../../config/theme.dart';
import '../../utils/expiry_utils.dart';
import '../../models/item.dart';
import '../../models/category.dart';
import '../../models/location.dart';
import '../../utils/localized_utils.dart';
import '../inventory/category_selector.dart';
import '../inventory/location_selector.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isSearching = false; 
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(searchQuery: '');
    setState(() {
      _isSearching = false;
    });
  }

  void _showFilterSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final currentFilter = ref.read(dashboardFilterProvider);
            
            return Container(
              padding: const EdgeInsets.all(24),
              height: 400,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.filter, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                            searchQuery: currentFilter.searchQuery, 
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(l10n.reset),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  Text(l10n.category, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final Category? cat = await showModalBottomSheet<Category>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (c) => const CategorySelector(),
                      );
                      
                      if (cat != null) {
                        final old = ref.read(dashboardFilterProvider);
                        ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                          searchQuery: old.searchQuery,
                          locationId: old.locationId,
                          locationName: old.locationName,
                          categoryId: cat.id,
                          categoryName: cat.name,
                        );
                        Navigator.pop(ctx);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentFilter.categoryName == null 
                                ? l10n.categorySelect 
                                : LocalizedUtils.getLocalizedName(context, currentFilter.categoryName!), 
                            style: const TextStyle(fontSize: 16)
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(l10n.location, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                       final Location? loc = await showModalBottomSheet<Location>(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (c) => const LocationSelector(),
                      );
                      
                      if (loc != null) {
                        final old = ref.read(dashboardFilterProvider);
                        ref.read(dashboardFilterProvider.notifier).state = DashboardFilter(
                          searchQuery: old.searchQuery,
                          categoryId: old.categoryId,
                          categoryName: old.categoryName,
                          locationId: loc.id,
                          locationName: loc.name,
                        );
                        Navigator.pop(ctx);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentFilter.locationName == null 
                                ? l10n.locationSelect 
                                : LocalizedUtils.getLocalizedName(context, currentFilter.locationName!),
                            style: const TextStyle(fontSize: 16)
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inventoryAsync = ref.watch(inventoryProvider);
    final filterState = ref.watch(dashboardFilterProvider);
    final currentQuery = filterState.searchQuery;
    final hasActiveFilters = filterState.categoryId != null || filterState.locationId != null;

    return Scaffold(
      backgroundColor: AppTheme.neutralGrey,
      appBar: AppBar(
        backgroundColor: AppTheme.neutralGrey,
        elevation: 0,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                onChanged: (value) {
                  ref.read(dashboardFilterProvider.notifier).state = 
                      filterState.copyWith(searchQuery: value);
                },
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.eco, color: AppTheme.primaryGreen),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryGreen,
                        ),
                  ),
                ],
              ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
            
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.black),
                onPressed: _showFilterSheet,
              ),
              if (hasActiveFilters)
                Positioned(
                  right: 8, top: 8,
                  child: Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.alertOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
            
          if (!_isSearching)
            IconButton(
              onPressed: () => context.push('/settings'),
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
            ),
        ],
      ),
      
      body: Column(
        children: [
          if (hasActiveFilters)
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(l10n.filtersHeader, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(width: 8),
                    if (filterState.categoryName != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          label: Text(LocalizedUtils.getLocalizedName(context, filterState.categoryName!)),
                          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
                          labelStyle: const TextStyle(color: AppTheme.primaryGreen),
                          onDeleted: () {
                            ref.read(dashboardFilterProvider.notifier).state = 
                                ref.read(dashboardFilterProvider).clearCategory();
                          },
                        ),
                      ),
                    if (filterState.locationName != null)
                      InputChip(
                        label: Text(LocalizedUtils.getLocalizedName(context, filterState.locationName!)),
                        backgroundColor: AppTheme.softSage.withOpacity(0.3),
                        labelStyle: const TextStyle(color: Colors.black87),
                        onDeleted: () {
                          ref.read(dashboardFilterProvider.notifier).state = 
                              ref.read(dashboardFilterProvider).clearLocation();
                        },
                      ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: inventoryAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (items) {
                final isFiltered = currentQuery.isNotEmpty || hasActiveFilters;

                if (isFiltered) {
                   if (items.isEmpty) {
                      return Center(child: Text(
                        currentQuery.isNotEmpty 
                          ? l10n.noItemsFoundFor(currentQuery) 
                          : l10n.noItemsFound
                      ));
                   }
                   return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) => _buildItemTile(context, items[index]),
                   );
                }

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(l10n.noItemsFound, style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  );
                }

                final expiringItems = items.where((i) {
                  if (i.expiryDate == null) return false;
                  final days = ExpiryUtils.daysRemaining(i.expiryDate!);
                  return days <= 5; 
                }).toList();

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (expiringItems.isNotEmpty) ...[
                          Text(l10n.sectionExpiringSoon, style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: expiringItems.length,
                              itemBuilder: (context, index) {
                                return ExpiringCard(item: expiringItems[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        Text(l10n.sectionAllItems, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            return _buildItemTile(context, items[index]);
                          },
                        ),
                        const SizedBox(height: 80), 
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add'),
        backgroundColor: AppTheme.primaryGreen,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(l10n.addItem, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, Item item) {
    final days = item.expiryDate != null 
        ? ExpiryUtils.daysRemaining(item.expiryDate!) 
        : 999;
    
    return Card(
      child: ListTile(
        onTap: () => context.push('/item/${item.id}'),
        leading: Container(
          width: 50, 
          height: 50,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppTheme.softSage.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.imagePath != null
              ? Image.file(
                  File(item.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) => _getCategoryIcon(context, item.categoryName),
                )
              : _getCategoryIcon(context, item.categoryName),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${item.quantity} ${item.unit} • ${LocalizedUtils.getLocalizedName(context, item.locationName)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ExpiryUtils.getColorForExpiry(days).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            ExpiryUtils.getExpiryString(context, days),
            style: TextStyle(
              color: ExpiryUtils.getColorForExpiry(days),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(BuildContext context, String categoryName) {
    // 简单映射，也可以放进 LocalizedUtils 但这里是图标逻辑
    IconData icon;
    // 使用英文关键字匹配 (因为数据库存的是英文，但如果存的是中文，也可以匹配)
    // 更好的做法是依赖 LocalizedUtils 的英文回退或 ID，但这里暂时用字符串匹配
    
    if (categoryName.contains('Vegetable') || categoryName.contains('蔬菜')) {
      icon = Icons.grass;
    } else if (categoryName.contains('Fruit') || categoryName.contains('水果')) {
      icon = Icons.apple;
    } else if (categoryName.contains('Meat') || categoryName.contains('肉')) {
      icon = Icons.kebab_dining;
    } else if (categoryName.contains('Dairy') || categoryName.contains('奶')) {
      icon = Icons.water_drop;
    } else if (categoryName.contains('Health') || categoryName.contains('药') || categoryName.contains('健康')) {
      icon = Icons.medical_services;
    } else if (categoryName.contains('Utility') || categoryName.contains('工具') || categoryName.contains('日用')) {
      icon = Icons.build;
    } else if (categoryName.contains('Food') || categoryName.contains('食品')) {
      icon = Icons.restaurant; 
    } else {
      icon = Icons.inventory_2_outlined;
    }
    return Icon(icon, color: AppTheme.primaryGreen);
  }
}
