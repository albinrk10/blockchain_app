import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/ws_status.dart';

class WsStatusBadge extends StatefulWidget {
  final WsStatus status;
  final VoidCallback? onRetry;

  const WsStatusBadge({
    super.key,
    required this.status,
    this.onRetry,
  });

  @override
  State<WsStatusBadge> createState() => _WsStatusBadgeState();
}

class _WsStatusBadgeState extends State<WsStatusBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (color, label, isAnimated) = switch (widget.status) {
      WsStatusConnected() => (AppColors.connected, 'En vivo', true),
      WsStatusConnecting() => (AppColors.connecting, 'Conectando...', true),
      WsStatusDisconnected() => (AppColors.disconnected, 'Desconectado', false),
      WsStatusFailed() => (AppColors.disconnected, 'Reconectar', false),
    };

    final isClickable = widget.status is WsStatusFailed || widget.status is WsStatusDisconnected;

    return InkWell(
      onTap: isClickable ? widget.onRetry : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAnimated)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: _pulseAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isClickable) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.refresh_rounded,
                size: 14,
                color: color,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
