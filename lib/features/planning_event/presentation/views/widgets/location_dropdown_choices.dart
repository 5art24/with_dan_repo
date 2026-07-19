import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class LocationDropdownChoices extends StatelessWidget {
  const LocationDropdownChoices({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EventPlanningCubit>();
    return DropdownButton<String>(
      isExpanded: true,
      value: cubit.getLocationType(),
      hint: Text("Select Location", style: Styles.body),
      items: const [
        DropdownMenuItem(
          value: "Venue You Choose",
          child: Text("Venue You Choose", style: Styles.body),
        ),
        DropdownMenuItem(
          value: "Place You Choose by GPS",
          child: Text("Place You Choose by GPS", style: Styles.body),
        ),
      ],
      onChanged: (val) {
        if (val != null) {
          cubit.changeLocationType(val); // ✅ هذا سيؤدي إلى تحديث الخدمات تلقائياً
        }
      },
    );
  }
}
