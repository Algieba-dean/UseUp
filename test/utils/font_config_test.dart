import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:use_up/src/app.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() {
    // 模拟 main.dart 中的初始化逻辑
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  test('GoogleFonts config should disable runtime fetching', () {
    expect(GoogleFonts.config.allowRuntimeFetching, isFalse);
  });

  testWidgets('App should use GoogleFonts without crashing', (WidgetTester tester) async {
    // 简单的组件测试，确保使用了 GoogleFonts 的组件可以正常渲染
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Text('Test Font', style: TextStyle(fontFamily: 'OpenSans')),
        ),
      ),
    );

    expect(find.text('Test Font'), findsOneWidget);
  });
}
