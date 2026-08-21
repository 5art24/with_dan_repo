import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class DetailsCustomButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;

  const DetailsCustomButton({
    super.key,
    this.isEnabled = true,
    this.onPressed,
    this.text = 'Book Service',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? Styles.mainColor : Colors.grey.shade300,
        foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        isEnabled ? 'Add' : 'Not Available',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
