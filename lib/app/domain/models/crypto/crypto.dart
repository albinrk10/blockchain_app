
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto.freezed.dart';

@freezed
class Crypto with _$Crypto {
  const factory Crypto({
    required String id,
    required String symbol,
    required double price,
  }) = _Crypto;
}





