import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:use_up/src/services/notification_service.dart';
import 'package:use_up/src/config/app_config.dart';
import 'package:use_up/src/localization/app_localizations.dart'; 
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/locale_provider.dart';
import '../inventory/category_selector.dart';
import '../inventory/location_selector.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final providerLocale = ref.watch(localeProvider);
    
    // 如果 provider 为空（跟随系统），则获取当前上下文的 locale
    final effectiveLocale = providerLocale ?? Localizations.localeOf(context);
    
    final currentLanguageText = _getLanguageName(effectiveLocale);

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
                                            body: const CategorySelector(
                                              isManageMode: true,
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
                                            body: const LocationSelector(
                                              isManageMode: true,
                                            ),
                                          ),
                                        ),
                                      );
                                    },                            ),
                          ),
                        
                        const SizedBox(height: 24),

                        // 5. 隐私政策
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: const Icon(Icons.privacy_tip_outlined, color: AppTheme.primaryGreen),
                            title: Text(l10n.privacyPolicy),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            onTap: () async {
                              final Uri url = Uri.parse(AppConstants.privacyPolicyUrl);
                              try {
                                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not launch ${AppConstants.privacyPolicyUrl}')),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error launching URL: $e')),
                                  );
                                }
                              }
                            },
                          ),
                        ),

                        // 6. Feedback & Rating
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: const Icon(Icons.thumb_up_alt_outlined, color: AppTheme.primaryGreen),
                            title: Text(l10n.feedbackTitle),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            onTap: () => _showFeedbackDialog(context),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // --- Developer Debug Section ---
                        if (AppConfig.showDeveloperOptions) 
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Developer Options", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 8),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.notifications_active),
                                  label: const Text("Test Group Notifications (Now)"),
                                  onPressed: () async {
                                    await NotificationService().debugShowGroupedNotifications();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sent 3 notifications! Check status bar.")));
                                    }
                                  },
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.schedule),
                                  label: const Text("Check Pending Notifications (Log)"),
                                  onPressed: () async {
                                    await NotificationService().debugCheckPendingNotifications();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Check logs for pending requests.")));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                         const SizedBox(height: 40),
                        ],
                      ),
                    );
                  }
  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en': return 'English';
      case 'zh': return '简体中文';
      // Future languages can be added here, or fall back to languageCode
      default: return locale.languageCode;
    }
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
            children: AppLocalizations.supportedLocales.map((locale) {
              return ListTile(
                title: Text(_getLanguageName(locale)),
                trailing: ref.read(localeProvider)?.languageCode == locale.languageCode
                    ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                    : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(locale);
                  context.pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.feedbackDialogTitle),
        content: Text(l10n.feedbackDialogContent),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _sendEmailFeedback(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: Text(l10n.feedbackActionImprove),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openStoreListing(context);
            },
            child: Text(l10n.feedbackActionLove),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmailFeedback(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      query: 'subject=UseUp Feedback',
    );
    try {
      if (!await launchUrl(emailLaunchUri)) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not launch email app')));
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _openStoreListing(BuildContext context) async {
    final Uri url = Uri.parse(AppConstants.appStoreUrl);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open store')));
      }
    } catch (e) {
      // ignore
    }
  }
}