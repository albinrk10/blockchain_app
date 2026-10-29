import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../controllers/home_notifier.dart';
import '../controllers/home_state.dart';
import '../widgets/crypto_card.dart';
import '../widgets/crypto_error_view.dart';
import '../widgets/crypto_search_bar.dart';
import '../widgets/crypto_skeleton.dart';
import '../widgets/ws_status_badge.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<HomeNotifier>();
    final state = notifier.state;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.currency_bitcoin_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            const Text(AppConstants.appTitle),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: switch (state) {
              HomeLoaded(:final wsStatus) => WsStatusBadge(
                  status: wsStatus,
                  onRetry: notifier.retryWebSocket,
                ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
      body: switch (state) {
        HomeInitial() || HomeLoading() => const Column(
            children: [
              SizedBox(height: 16),
              Expanded(child: CryptoSkeletonLoader()),
            ],
          ),
        HomeFailure(:final failure) => CryptoErrorView(
            failure: failure,
            onRetry: notifier.init,
          ),
        HomeLoaded(:final filteredCryptos, :final priceTrends) =>
          RefreshIndicator(
            onRefresh: notifier.refresh,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CryptoSearchBar(
                          onChanged: notifier.onSearchChanged,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mercado en vivo (${filteredCryptos.length})',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                            const Text(
                              'Actualización continua',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (filteredCryptos.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 56,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No se encontraron criptomonedas',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Intenta con otro nombre o símbolo',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final crypto = filteredCryptos[index];
                        final trend = priceTrends[crypto.id] ?? PriceTrend.neutral;
                        return CryptoCard(
                          key: ValueKey(crypto.id),
                          crypto: crypto,
                          trend: trend,
                        );
                      },
                      childCount: filteredCryptos.length,
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
          ),
      },
    );
  }
}
