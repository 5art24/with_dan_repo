// features/planning_event/presentation/views/widgets/displaying_location.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/city_area_dropdown_selector.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class DisplayingLocation extends StatelessWidget {
  final String location;
  const DisplayingLocation({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EventPlanningCubit>();
    final locationType = cubit.getLocationType();
    final event = cubit.currentEvent;

    // 1️⃣ حالة الاختيار القائم على القائمة (City -> Area)
    if (locationType == "By Country/City") {
      // في صفحة تخطيط الفعالية
      return CityAreaDropdownSelector(
        selectedCity: cubit.getSelectedCity(),
        selectedArea: cubit.getSelectedArea(),
        onCityChanged: (city) => cubit.updateCity(city),
        onAreaChanged: (area) => cubit.updateArea(area),
      );
    }

    // 2️⃣ حالة اختيار صالة من الخدمات (Venue You Choose)
    if (locationType == "Venue You Choose") {
      final hasVenue = event?.area.isNotEmpty ?? false;

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
                hasVenue
                    ? "الصالة المختارة: ${event!.area}"
                    : "لم يتم اختيار صالة من قسم الخدمات بعد",
                style: Styles.body.copyWith(
                  color: hasVenue ? Colors.black : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
