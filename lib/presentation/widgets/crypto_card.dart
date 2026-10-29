import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/crypto.dart';
import '../controllers/home_state.dart';

class CryptoCard extends StatelessWidget {
  final Crypto crypto;
  final PriceTrend trend;

  const CryptoCard({
    super.key,
    required this.crypto,
    this.trend = PriceTrend.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final brandColor = AppColors.getCryptoColor(crypto.symbol);
    final isBullish = crypto.changePercent24Hr >= 0;
    final changeColor = isBullish ? AppColors.bullish : AppColors.bearish;

    // Flash background color when real-time price updates
    final flashBackgroundColor = switch (trend) {
      PriceTrend.up => AppColors.bullish.withValues(alpha: 0.18),
      PriceTrend.down => AppColors.bearish.withValues(alpha: 0.18),
      PriceTrend.neutral => isDark ? AppColors.darkSurface : AppColors.lightSurface,
    };

    final borderColor = switch (trend) {
      PriceTrend.up => AppColors.bullish.withValues(alpha: 0.4),
      PriceTrend.down => AppColors.bearish.withValues(alpha: 0.4),
      PriceTrend.neutral => isDark ? AppColors.darkBorder : AppColors.lightBorder,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: flashBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          if (trend != PriceTrend.neutral)
            BoxShadow(
              color: (trend == PriceTrend.up ? AppColors.bullish : AppColors.bearish)
                  .withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        children: [
          // Icon with brand tint
          Container(
            width: 46,
            height: 46,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: brandColor.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: SvgPicture.asset(
              'assets/icons/${crypto.symbol}.svg',
              colorFilter: ColorFilter.mode(brandColor, BlendMode.srcIn),
              placeholderBuilder: (_) => Center(
                child: Text(
                  crypto.symbol.isNotEmpty ? crypto.symbol[0] : '?',
                  style: TextStyle(
                    color: brandColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and Symbol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  crypto.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                        .withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    crypto.symbol,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Price & 24h change chip
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: trend == PriceTrend.up
                      ? AppColors.bullish
                      : trend == PriceTrend.down
                          ? AppColors.bearish
                          : (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight),
                ),
                child: Text(
                  Formatters.formatPrice(crypto.price),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isBullish
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 16,
                      color: changeColor,
                    ),
                    Text(
                      Formatters.formatPercentChange(crypto.changePercent24Hr),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
