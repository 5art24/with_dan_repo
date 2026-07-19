import 'package:flutter/material.dart';
import 'package:project1_collage/features/details_page/shared_widgets/back_and_favorite_button.dart';

class UnsupportedImages extends StatelessWidget {
  const UnsupportedImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          height: 320, // يمكنكِ تغيير الارتفاع حسب التصميم لديكِ
          width: double.infinity,
          color: Colors.grey.shade400,
          child: Center(
            child: const Icon(
              Icons.image_not_supported,
              size: 60,
              color: Colors.grey,
            ),
          ),
        ),
        BackAndFavoriteButton(),
      ],
    );
  }
}
