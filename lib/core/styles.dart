import 'dart:math';

import 'package:flutter/material.dart';

abstract class Styles {
  static const Map<String, Color> colors = {
    'blushPink': const Color(0xFFF8CECF),
    'lightPurple': const Color(0xFFDBCEE8),
    'lightBlue': const Color(0xFFBCDFF5),
    'lightGreen': const Color(0xFFCEDDBE),
    'lightYellow': const Color(0xFFFDFDCC),
    'lightOrange': const Color(0xFFF7D9BF),
  };

  static const mainColor = Color.fromARGB(255, 151, 143, 226);
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
