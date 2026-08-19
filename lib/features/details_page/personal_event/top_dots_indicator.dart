import 'package:flutter/material.dart';

class TopDotsIndicator extends StatelessWidget {
  const TopDotsIndicator({
    super.key,
    required PageController pageController,
    required int itemCount,
    required this.primaryColor,
  })  : _pageController = pageController,
        _itemCount = itemCount;

  final PageController _pageController;
  final int _itemCount;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        int roundedPage = 0;
        if (_pageController.hasClients && _pageController.page != null) {
          roundedPage = _pageController.page!.round();
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_itemCount, (index) {
            final bool isActive = roundedPage == index;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? primaryColor : primaryColor.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
            );
          }),
        );
      },
    );
  }
}