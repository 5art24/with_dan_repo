// features/home/views/event_tasks_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/add_task/views/widgets/add_task_bottom_sheet.dart';
import 'package:project1_collage/features/home/views/widgets/task_card_with_time.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class EventTasksScreen extends StatefulWidget {
  final PersonalEvent event;

  const EventTasksScreen({super.key, required this.event});

  @override
  State<EventTasksScreen> createState() => _EventTasksScreenState();
}

class _EventTasksScreenState extends State<EventTasksScreen> {
  late PersonalEvent _currentEvent;

  final List<Color> _cardColors = Styles.colors.values.toList();

  @override
  void initState() {
    super.initState();
    _currentEvent = widget.event;
  }

  void _openAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return AddTaskBottomSheet(
          onTaskSaved: (newTask) {
            setState(() {
              final updatedTasks = List<TaskModel>.from(_currentEvent.tasks)
                ..add(newTask);
              _currentEvent = _currentEvent.copyWith(tasks: updatedTasks);
            });
          }, eventId: widget.event.id,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EventPlanningCubit>();
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text(
          'ADD TASK',
          style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        leading:  IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: Styles.mainColor,
            ),
          ),
        actions: [
          IconButton(
          onPressed: () async {
            final event = cubit.currentEvent;
            if (event != null && event.name.isNotEmpty) {
              await cubit.saveEvent(); 
            cubit.startNewEvent();
               } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter the event details first')),
              );
            }
          },
          icon: Icon(Icons.done)
        ),
         
        ],
      ),
     
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: SizedBox(
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C5CFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: _openAddTaskBottomSheet,
              child: const Text(
                'Create a new task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _currentEvent.tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks added yet for this event.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _currentEvent.tasks.length,
              itemBuilder: (context, index) {
                final task = _currentEvent.tasks[index];
                // تدوير مصفوفة الألوان بدقة لتجنب أي مشاكل Out of bounds عند كثرة البطاقات
                final color = _cardColors[index % _cardColors.length];

                return TaskCardWithTime(
                  task: task,
                  eventName: _currentEvent.name,
                  cardColor: color,
                  
                );
              },
            ),
    );
  }
}
