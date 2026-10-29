import 'package:flutter/foundation.dart';

@immutable
class Crypto {
  final String id;
  final String symbol;
  final String name;
  final double price;
  final double changePercent24Hr;
  final DateTime? lastUpdated;

  const Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.price,
    required this.changePercent24Hr,
    this.lastUpdated,
  });

  Crypto copyWith({
    String? id,
    String? symbol,
    String? name,
    double? price,
    double? changePercent24Hr,
    DateTime? lastUpdated,
  }) {
    return Crypto(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      changePercent24Hr: changePercent24Hr ?? this.changePercent24Hr,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Crypto &&
        other.id == id &&
        other.symbol == symbol &&
        other.name == name &&
        other.price == price &&
        other.changePercent24Hr == changePercent24Hr;
  }

  @override
  int get hashCode {
    return Object.hash(id, symbol, name, price, changePercent24Hr);
  }

  @override
  String toString() {
    return 'Crypto(id: $id, symbol: $symbol, name: $name, price: $price, changePercent24Hr: $changePercent24Hr)';
  }
}
