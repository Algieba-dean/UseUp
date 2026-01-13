import 'package:flutter/services.dart';

class DateTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // 如果是删除操作，直接返回，避免卡顿
    if (newValue.selection.baseOffset < oldValue.selection.baseOffset) {
      return newValue;
    }

    // 限制长度 (yyyy-MM-dd = 10 chars)
    if (text.length > 10) return oldValue;

    // 简单暴力的实现方式：只保留数字，重新拼装
    var digitsOnly = text.replaceAll(RegExp(r'[^0-9]'), '');
    var finalString = "";
    
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 4) finalString += "-";
      if (i == 6) finalString += "-";
      finalString += digitsOnly[i];
    }

    return TextEditingValue(
      text: finalString,
      selection: TextSelection.collapsed(offset: finalString.length),
    );
  }
}
