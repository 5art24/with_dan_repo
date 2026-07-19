import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/features/explore_constant_events/view_model/explore_constant_events_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/custom_button.dart';

class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({super.key});

  // قائمة التصنيفات
  final List<Map<String, dynamic>> categories = const[
    {'name': 'All', 'icon': Icons.check_circle_outline},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Art', 'icon': Icons.palette},
    {'name': 'Workshop', 'icon': Icons.architecture},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreConstantEventsCubit, ExploreConstantEventsState>(
      builder: (context, state) {
        final selectedCategory = context.read<ExploreConstantEventsCubit>().selectedCategory;
        
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final categoryName = categories[index]['name'];
              final isSelected = selectedCategory == categoryName;
              
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CustomButton(
                  name: categoryName,
                  icon: categories[index]['icon'],
                  isPressed: isSelected,
                  onTap: () {
                    context.read<ExploreConstantEventsCubit>().filterByCategory(categoryName);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}