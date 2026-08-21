// lib/features/home/views/all_events_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/view_model/event/event_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/happening_soon_event_card.dart';
import 'package:project1_collage/features/home/views/widgets/personal_event_card.dart';

class SeeAllEvents extends StatelessWidget {
  const SeeAllEvents({super.key});

  // 🟢 تابع مساعد لحساب التقدم ديناميكياً من قائمة المهام المحدثة
  double _calculateEventProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((t) => t.isDone).length;
    return completedCount / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Upcoming Events', style: Styles.largeTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // 🟢 تغليف الصفحة بـ BlocBuilder لـ AuthCubit لضمان استجابتها للتغيرات
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<EventCubit, EventState>(
            builder: (context, eventState) {
              int count = 0;
              List<Color> colors = Styles.colors.values.toList();

              if (eventState is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (eventState is EventLoaded) {
                final events = eventState.upcomingEvents;

                if (events.isEmpty) {
                  return const Center(child: Text('No upcoming events'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];

                    if (event is ConstantEventModel) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          height: 200,
                          child: HappeningSoonEventCard(
                            event: event,
                            onTap: () {
                              GoRouter.of(context).push(
                                AppRoutes.kConstantEventDetails,
                                extra: {'event': event},
                              );
                            },
                          ),
                        ),
                      );
                    } else if (event is PersonalEvent) {
                      count++;

                      // 🟢 جلب الفعالية المحدثة ذات نفس الـ ID من AuthCubit
                      final updatedEvent = (authState is Authenticated)
                          ? (authState.user as NormalUser).personalEvents.firstWhere(
                              (e) => e.id == event.id,
                              orElse: () => event,
                            )
                          : event;

                      // 🟢 حساب التقدم ديناميكياً بناءً على مهام updatedEvent
                      final currentProgress = _calculateEventProgress(
                        updatedEvent.tasks,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: PersonalEventCard(
                          event: updatedEvent, // تمرير الفعالية المحدثة
                          eventIcon: updatedEvent.icon,
                          color: colors[count % colors.length],
                          eventTitle: updatedEvent.name,
                          progress: currentProgress, // شريط التقدم يتحدث فورياً
                          daysLeft: updatedEvent.startDate
                              .difference(DateTime.now())
                              .inDays,
                          height: 180,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              }

              if (eventState is EventError) {
                return Center(child: Text('Error: ${eventState.message}'));
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
