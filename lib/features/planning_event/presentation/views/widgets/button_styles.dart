import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class ButtonStyles {
  
  static ButtonStyle categoryButtonStyle
  (bool isPressed) {
    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return isPressed ? Colors.white : Styles.mainColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        return isPressed ? Styles.mainColor : Colors.transparent;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        return BorderSide(color: Styles.mainColor, width: 2);
      }),
    );
  }
}
