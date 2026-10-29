import 'package:blockchain_app/core/failures/failure.dart';
import 'package:blockchain_app/domain/entities/crypto.dart';
import 'package:blockchain_app/domain/entities/ws_status.dart';
import 'package:blockchain_app/presentation/controllers/home_notifier.dart';
import 'package:blockchain_app/presentation/controllers/home_state.dart';
import 'package:blockchain_app/presentation/views/home_view.dart';
import 'package:blockchain_app/presentation/widgets/crypto_card.dart';
import 'package:blockchain_app/presentation/widgets/crypto_error_view.dart';
import 'package:blockchain_app/presentation/widgets/crypto_skeleton.dart';
import 'package:blockchain_app/presentation/widgets/ws_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockHomeNotifier extends Mock implements HomeNotifier {}

void main() {
  late MockHomeNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockHomeNotifier();
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: ChangeNotifierProvider<HomeNotifier>.value(
        value: mockNotifier,
        child: const HomeView(),
      ),
    );
  }

  const testCryptos = [
    Crypto(
      id: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      price: 65000.0,
      changePercent24Hr: 2.5,
    ),
    Crypto(
      id: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      price: 3500.0,
      changePercent24Hr: -1.2,
    ),
  ];

  group('HomeView Widget Tests', () {
    testWidgets('renders skeleton loader when loading', (tester) async {
      when(() => mockNotifier.state).thenReturn(const HomeState.loading());

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CryptoSkeletonLoader), findsOneWidget);
    });

    testWidgets('renders error view on failure', (tester) async {
      when(() => mockNotifier.state).thenReturn(
        const HomeState.failure(NetworkFailure('Sin internet')),
      );

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CryptoErrorView), findsOneWidget);
      expect(find.text('Sin conexión a internet'), findsOneWidget);
    });

    testWidgets('renders list of crypto cards when loaded', (tester) async {
      when(() => mockNotifier.state).thenReturn(
        const HomeState.loaded(
          cryptos: testCryptos,
          wsStatus: WsStatus.connected(),
        ),
      );

      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(CryptoCard), findsNWidgets(2));
      expect(find.text('Bitcoin'), findsOneWidget);
      expect(find.text('Ethereum'), findsOneWidget);
      expect(find.byType(WsStatusBadge), findsOneWidget);
      expect(find.text('En vivo'), findsOneWidget);
    });
  });
}
