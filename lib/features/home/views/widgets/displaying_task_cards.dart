// import 'package:flutter/material.dart';
// import 'package:project1_collage/core/models/task.dart';
// import 'package:project1_collage/core/styles.dart';
// import 'package:project1_collage/features/home/views/widgets/task_card_with_time.dart';

// class DisplayingTaskCards extends StatelessWidget {
//   const DisplayingTaskCards({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: 5,
//       itemBuilder: (context, index) {
//         return TaskCardWithTime(
//           task: TaskModel(
            
//             id: "10",
//             title: "title",
//             dateTime: DateTime(2020, 5, 24), eventId: 'event1', eventTitle: '',
//           ),
//           eventName: '',
//           cardColor: Styles.colors.values.toList()[index],
//           onCheckboxChanged: (bool? value) {},
//         );
//       },
//     );
//   }
// }
// lib/features/home/views/widgets/displaying_task_cards.dart
// lib/features/home/views/widgets/displaying_task_cards.dart
// features/home/views/widgets/displaying_task_cards.dart
// lib/features/home/views/widgets/displaying_task_cards.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/task/task_cubit.dart';
import 'package:project1_collage/features/home/views/widgets/task_card_with_time.dart';

class DisplayingTaskCards extends StatelessWidget {
  const DisplayingTaskCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoaded) {
          final tasks = state.tasksForSelectedDay;
          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'There are no tasks',
                  style: Styles.body.copyWith(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final colorIndex = index % Styles.colors.values.length;
              final cardColor = Styles.colors.values.toList()[colorIndex];

              return TaskCardWithTime(
                task: task,
                eventName: task.eventTitle ,
                cardColor: cardColor,
              );
            },
          );
        }
        if (state is TaskInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SizedBox.shrink();
      },
    );
  }
}