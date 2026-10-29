import 'package:intl/intl.dart';

abstract final class Formatters {
  static final NumberFormat _standardCurrency = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  static final NumberFormat _smallCurrency = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 4,
  );

  static final NumberFormat _microCurrency = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 6,
  );

  /// Formats crypto price with dynamic decimal places according to value
  static String formatPrice(double price) {
    if (price >= 1.0) {
      return _standardCurrency.format(price);
    } else if (price >= 0.001) {
      return _smallCurrency.format(price);
    } else {
      return _microCurrency.format(price);
    }
  }

  /// Formats 24 hour percentage change with +/- sign
  static String formatPercentChange(double percent) {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }
}
