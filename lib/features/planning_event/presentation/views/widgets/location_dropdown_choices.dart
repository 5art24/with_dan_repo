// features/planning_event/presentation/views/widgets/location_dropdown_choices.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class LocationDropdownChoices extends StatelessWidget {
  const LocationDropdownChoices({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EventPlanningCubit>();
    final currentLocationType = cubit.getLocationType();

    final items = const [
      DropdownMenuItem(
        value: "Venue You Choose",
        child: Text("Venue You Choose (من الصالات)", style: Styles.body),
      ),
      DropdownMenuItem(
        value: "By Country/City",
        child: Text("By Country/City (من القائمة)", style: Styles.body),
      ),
    ];

    return DropdownButton<String>(
      isExpanded: true,
      value: items.any((item) => item.value == currentLocationType)
          ? currentLocationType
          : "Venue You Choose",
      hint: Text("اختر طريقة تحديد المكان", style: Styles.body),
      items: items,
      onChanged: (val) {
        if (val != null) {
          cubit.changeLocationType(val);
        }
      },
    );
  }
}