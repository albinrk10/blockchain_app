import 'package:blockchain_app/core/utils/formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Formatters', () {
    test('formatPrice formats standard prices with 2 decimal places', () {
      expect(Formatters.formatPrice(64250.75), r'$64,250.75');
      expect(Formatters.formatPrice(1.00), r'$1.00');
    });

    test('formatPrice formats small prices between 0.001 and 1.0 with 4 decimal places', () {
      expect(Formatters.formatPrice(0.0845), r'$0.0845');
    });

    test('formatPrice formats micro prices below 0.001 with 6 decimal places', () {
      expect(Formatters.formatPrice(0.000256), r'$0.000256');
    });

    test('formatPercentChange adds plus sign to positive percentages', () {
      expect(Formatters.formatPercentChange(5.234), '+5.23%');
      expect(Formatters.formatPercentChange(0.0), '+0.00%');
    });

    test('formatPercentChange formats negative percentages properly', () {
      expect(Formatters.formatPercentChange(-3.456), '-3.46%');
    });
  });
}
