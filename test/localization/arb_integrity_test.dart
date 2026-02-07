import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;

void main() {
  group('ARB Translation Integrity Tests', () {
    final l10nDir = Directory('lib/l10n');
    
    // 获取基准文件 (英语)
    final enFile = File(path.join(l10nDir.path, 'app_en.arb'));
    final Map<String, dynamic> enData = jsonDecode(enFile.readAsStringSync());
    
    // 提取所有翻译键 (排除 @@locale 等元数据)
    final enKeys = enData.keys.where((k) => !k.startsWith('@')).toSet();

    // 获取目录下所有其他 arb 文件
    final arbFiles = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb'));

    for (final file in arbFiles) {
      final fileName = path.basename(file.path);
      
      test('Check if $fileName has all keys from English', () {
        final Map<String, dynamic> currentData = jsonDecode(file.readAsStringSync());
        final currentKeys = currentData.keys.where((k) => !k.startsWith('@')).toSet();

        // 检查缺失的键
        final missingKeys = enKeys.difference(currentKeys);
        
        expect(missingKeys, isEmpty, 
          reason: '$fileName is missing the following keys: ${missingKeys.join(', ')}');
        
        // 可选：检查多余的键 (防止翻译中出现了英语里没有的垃圾数据)
        final extraKeys = currentKeys.difference(enKeys);
        expect(extraKeys, isEmpty, 
          reason: '$fileName has extra keys not found in English: ${extraKeys.join(', ')}');
      });
    }
  });
}
