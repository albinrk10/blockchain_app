import 'dart:convert';
import 'dart:io';

import 'package:example2/app/domain/failures/http_request_failure.dart';
import 'package:example2/app/domain/models/crypto/crypto.dart';
import 'package:example2/app/domain/results/get_prices/get_prices_result.dart';
import 'package:http/http.dart';

class ExchangeAPI {
  final Client _client;

  ExchangeAPI(this._client);

  Future<GetPricesResult> getPrices(List<String> ids) async {
    try {
      final response = await _client.get(
        Uri.parse(
          'https://api.coincap.io/v2/assets?ids=${ids.join(',')}',
        ),
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final crypto = (json['data'] as List).map(
          (e) => Crypto(
              id: e['id'],
              symbol: e['symbol'],
              price: double.parse(e['priceUsd'])),
        );
        return GetPricesSuccess(crypto.toList());
      }
      if (response.statusCode == 404) {
        throw HttpRequestFailure.notFound;
      }
      if (response.statusCode >= 500) {
        throw HttpRequestFailure.server;
      }
      throw HttpRequestFailure.local;
    } catch (e) {
      late HttpRequestFailure failure;
      if (e is HttpRequestFailure) {
        failure = e;
      } else if (e is SocketException || e is ClientException) {
        failure = HttpRequestFailure.network;
      } else {
        failure = HttpRequestFailure.local;
      }
      return GetPricesFailure(failure);
    }
  }
}
