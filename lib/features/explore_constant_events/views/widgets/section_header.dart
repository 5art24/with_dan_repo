// lib/features/home/views/widgets/section_header.dart

import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;
  final bool seeAllExist;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onSeeAllTap, required this.seeAllExist,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Styles
              .largeTitle, 
        ),
        seeAllExist? TextButton(
          onPressed: onSeeAllTap,
          child: const Text(
            "See All",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ):const SizedBox(),
      ],
    );
  }
}
