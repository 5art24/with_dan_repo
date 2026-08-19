import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/planning_event_view_body.dart';

class PlanningEventView extends StatelessWidget {
  const PlanningEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EventPlanningCubit>();

    // بدء فعالية جديدة إذا كانت الحالة فارغة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cubit.currentEvent == null) {
        cubit.startNewEvent();
      }
    });

    return BlocListener<EventPlanningCubit, EventPlanningState>(
      listener: (context, state) {
        // 1️⃣ في حالة وجود خطأ أو حقول غير مكتملة
        if (state is PersonalEventError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        // 2️⃣ في حالة نجاح الحفظ واكتمال البيانات
        else if (state is EventSavedSuccess) {
          final event = cubit.currentEvent;
          if (event != null) {
            GoRouter.of(context).push(
              AppRoutes.kDispalyingSelectedServices,
              extra: {
                'event': event,
                'cubit': cubit,
              }, // تمرير الـ Cubit مع الفعالية
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // ❌ زر الإلغاء: تصفير البيانات وإعادة إنشاء فعالية جديدة فارغة
          leading: IconButton(
            onPressed: () {
              cubit.clearEvent();
              cubit
                  .startNewEvent(); // استدعاء صريح وفوري، لا تعتمد على postFrameCallback
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('تم إلغاء الفعالية وإعادة ضبط البيانات'),
                  ),
                );
              if (GoRouter.of(context).canPop()) {
                GoRouter.of(context).pop();
              }
            },
            icon: Icon(Icons.cancel, color: Styles.mainColor),
          ),

          actions: [
            // ➡️ زر الحفظ / الانتقال
            IconButton(
              onPressed: () {
                if (cubit.isEventDataComplete()) {
                  cubit.saveEvent();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('يرجى ملء جميع الحقول الإلزامية أولاً'),
                    ),
                  );
                }
              },
              icon: Icon(Icons.arrow_forward, color: Styles.mainColor),
            ),
          ],
        ),
        body: const PlanningEventViewBody(
          key: PageStorageKey('planning_event_page'),
        ),
      ),
    );
  }
}
