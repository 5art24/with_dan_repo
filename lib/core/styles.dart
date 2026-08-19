import 'package:flutter/material.dart';

abstract class Styles {
  static const Color primary = Color(0xFF7B61FF);
  static const Color primaryDark = Color(0xFF6B4EFF);
  static const Color primaryLight = Color(0xFFA0C4FF);

  // الخلفيات
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF0F0F5);

  // النصوص
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // الحالات
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF2196F3);

  // ألوان الكروت الملونة
  static const Color cardPink = Color(0xFFF8D7DA);
  static const Color cardPurple = Color(0xFFE8D5F2);
  static const Color cardBlue = Color(0xFFD4E6F1);
  static const Color cardGreen = Color(0xFFD5F5E3);
  static const Color cardYellow = Color(0xFFFCF3CF);
  static const Color cardOrange = Color(0xFFFFE0B2);

  // Map للألوان (للتوافق مع الكود القديم)
  static const Map<String, Color> colors = {
    'blushPink': cardPink,
    'lightPurple': cardPurple,
    'lightBlue': cardBlue,
    'lightGreen': cardGreen,
    'lightYellow': cardYellow,
    'lightOrange': cardOrange,
  };

  // التدرجات
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7B61FF), Color(0xFFB8A9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════
  // أنماط النصوص
  // ═══════════════════════════════════════════
  static const mainColor = primary;
  static const largeTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  static const mediumTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );
  static const smallTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const body = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

  static const labels = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

extension StringExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;

    return split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}