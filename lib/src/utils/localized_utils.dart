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
}
