import 'package:flutter/material.dart';

class InteractiveRatingBar extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;

  const InteractiveRatingBar({
    super.key,
    this.initialRating = 5.0,
    required this.onRatingChanged,
  });

  @override
  State<InteractiveRatingBar> createState() => _InteractiveRatingBarState();
}

class _InteractiveRatingBarState extends State<InteractiveRatingBar> {
  late double _selectedRating;
  double? _hoverRating;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    // التقييم المعروض إما التقييم المؤقت أثناء الـ Hover أو التقييم المعتمد
    final double currentRating = _hoverRating ?? _selectedRating;

    return MouseRegion(
      onExit: (_) {
        setState(() {
          _hoverRating = null; // إلغاء المعاينة عند خروج الماوس عن نطاق النجوم
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final double starValue = index + 1.0;
          final double halfValue = index + 0.5;

          // تحديد شكل النجمة بناءً على التقييم الحالي
          IconData icon;
          if (currentRating >= starValue) {
            icon = Icons.star_rounded;
          } else if (currentRating >= halfValue) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_outline_rounded;
          }

          final bool isActive = currentRating >= halfValue;

          return SizedBox(
            width: 44,
            height: 44,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double halfWidth = constraints.maxWidth / 2;

                return GestureDetector(
                  onTapDown: (details) {
                    final bool isHalf = details.localPosition.dx < halfWidth;
                    final double newRating = isHalf ? halfValue : starValue;
                    setState(() {
                      _selectedRating = newRating;
                    });
                    widget.onRatingChanged(newRating);
                  },
                  child: MouseRegion(
                    onHover: (event) {
                      final bool isHalf = event.localPosition.dx < halfWidth;
                      setState(() {
                        _hoverRating = isHalf ? halfValue : starValue;
                      });
                    },
                    child: Center(
                      child: AnimatedScale(
                        scale: isActive ? 1.2 : 1.0, // أنيميشن التكبير الخفيف
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOutCubic,
                        child: Icon(
                          icon,
                          color: isActive ? Colors.amber : Colors.grey.shade400,
                          size: 38,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}