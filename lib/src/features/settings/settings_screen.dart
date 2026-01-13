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
    
    // 获取当前语言显示的文本
    String currentLanguageText;
    if (currentLocale?.languageCode == 'zh') {
      currentLanguageText = '简体中文';
    } else {
      currentLanguageText = 'English';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: AppTheme.neutralWhite,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: AppTheme.primaryGreen),
            title: Text(l10n.language),
            subtitle: Text(currentLanguageText), // 显示当前语言
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // 点击弹出底部选择框
              _showLanguagePicker(context, ref);
            },
          ),
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
                  context.pop(); // 关闭弹窗
                },
              ),
              ListTile(
                title: const Text('简体中文'),
                trailing: ref.read(localeProvider)?.languageCode == 'zh' 
                    ? const Icon(Icons.check, color: AppTheme.primaryGreen) 
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('zh');
                  context.pop(); // 关闭弹窗
                },
              ),
            ],
          ),
        );
      },
    );
  }
}