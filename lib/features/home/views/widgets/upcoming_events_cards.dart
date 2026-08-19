import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/view_model/event/event_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/happening_soon_event_card.dart';
import 'package:project1_collage/features/home/views/widgets/personal_event_card.dart';

class UpcomingEventsCards extends StatelessWidget {
  const UpcomingEventsCards({super.key});

  // 🟢 تابع مساعد لحساب التقدم ديناميكياً من قائمة المهام المحدثة
  double _calculateEventProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((t) => t.isDone).length;
    return completedCount / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    // 🟢 الاستماع للتغيرات الحاصلة في AuthCubit
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<EventCubit, EventState>(
          builder: (context, state) {
            int count = 0;

            if (state is EventLoading) {
              return const SizedBox(
                height: 175,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is EventLoaded) {
              final events = state.upcomingEvents;

              if (events.isEmpty) {
                return const SizedBox(
                  height: 175,
                  child: Center(child: Text('There are no events at the moment')),
                );
              }

              return ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 175, maxHeight: 200),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    List<Color> colors = Styles.colors.values.toList();

                    //===================================check the type=================================
                    if (event is ConstantEventModel) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: const EdgeInsets.only(right: 8.0),
                        child: HappeningSoonEventCard(
                          event: event,
                          onTap: () => GoRouter.of(context).push(
                            AppRoutes.kConstantEventDetails,
                            extra: {'event': event},
                          ),
                        ),
                      );
                    } else if (event is PersonalEvent) {
                      count++;

                      // 🟢 جلب أحدث نسخة من الفعالية بمهامها المحدثة عبر الـ ID
                      final updatedEvent = (authState is Authenticated)
                          ? authState.user.personalEvents.firstWhere(
                              (e) => e.id == event.id,
                              orElse: () => event,
                            )
                          : event;

                      // 🟢 حساب التقدم ديناميكياً
                      final currentProgress =
                          _calculateEventProgress(updatedEvent.tasks);

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.6,
                          child: PersonalEventCard(
                            eventIcon: updatedEvent.icon,
                            color: colors[count % colors.length],
                            eventTitle: updatedEvent.name,
                            progress: currentProgress, // يتحدث فورياً
                            daysLeft: updatedEvent.startDate
                                .difference(DateTime.now())
                                .inDays,
                            event: updatedEvent,
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              );
            }

            if (state is EventError) {
              return const SizedBox(
                height: 175,
                child: Center(child: Text('حدث خطأ في تحميل الفعاليات')),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}