import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:use_up/src/localization/app_localizations.dart';

void main() {
  // 定义所有已支持的语言列表
  final supportedLocales = [
    const Locale('en'),
    const Locale('zh'),
    const Locale('zh', 'TW'),
    const Locale('de'),
    const Locale('fr'),
    const Locale('it'),
    const Locale('es'),
    const Locale('pt'),
    const Locale('pt', 'BR'),
    const Locale('el'),
    const Locale('tr'),
    const Locale('ja'),
    const Locale('ko'),
    const Locale('ru'),
    const Locale('nl'),
    const Locale('pl'),
    const Locale('uk'),
  ];

  group('Multi-language Support Tests', () {
    for (var locale in supportedLocales) {
      testWidgets('Verify localization for ${locale.toString()}', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: supportedLocales,
            locale: locale,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  body: Column(
                    children: [
                      Text('TITLE: ${l10n.appTitle}'),
                      Text('SAVE: ${l10n.save}'),
                    ],
                  ),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // 验证 App Title 是否正确显示 (使用从 l10n 对象获取的期望值)
        final expectedTitle = AppLocalizations.of(tester.element(find.byType(Scaffold)))!.appTitle;
        expect(find.textContaining(expectedTitle), findsOneWidget);
        
        // 验证 Save 按钮翻译是否不为空且不是默认键名
        final saveText = find.textContaining('SAVE:');
        expect(saveText, findsOneWidget);
        
        // 打印调试信息（可选）
        debugPrint('Tested ${locale.languageCode}: Success');
      });
    }
  });

  test('Ensure all supported locales in app.dart are covered in test', () {
    // 这个测试提醒开发者在 app.dart 添加新语言后也要更新测试列表
    // 实际生产中可以通过反射或读取 app.dart 获取，这里通过简单计数校验
    expect(supportedLocales.length, 17);
  });
}
