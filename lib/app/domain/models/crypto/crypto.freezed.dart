// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crypto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Crypto {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CryptoCopyWith<Crypto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptoCopyWith<$Res> {
  factory $CryptoCopyWith(Crypto value, $Res Function(Crypto) then) =
      _$CryptoCopyWithImpl<$Res, Crypto>;
  @useResult
  $Res call({String id, String symbol, double price});
}

/// @nodoc
class _$CryptoCopyWithImpl<$Res, $Val extends Crypto>
    implements $CryptoCopyWith<$Res> {
  _$CryptoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CryptoImplCopyWith<$Res> implements $CryptoCopyWith<$Res> {
  factory _$$CryptoImplCopyWith(
          _$CryptoImpl value, $Res Function(_$CryptoImpl) then) =
      __$$CryptoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String symbol, double price});
}

/// @nodoc
class __$$CryptoImplCopyWithImpl<$Res>
    extends _$CryptoCopyWithImpl<$Res, _$CryptoImpl>
    implements _$$CryptoImplCopyWith<$Res> {
  __$$CryptoImplCopyWithImpl(
      _$CryptoImpl _value, $Res Function(_$CryptoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? symbol = null,
    Object? price = null,
  }) {
    return _then(_$CryptoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CryptoImpl implements _Crypto {
  const _$CryptoImpl(
      {required this.id, required this.symbol, required this.price});

  @override
  final String id;
  @override
  final String symbol;
  @override
  final double price;

  @override
  String toString() {
    return 'Crypto(id: $id, symbol: $symbol, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CryptoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.price, price) || other.price == price));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, symbol, price);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CryptoImplCopyWith<_$CryptoImpl> get copyWith =>
      __$$CryptoImplCopyWithImpl<_$CryptoImpl>(this, _$identity);
}

abstract class _Crypto implements Crypto {
  const factory _Crypto(
      {required final String id,
      required final String symbol,
      required final double price}) = _$CryptoImpl;

  @override
  String get id;
  @override
  String get symbol;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  _$$CryptoImplCopyWith<_$CryptoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
