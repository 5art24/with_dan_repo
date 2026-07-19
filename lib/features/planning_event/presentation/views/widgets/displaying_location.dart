// features/planning_event/presentation/views/widgets/displaying_location.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/gps_location_picker.dart';

class DisplayingLocation extends StatelessWidget {
  final String location;
  const DisplayingLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EventPlanningCubit>();
    final locationType = cubit.getLocationType();
    
    // ✅ إذا كان نوع الموقع "Place You Choose by GPS" اعرض واجهة GPS
    if (locationType == "Place You Choose by GPS") {
      return const GPSLocationPicker();
    }

    // ✅ إذا كان نوع الموقع "Venue You Choose" وتم اختيار صالة
    if (locationType == "Venue You Choose") {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Styles.mainColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.location_city, color: Styles.mainColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                location == "اختر طريقة تحديد المكان أولاً" ? "لم يتم اختيار صالة بعد" : location,
                style: Styles.body,
              ),
            ),
          ],
        ),
      );
    }

    // حالة افتراضية
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              location,
              style: Styles.body.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}