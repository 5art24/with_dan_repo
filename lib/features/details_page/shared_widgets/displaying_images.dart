import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/features/details_page/shared_widgets/back_and_favorite_button.dart';
import 'package:project1_collage/features/details_page/shared_widgets/dots_indicator.dart';

class DisplayingImages extends StatefulWidget {
  const DisplayingImages({
    super.key,
    required PageController pageController,
    this.service, // 👈 اختياري
    required this.primaryColor,
    required this.imageUrls,
  }) : _pageController = pageController;

  final PageController _pageController;
  final List<String>? imageUrls;
  final Color primaryColor;
  final ServiceModel? service; // 👈 اختياري

  @override
  State<DisplayingImages> createState() => _DisplayingImagesState();
}

class _DisplayingImagesState extends State<DisplayingImages> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: widget._pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.imageUrls?.length ?? 0,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls?[index] ?? "",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              );
            },
          ),
        ),
        IgnorePointer(
          child: Container(height: 320, color: Colors.black.withOpacity(0.2)),
        ),
        BackAndFavoriteButton(service: widget.service),
        widget.imageUrls != null
            ? DotsIndicator(
                pageController: widget._pageController,
                currentPage: _currentPage,
                Images: widget.imageUrls!,
                primaryColor: widget.primaryColor,
              )
            : const SizedBox(),
      ],
    );
  }
}