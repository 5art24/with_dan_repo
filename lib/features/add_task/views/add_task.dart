import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/add_task/views/widgets/add_task_bottom_sheet.dart';
import 'package:project1_collage/features/home/views/widgets/task_card_with_time.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 🆕

class EventTasksScreen extends StatelessWidget {
  const EventTasksScreen({super.key, required this.needsAppBar});
  final bool needsAppBar;
  void _openAddTaskBottomSheet(
    BuildContext context, {
    TaskModel? taskToEdit, // 🆕
  }) {
    final cubit = context.read<EventPlanningCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return AddTaskBottomSheet(
          existingTask: taskToEdit, // 🆕
          onTaskSaved: (task) {
            if (taskToEdit != null) {
              cubit.updateTask(task); // 🆕 تعديل
            } else {
              cubit.addTask(task); // إضافة كما كان
            }
          },
          eventId: cubit.currentEvent?.id ?? '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardColors = Styles.colors.values.toList();

    return BlocListener<EventPlanningCubit, EventPlanningState>(
      listener: (context, state) {
        if (state is PersonalEventError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is EventSavedSuccess) {
          final cubit = context.read<EventPlanningCubit>();
          final event = cubit.currentEvent;
          if (event != null) {
            // 🟢 التحقق من حالة التعديل لاستدعاء التابع المناسب
            if (cubit.isEditing) {
              // 1️⃣ استدعاء تابع التعديل بدلاً من الإضافة
              context.read<AuthCubit>().updatePersonalEvent(event);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تعديل الفعالية بنجاح'),
                  backgroundColor: Colors.green,
                ),
              );
              // 🟢 العودة بـ popUntil حتى الوصول لصفحة تفاصيل الفعالية
              Navigator.of(context).popUntil((route) {
                return route.settings.name == AppRoutes.kPersonalEventDetails ||
                    route.isFirst;
              });
            } else {
              // 1️⃣ إضافة الفعالية المكتملة لليوزر
              context.read<AuthCubit>().addPersonalEvent(state.event);

              // 2️⃣ تصفير الـ Cubit وتجهيزه لفعالية جديدة
              cubit.startNewEvent();

              // 3️⃣ الرجوع لصفحة planning_event فاضية، مع تفريغ كامل الـ stack
              //    (planning_event -> services -> event_tasks تنمسح كلها)
              GoRouter.of(context).go(AppRoutes.kPlanEvent);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حفظ الفعالية بنجاح')),
              );
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            needsAppBar ? 'ADD TASK' : 'Tasks',
            style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          leading: needsAppBar
              ? IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: Icon(Icons.arrow_back, color: Styles.mainColor),
                )
              : null,
          actions: [
            if (needsAppBar) // 🟢 الحل هنا: استخدام collection if بدلاً من الشرط الثلاثي
              IconButton(
                onPressed: () {
                  context.read<EventPlanningCubit>().saveEvent();
                },
                icon: const Icon(Icons.done),
              ),
          ],
        ),
        bottomNavigationBar: needsAppBar ? SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: () => _openAddTaskBottomSheet(context),
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
        ): null,
        body: BlocBuilder<EventPlanningCubit, EventPlanningState>(
          builder: (context, state) {
            final cubit = context.read<EventPlanningCubit>();
            final currentEvent = state is EventWithDataState
                ? state.event
                : cubit.currentEvent;
            final tasks = currentEvent?.tasks ?? [];

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  'No tasks added yet for this event.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final color = cardColors[index % cardColors.length];

                return Slidable(
                  key: ValueKey(task.id),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.5,
                    children: [
                      CustomSlidableAction(
                        onPressed: (_) =>
                            _openAddTaskBottomSheet(context, taskToEdit: task),
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.all(6),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: Styles.mainColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit, color: Colors.white),
                              SizedBox(height: 4),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomSlidableAction(
                        onPressed: (_) => cubit.deleteTask(task.id),
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Styles.colors["blushPink"],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete, color: Colors.white),
                              SizedBox(height: 4),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: TaskCardWithTime(
                    task: task,
                    eventName: currentEvent?.name ?? '',
                    cardColor: color,
                    onStatusChanged: (bool? value) {
                      cubit.toggleTaskStatus(task.id);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
