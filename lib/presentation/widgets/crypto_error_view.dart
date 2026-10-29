import 'package:flutter/material.dart';
import '../../core/failures/failure.dart';
import '../../core/theme/app_colors.dart';

class CryptoErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const CryptoErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, title, description) = switch (failure) {
      NetworkFailure() => (
          Icons.wifi_off_rounded,
          'Sin conexión a internet',
          'Comprueba tu conexión de red e inténtalo nuevamente.',
        ),
      ServerFailure(:final statusCode) => (
          Icons.cloud_off_rounded,
          'Servidor no disponible',
          'CoinCap retornó un código de error ($statusCode).',
        ),
      NotFoundFailure() => (
          Icons.search_off_rounded,
          'Activos no encontrados',
          'No pudimos recuperar las criptomonedas solicitadas.',
        ),
      _ => (
          Icons.error_outline_rounded,
          'Algo salió mal',
          failure.message,
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.bearishSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.bearish,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
