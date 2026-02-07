import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:use_up/src/utils/date_formatter.dart';

void main() {
  group('DateTextFormatter', () {
    late DateTextFormatter formatter;

    setUp(() {
      formatter = DateTextFormatter();
    });

    test('should format input correctly as YYYY-MM-DD', () {
      const oldValue = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      const newValue = TextEditingValue(
        text: '20230101',
        selection: TextSelection.collapsed(offset: 8),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '2023-01-01');
      expect(result.selection.baseOffset, 10);
    });

    test('should handle partial input', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '202301',
        selection: TextSelection.collapsed(offset: 6),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '2023-01');
      expect(result.selection.baseOffset, 7);
    });

    test('should ignore non-numeric characters', () {
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(
        text: '2023a01b01',
        selection: TextSelection.collapsed(offset: 10),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '2023-01-01');
    });

    test('should not exceed length limit', () {
      const oldValue = TextEditingValue(
          text: '2023-01-01', selection: TextSelection.collapsed(offset: 10));
      const newValue = TextEditingValue(
        text: '2023-01-012',
        selection: TextSelection.collapsed(offset: 11),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '2023-01-01'); // Should return old value
    });
    
    test('should allow deletion', () {
       const oldValue = TextEditingValue(
          text: '2023-01-01', selection: TextSelection.collapsed(offset: 10));
      const newValue = TextEditingValue(
        text: '2023-01-0',
        selection: TextSelection.collapsed(offset: 9),
      );
      
      final result = formatter.formatEditUpdate(oldValue, newValue);
      // Logic in formatter says: if selection decreases, return new value as is (allow delete)
      expect(result.text, '2023-01-0');
    });
  });
}
