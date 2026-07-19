part of 'task_cubit.dart';
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoaded extends TaskState {
  final DateTime selectedDate;
  final List<TaskModel> tasksForSelectedDay;
  final int totalTodayTasksCount;

  TaskLoaded({
    required this.selectedDate,
    required this.tasksForSelectedDay,
    required this.totalTodayTasksCount,
  });
}