import 'package:flutter/material.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({
    super.key,
    required PageController pageController,
    required int currentPage,
    required List<String> Images,
    required this.primaryColor,
  }) : _pageController = pageController, _currentPage = currentPage, _festivalImages = Images;

  final PageController _pageController;
  final int _currentPage;
  final List<String> _festivalImages;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          // حساب الصفحة الحالية الفعالة مباشرة من حركة الكنترولر أثناء السحب
          // نستخدم تفادي الخطأ (?? 0) في حال لم يكن الكنترولر قد تم بناؤه بعد
          int roundedPage = 0;
          if (_pageController.hasClients &&
              _pageController.page != null) {
            roundedPage = _pageController.page!.round();
          } else {
            roundedPage = _currentPage;
          }
    
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_festivalImages.length, (
              index,
            ) {
              // المقارنة الآن تتم مع الصفحة الفورية المحسوبة أثناء السحب
              final bool isActive = roundedPage == index;
    
              return AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                width: isActive
                    ? 24
                    : 6, // تصبح النقطة أعرض إذا كانت نشطة
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? primaryColor
                      : Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: primaryColor
                                .withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}