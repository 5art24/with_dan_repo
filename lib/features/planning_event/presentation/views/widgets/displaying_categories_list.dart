import 'package:flutter/material.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/custom_button.dart';

class DisplayingCategoriesList extends StatelessWidget {
  DisplayingCategoriesList({
    super.key,
    required this.fieldWidth,
    required this.fieldHeight,
    required this.categories,
    required this.cubit,
  });

  final double fieldWidth;
  final double fieldHeight;
  final EventPlanningCubit cubit;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      width: fieldWidth,
      height: fieldHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CustomButton(
            name: categories[index],
            width: 78.0,
            onTap: () {
              cubit.updateCategory(categories[index]);
            },
            isPressed: cubit.isCategorySelected(categories[index]),
          );
        },
      ),
    );
  }
}
