import 'package:flutter/material.dart';

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
      onPressed: isEnabled ? onPressed : null,
      // onPressed: () {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Added to cart!')),
      //   );
      // },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Add',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}