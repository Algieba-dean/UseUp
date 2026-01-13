import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:use_up/src/localization/app_localizations.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'providers/locale_provider.dart';

class UseUpApp extends ConsumerWidget {
  const UseUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // 监听语言变化
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'UseUp',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,

      // 强制设置当前的语言，如果 currentLocale 是 null，则跟随系统
      locale: currentLocale, 
      
      // --- 本地化配置 ---
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('zh'), // Chinese
      ],
    );
  }
}
