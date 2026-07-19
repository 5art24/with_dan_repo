import 'package:flutter/material.dart';

class BackAndFavoriteButton extends StatelessWidget {
  const BackAndFavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.maybePop(context),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {},
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.share_outlined,
              //     color: Colors.white,
              //     size: 28,
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
