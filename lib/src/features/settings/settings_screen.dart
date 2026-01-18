import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:use_up/src/localization/app_localizations.dart'; 
import '../../config/theme.dart';
import '../../providers/locale_provider.dart';
import '../inventory/category_selector.dart';
import '../inventory/location_selector.dart';
import '../../services/notification_service.dart'; 

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
          
          const SizedBox(height: 12), 

          // 2. 历史记录
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.history, color: AppTheme.primaryGreen),
              title: Text(l10n.history),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                context.push('/history');
              },
            ),
          ),
          
          const Divider(),

          // 3. 分类管理
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.category, color: AppTheme.primaryGreen),
              title: Text(l10n.manageCategories),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      appBar: AppBar(title: Text(l10n.manageCategories)),
                      body: CategorySelector(
                        isManageMode: true,
                        onSelected: (_) {},
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 4. 位置管理
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.kitchen, color: AppTheme.primaryGreen),
              title: Text(l10n.manageLocations),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      appBar: AppBar(title: Text(l10n.manageLocations)),
                      body: LocationSelector(
                        isManageMode: true,
                        onSelected: (_) {},
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          const Divider(),

          // 测试通知按钮
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.orange),
              title: Text(l10n.testNotification),
              subtitle: Text(l10n.testNotificationSubtitle),
              onTap: () async {
                await NotificationService().showInstantNotification();
              },
            ),
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