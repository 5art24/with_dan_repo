import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class CustomShowError extends StatelessWidget {
  const CustomShowError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: Styles.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
