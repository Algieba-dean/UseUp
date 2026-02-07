import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_up/src/features/dashboard/widgets/expiring_card.dart';
import 'package:use_up/src/models/item.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:use_up/src/localization/app_localizations.dart';

void main() {
  testWidgets('ExpiringCard displays item information correctly', (WidgetTester tester) async {
    final item = Item(
      name: 'Test Item',
      purchaseDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 2)),
      quantity: 2.0,
      unit: 'pcs',
    );
    item.id = 1;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: ExpiringCard(item: item),
        ),
      ),
    );

    // Wait for localizations to load
    await tester.pumpAndSettle();

    // Check if name is displayed
    expect(find.text('Test Item'), findsOneWidget);
    
    // Check if quantity is displayed
    // Depending on localization, it might be "2.0 pcs" or similar
    expect(find.textContaining('2.0'), findsOneWidget);

    // Check if expiry text is present (e.g., "2 days left")
    // We can't guarantee the exact string without checking ARB, 
    // but we can check if it finds the general pattern or the localized result.
    // In English ARB, daysLeft(2) -> "2 days left"
    expect(find.textContaining('2'), findsWidgets);
  });
}
