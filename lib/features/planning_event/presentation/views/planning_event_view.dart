import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/widgets/custom_nav_bar.dart';
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
      if (cubit.currentEvent == null ) {
        cubit.startNewEvent();
      }
    });
    return Scaffold(
      appBar: AppBar(
        //cancel button to clear the data
        leading:  IconButton(
            onPressed: () => cubit.startNewEvent(), // ← مسح البيانات فقط
            icon: Icon(
              Icons.cancel,
              color: Styles.mainColor,
            ),
          ),

        actions: [
          //forward button to save the data and go to the next page
          IconButton(
          onPressed: () async {
            final event = cubit.currentEvent;
            if (event != null && event.name.isNotEmpty) {
              // await cubit.saveEvent(); 
              GoRouter.of(context).push(AppRoutes.kDispalyingSelectedServices, extra: { 'event': event }); 
               } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter the event details first')),
              );
            }
          },
          icon: Icon(Icons.arrow_forward)
        ),
         
        ],
      ),
      body:
          PlanningEventViewBody(key: PageStorageKey('planning_event_page')),
    );
  }
}
