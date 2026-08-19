import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/styles.dart';

class PersonalEventCard extends StatelessWidget {
  final PersonalEvent event; // إضافة حقل PersonalEvent
  final IconData eventIcon;
  final Color color;
  final String eventTitle;
  final double progress;
  final int daysLeft;
  final double? height; // ✅ اختياري للارتفاع

  const PersonalEventCard({
    super.key,
    required this.event,
    required this.eventIcon,
    required this.color,
    required this.eventTitle,
    required this.progress,
    required this.daysLeft,
    this.height, // null يعني تمدد حسب المحتوى
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
       GoRouter.of(context).push(AppRoutes.kPersonalEventDetails,extra: {'event': event}); // تمرير الحدث الفعلي عند النقر;
      },
      child: Container(
        height: height, // ✅ إذا كان null سيأخذ حجم المحتوى تلقائياً
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(eventIcon, color: Colors.white, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: // الأيام المتبقية
                  Text(
                    '$daysLeft days left',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
      
            Expanded(child: const SizedBox(height: 12)),
      
            // عنوان الفعالية
            Text(
              eventTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
      
            const SizedBox(height: 12),
      
            // شريط التقدم
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Styles.mainColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Progress", style: Styles.body),
                  Text("${(progress * 100).toInt()}%", style: Styles.body),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
