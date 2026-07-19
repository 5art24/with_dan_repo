// lib/features/planning_event/presentation/views/widgets/custom_button.dart

import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/button_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.name,
    this.width,
    required this.isPressed,
    required this.onTap,
    this.icon, // إضافة الأيقونة هنا كمتغير اختياري
  });

  final String name;
  final bool isPressed;
  final Function() onTap;
  final double? width;
  final IconData? icon; // تحديد نوع المتغير

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0), // تعديل البادينج ليناسب الشريط الأفقي
      child: OutlinedButton(
        onPressed: onTap,
        style: ButtonStyles.categoryButtonStyle(isPressed),
        child: Container(
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min, // ليأخذ الزر حجم محتواه فقط
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16), // عرض الأيقونة إذا تم تمريرها
                const SizedBox(width: 6),
              ],
              Text(name),
            ],
          ),
        ),
      ),
    );
  }
}