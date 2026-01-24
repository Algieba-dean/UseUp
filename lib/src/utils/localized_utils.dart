import 'package:flutter/material.dart';
import 'package:use_up/src/localization/app_localizations.dart';

class LocalizedUtils {
  static String getLocalizedName(BuildContext context, String originalName) {
    final l10n = AppLocalizations.of(context)!;
    
    // 映射表：数据库存的英文 -> 对应的翻译 Getter
    // 同时也兼容旧数据可能存的中文
    
    switch (originalName) {
      case 'Other': return l10n.valOther;
      case '其他': return l10n.valOther;
      
      case 'Misc': return l10n.valMisc;
      case '杂物': return l10n.valMisc;
      
      case 'Kitchen': return l10n.valKitchen;
      case '厨房': return l10n.valKitchen;
      
      case 'Fridge': return l10n.valFridge;
      case '冰箱': return l10n.valFridge;
      
      case 'Pantry': return l10n.valPantry;
      case '橱柜': return l10n.valPantry;
      
      case 'Bathroom': return l10n.valBathroom;
      case '浴室': return l10n.valBathroom;
      
      case 'Food': return l10n.valFood;
      case '食品': return l10n.valFood;
      
      case 'Vegetable': return l10n.catVegetable;
      case '蔬菜': return l10n.catVegetable;
      
      case 'Fruit': return l10n.catFruit;
      case '水果': return l10n.catFruit;

      case 'Meat': return l10n.catMeat;
      case '肉类': return l10n.catMeat;
      
      case 'Dairy': return l10n.catDairy;
      case '奶制品': return l10n.catDairy;

      case 'Snack': return l10n.catSnack;
      case '零食': return l10n.catSnack;

      case 'Health': return l10n.catHealth;
      case '药品/保健': return l10n.catHealth;

      case 'Utility': return l10n.catUtility; 
      case '日用品': return l10n.catUtility;
      
      case 'Battery': return l10n.valBattery;
      case '电池': return l10n.valBattery;
      
      default: return originalName; // 没命中则显示原名
    }
  }

  static String getLocalizedUnit(BuildContext context, String originalUnit) {
    final l10n = AppLocalizations.of(context)!;
    
    switch (originalUnit.toLowerCase()) {
      case 'pcs': return l10n.unitPcs;
      case '个': return l10n.unitPcs;
      
      case 'kg': return l10n.unitKg;
      case '千克': return l10n.unitKg;
      
      case 'g': return l10n.unitG;
      case '克': return l10n.unitG;
      
      case 'l': return l10n.unitL;
      case '升': return l10n.unitL;
      
      case 'ml': return l10n.unitMl;
      case '毫升': return l10n.unitMl;
      
      case 'pack': return l10n.unitPack;
      case '包': return l10n.unitPack;
      
      case 'box': return l10n.unitBox;
      case '盒': return l10n.unitBox;
      
      case 'bag': return l10n.unitBag;
      case '袋': return l10n.unitBag;
      
      case 'bottle': return l10n.unitBottle;
      case '瓶': return l10n.unitBottle;
      
      default: return originalUnit;
    }
  }

  static IconData getCategoryIcon(String categoryName) {
    if (categoryName.contains('Vegetable') || categoryName.contains('蔬菜')) {
      return Icons.grass;
    } else if (categoryName.contains('Fruit') || categoryName.contains('水果')) {
      return Icons.apple;
    } else if (categoryName.contains('Meat') || categoryName.contains('肉')) {
      return Icons.kebab_dining;
    } else if (categoryName.contains('Dairy') || categoryName.contains('奶')) {
      return Icons.water_drop;
    } else if (categoryName.contains('Health') || categoryName.contains('药') || categoryName.contains('健康')) {
      return Icons.medical_services;
    } else if (categoryName.contains('Utility') || categoryName.contains('工具') || categoryName.contains('日用')) {
      return Icons.build;
    } else if (categoryName.contains('Food') || categoryName.contains('食品')) {
      return Icons.restaurant; 
    } else {
      return Icons.inventory_2_outlined;
    }
  }
}
