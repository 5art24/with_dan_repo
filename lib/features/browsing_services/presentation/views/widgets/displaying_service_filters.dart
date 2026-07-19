import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/custom_button.dart';

class DisplayingServiceFilters extends StatelessWidget {
  DisplayingServiceFilters({
    super.key,
    required this.fieldWidth,
    // required this.fieldHeight,
    required this.filters,
    required this.cubit,
  });

  final double fieldWidth;
  // final double fieldHeight;
  final EventPlanningCubit cubit;
  final List<FilterType> filters;
  FilterType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only( top: 4, bottom: 4),
      width: fieldWidth,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return CustomButton(
            name: cubit.getFilterLabel(filters[index]),
            width: 65.0,
            onTap: () {
              cubit.changeFilter(filters[index]);
            },
            isPressed: cubit.isFilterSelected(filters[index]),
          );
        },
      ),
    );
  }
}
