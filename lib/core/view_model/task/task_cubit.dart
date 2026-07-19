import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/widgets/mocks.dart';

part 'task_state.dart';
class TaskCubit extends Cubit<TaskState> {
  List<TaskModel> _allTasks = [];
  DateTime _selectedDate;
  

  TaskCubit() : _selectedDate = DateTime.now(), super(TaskInitial()) {
    _loadAllTasks();
    _emitFilteredTasks();
  }
  DateTime  get selectedDate => _selectedDate;
  void _loadAllTasks() {
    final personalEvents = MockEventRepository.getPersonalEvents();
    _allTasks = personalEvents.expand((event) => event.tasks).toList();
  }

  void _emitFilteredTasks() {
    final selectedDayStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    //bring tasks belong to 
    final dayTasks = _allTasks.where((task) {
      final taskDay = DateTime(task.dateTime.year, task.dateTime.month, task.dateTime.day);
      return taskDay == selectedDayStart;
    }).toList();

    //relying on isDone then priority
    dayTasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      if (a.priority != b.priority) return a.priority.compareTo(b.priority);
      return a.dateTime.compareTo(b.dateTime);
    });

    final incompleteCount = dayTasks.where((t) => !t.isDone).length;

    emit(TaskLoaded(
      selectedDate: _selectedDate,
      tasksForSelectedDay: dayTasks,
      totalTodayTasksCount: incompleteCount,
    ));
  }

  void selectDay(DateTime day) {
    _selectedDate = day;
    _emitFilteredTasks();
  }

  void toggleTaskCompletion(TaskModel task) {
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allTasks[index] = _allTasks[index].copyWith(isDone: !_allTasks[index].isDone);
      _emitFilteredTasks();
    }
  }
}