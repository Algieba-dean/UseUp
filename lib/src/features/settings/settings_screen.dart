import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart'; 
import '../../config/theme.dart';
import '../../providers/locale_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    
    String currentLanguageText;
    if (currentLocale?.languageCode == 'zh') {
      currentLanguageText = '简体中文';
    } else {
      currentLanguageText = 'English';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // 保持背景灰白
      appBar: AppBar(
        title: Text(l10n.settingsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          
          // 1. 语言设置
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.language, color: AppTheme.primaryGreen),
              title: Text(l10n.language),
              subtitle: Text(currentLanguageText),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                _showLanguagePicker(context, ref);
              },
            ),
          ),
          
          const SizedBox(height: 12), // 分隔开一点，更有层次感

          // 2. 历史记录 (新增入口)
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.history, color: AppTheme.primaryGreen),
              title: Text(l10n.history), // 对应 "历史记录"
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // 点击跳转到历史页
                context.push('/history');
              },
            ),
          ),
          
          // 这里以后还可以加 "About", "Export Data" 等
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                trailing: ref.read(localeProvider)?.languageCode == 'en' 
                    ? const Icon(Icons.check, color: AppTheme.primaryGreen) 
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('en');
                  context.pop(); 
                },
              ),
              ListTile(
                title: const Text('简体中文'),
                trailing: ref.read(localeProvider)?.languageCode == 'zh' 
                    ? const Icon(Icons.check, color: AppTheme.primaryGreen) 
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('zh');
                  context.pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
