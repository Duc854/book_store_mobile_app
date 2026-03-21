import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Theme Colors
  static const Color primary = Color(0xFF2C3E50); // Navy Dark
  static const Color secondary = Color(0xFFECF0F1); // Light Grey
  static const Color accent = Color(0xFF27AE60); // Emerald Green (Success)
  static const Color error = Color(0xFFE74C3C); // Alizarin Red (Danger)
  static const Color background = Color(0xFFECF0F1); // Nền sáng

  // Text & UI Colors
  static const Color textHeadline = Color(0xFF1A1A1A); // Deep Black-Grey
  static const Color textBody = Color(0xFF4A4A4A); // Dark Grey
  static const Color textHint = Color(0xFF8E8E93); // Light Grey
  static const Color price = Color(0xFFE67E22); // Orange
  static const Color onPrimary = Color(0xFFFFFFFF); // White
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
      ),

      // Sử dụng GoogleFonts để tự động lấy font Roboto
      textTheme: GoogleFonts.robotoTextTheme(
        const TextTheme(
          // Headline / Title: Tên sách, tiêu đề mục lớn
          displayLarge: TextStyle(
            color: AppColors.textHeadline,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          // Primary Body: Mô tả sách, tên tác giả
          bodyLarge: TextStyle(
            color: AppColors.textBody,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          // Secondary / Hint: Ngày tháng, text phụ
          bodySmall: TextStyle(color: AppColors.textHint, fontSize: 12),
          // Label dành cho Giá tiền (Sử dụng style riêng)
          labelLarge: TextStyle(
            color: AppColors.price,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Cấu hình Button đồng nhất toàn App
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
