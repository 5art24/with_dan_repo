// features/planning_event/presentation/views/widgets/gps_location_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/map_screen_picker.dart';

class GPSLocationPicker extends StatelessWidget {
  const GPSLocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EventPlanningCubit>();
    final event = cubit.currentEvent;
    
    // الحصول على العنوان من الحدث
    String address = event?.gpsAddress ?? 'لم يتم تحديد موقع بعد';
    bool hasLocation = event?.latitude != null && event?.longitude != null;

    return GestureDetector(
      onTap: () async {
        // ✅ الانتقال إلى صفحة اختيار الموقع
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapPickerScreen(),
          ),
        );
        
        // ✅ إذا تم إرجاع نتيجة، قم بتحديث العرض
        // التحديث سيتم تلقائياً من خلال الـ Cubit
        if (result != null && context.mounted) {
          // لا حاجة لفعل شيء، الـ Cubit تم تحديثه بالفعل
          // و context.watch سيعيد بناء الـ widget تلقائياً
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Styles.mainColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.map,
              color: Styles.mainColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الموقع المحدد',
                    style: Styles.smallTitle.copyWith(
                      color: Styles.mainColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: Styles.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasLocation) ...[
                    const SizedBox(height: 2),
                    Text(
                      'اضغط لتعديل الموقع',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 2),
                    Text(
                      'اضغط لتحديد الموقع',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}