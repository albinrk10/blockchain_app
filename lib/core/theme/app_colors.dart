import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand & Accents
  static const Color primary = Color(0xFF6366F1); // Indigo vibrant
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color secondary = Color(0xFF06B6D4); // Cyan accent

  // Market trends
  static const Color bullish = Color(0xFF10B981); // Emerald green
  static const Color bullishSoft = Color(0x1A10B981);
  static const Color bearish = Color(0xFFEF4444); // Crimson red
  static const Color bearishSoft = Color(0x1AEF4444);

  // Background & Surfaces (Dark Theme default for Crypto)
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color darkSurface = Color(0xFF161F30);
  static const Color darkSurfaceElevated = Color(0xFF1E293B);
  static const Color darkBorder = Color(0xFF334155);

  // Background & Surfaces (Light Theme)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightSurfaceElevated = Color(0xFFF1F5F9);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Status colors
  static const Color connected = Color(0xFF10B981);
  static const Color connecting = Color(0xFFF59E0B);
  static const Color disconnected = Color(0xFFEF4444);

  // Crypto Icon Palette
  static const Map<String, Color> cryptoBrandColors = {
    'BTC': Color(0xFFF7931A),
    'ETH': Color(0xFF627EEA),
    'USDT': Color(0xFF26A17B),
    'BNB': Color(0xFFF3BA2F),
    'USDC': Color(0xFF2775CA),
    'DOGE': Color(0xFFC2A633),
    'LTC': Color(0xFF345D9D),
    'XMR': Color(0xFFFF6600),
  };

  static Color getCryptoColor(String symbol) {
    return cryptoBrandColors[symbol.toUpperCase()] ?? primary;
  }
}
