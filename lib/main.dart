import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'domain/repositories/crypto_repository.dart';
import 'domain/repositories/crypto_ws_repository.dart';
import 'domain/usecases/get_crypto_prices_usecase.dart';
import 'domain/usecases/watch_crypto_prices_usecase.dart';
import 'domain/usecases/watch_ws_status_usecase.dart';
import 'infrastructure/datasources/remote/crypto_rest_data_source.dart';
import 'infrastructure/datasources/websocket/crypto_ws_data_source.dart';
import 'infrastructure/repositories/crypto_repository_impl.dart';
import 'infrastructure/repositories/crypto_ws_repository_impl.dart';
import 'presentation/controllers/home_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'en_US';

  final httpClient = http.Client();
  final restDataSource = CryptoRestDataSourceImpl(httpClient);
  final wsDataSource = CryptoWsDataSourceImpl();

  final cryptoRepository = CryptoRepositoryImpl(restDataSource);
  final cryptoWsRepository = CryptoWsRepositoryImpl(wsDataSource);

  final getCryptoPricesUseCase = GetCryptoPricesUseCase(cryptoRepository);
  final watchCryptoPricesUseCase = WatchCryptoPricesUseCase(cryptoWsRepository);
  final watchWsStatusUseCase = WatchWsStatusUseCase(cryptoWsRepository);

  runApp(
    MultiProvider(
      providers: [
        Provider<CryptoRepository>.value(value: cryptoRepository),
        Provider<CryptoWsRepository>.value(value: cryptoWsRepository),
        Provider<GetCryptoPricesUseCase>.value(value: getCryptoPricesUseCase),
        Provider<WatchCryptoPricesUseCase>.value(value: watchCryptoPricesUseCase),
        Provider<WatchWsStatusUseCase>.value(value: watchWsStatusUseCase),
        ChangeNotifierProvider<HomeNotifier>(
          create: (_) => HomeNotifier(
            getCryptoPricesUseCase: getCryptoPricesUseCase,
            watchCryptoPricesUseCase: watchCryptoPricesUseCase,
            watchWsStatusUseCase: watchWsStatusUseCase,
          )..init(),
        ),
      ],
      child: const CryptoPulseApp(),
    ),
  );
}
