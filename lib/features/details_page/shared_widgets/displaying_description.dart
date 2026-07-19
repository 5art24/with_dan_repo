
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DisplayingDescription extends StatelessWidget {
  const DisplayingDescription({
    super.key,
    required this.description,
    required this.primaryColor,
  });

  final String? description;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ReadMoreText(
        description ?? '',
        trimLines: 3, // عدد الأسطر التي تظهر قبل القص
        colorClickableText: primaryColor,
        trimMode: TrimMode.Line,
        trimCollapsedText: ' Read more...',
        trimExpandedText: ' Show less',
        style: TextStyle(
          color: Colors.grey[600],
          height: 1.5,
          fontSize: 14,
        ),
        moreStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        lessStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}