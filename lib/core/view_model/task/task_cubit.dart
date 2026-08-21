import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/widgets/mocks.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final AuthCubit authCubit;
  List<TaskModel> _allTasks = [];
  DateTime _selectedDate;
  StreamSubscription? _authSubscription;

  TaskCubit({required this.authCubit})
    : _selectedDate = DateTime.now(),
      super(TaskInitial()) {
    _loadAllTasks();
    _emitFilteredTasks();

    // إعادة تحميل المهام فور تغير بيانات المستخدم في AuthCubit
    _authSubscription = authCubit.stream.listen((authState) {
      if (authState is Authenticated) {
        _loadAllTasks();
        _emitFilteredTasks();
      }
    });
  }

  DateTime get selectedDate => _selectedDate;

  void _loadAllTasks() {
    // 🟢 جلب المستخدم الحالي من AuthCubit
    final user = authCubit
        .currentUser; // أو authCubit.state.User حسب الموديل لديك

    if (user != null) {
      // 🟢 استخراج جميع المهام من الفعاليات الشخصية وتزويدها بمعلومات الفعالية
      _allTasks = (user as NormalUser).personalEvents.expand((event) {
        return event.tasks.map((task) {
          return TaskModel(
            id: task.id,
            title: task.title,
            // إذا كانت المهمة تحتوي تاريخاً نستخدمه، وإلا نستخدم تاريخ الفعالية نفسها
            dateTime: task.startDateTime ?? event.startDate,
            eventId: event.id,
            eventTitle: event.name,
            isDone: task.isDone,
            priority: task.priority ?? 1,
          );
        });
      }).toList();
    } else {
      _allTasks = [];
    }
  }

  void _emitFilteredTasks() {
    final selectedDayStart = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );
    //bring tasks belong to
    final dayTasks = _allTasks.where((task) {
      final taskDay = DateTime(
        task.startDateTime.year,
        task.startDateTime.month,
        task.startDateTime.day,
      );
      return taskDay == selectedDayStart;
    }).toList();

    //relying on isDone then priority
    dayTasks.sort((a, b) {
      if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
      if (a.priority != b.priority) return a.priority.compareTo(b.priority);
      return a.startDateTime.compareTo(b.startDateTime);
    });

    final incompleteCount = dayTasks.where((t) => !t.isDone).length;

    emit(
      TaskLoaded(
        selectedDate: _selectedDate,
        tasksForSelectedDay: dayTasks,
        totalTodayTasksCount: incompleteCount,
      ),
    );
  }

  // void selectDay(DateTime day) {
  //   _selectedDate = day;
  //   _emitFilteredTasks();
  // }

  void toggleTaskCompletion(TaskModel task) {
    if (authCubit.state is! Authenticated) return;

    final currentUser = ((authCubit.state as Authenticated).user as NormalUser);

    // 1. تحديث حالة المهمة داخل الفعالية المحددة
    final updatedEvents = currentUser.personalEvents.map((event) {
      if (event.id == task.eventId) {
        final updatedTasks = event.tasks.map((t) {
          return t.id == task.id ? t.copyWith(isDone: !t.isDone) : t;
        }).toList();

        return event.copyWith(tasks: updatedTasks);
      }
      return event;
    }).toList();

    // 2. تحديث بيانات المستخدم في AuthCubit لإعلام جميع الشاشات
    final updatedUser = currentUser.copyWith(
      personalEvents: updatedEvents,
    );
    authCubit.updateUserData(
      updatedUser,
    ); // يُطلق Authenticated(updatedUser)

    // 3. تحديث حالة TaskCubit المحلية للواجهة الحالية
    _refreshCurrentDayTasks(updatedUser);
  }

  void addNewTask(TaskModel newTask) {
    if (authCubit.state is! Authenticated) return;

    final currentUser = ((authCubit.state as Authenticated).user as NormalUser);

    // إضافة المهمة للفعالية المناسبة
    final updatedEvents = currentUser.personalEvents.map((event) {
      if (event.id == newTask.eventId) {
        final updatedTasks = List<TaskModel>.from(event.tasks)..add(newTask);
        return event.copyWith(tasks: updatedTasks);
      }
      return event;
    }).toList();

    final updatedUser = currentUser.copyWith(
      personalEvents: updatedEvents,
    );
    authCubit.updateUserData(updatedUser);

    _refreshCurrentDayTasks(updatedUser);
  }

  // 🟢 التابع المساعد لتجهيز قائمة مهام اليوم المختار
  void _refreshCurrentDayTasks(NormalUser updatedUser) {
    // 1. تجميع كل المهام من جميع الفعاليات الخاصة بالمستخدم
    final allTasks = updatedUser.personalEvents
        .expand((event) => event.tasks)
        .toList();

    // 2. فلترة المهام لتأخذ فقط المهام التي تطابق التاريخ المحدد (selectedDate)
    final tasksForSelectedDay = allTasks.where((task) {
      return task.startDateTime.year == selectedDate.year &&
          task.startDateTime.month == selectedDate.month &&
          task.startDateTime.day == selectedDate.day;
    }).toList();

    // 3. إطلاق حالة TaskLoaded الجديدة بالبيانات المحدثة
    emit(
      TaskLoaded(
        tasksForSelectedDay: tasksForSelectedDay,
        totalTodayTasksCount: tasksForSelectedDay.length,
        selectedDate: selectedDate,
      ),
    );
  }

  // مثال: عند اختيار يوم جديد من التقويم/الفلتر
  void selectDay(DateTime date) {
    _selectedDate = date;
    if (authCubit.state is Authenticated) {
      final user = ((authCubit.state as Authenticated).user as NormalUser);
      _refreshCurrentDayTasks(user);
    }
  }
}
