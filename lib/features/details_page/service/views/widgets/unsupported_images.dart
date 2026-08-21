import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/features/details_page/shared_widgets/back_and_favorite_button.dart';

class UnsupportedImages extends StatelessWidget {
  const UnsupportedImages({super.key, this.service});
  
  final ServiceModel? service; // 👈 اختياري

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 320,
          width: double.infinity,
          color: Colors.grey.shade400,
          child: const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
        BackAndFavoriteButton(service: service),
      ],
    );
  }
}