// lib/features/home/views/all_events_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/event/event_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/happening_soon_event_card.dart';
import 'package:project1_collage/features/home/views/widgets/event_card.dart';

class SeeAllEvents extends StatelessWidget {
  const SeeAllEvents({super.key});

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
      body: BlocBuilder<EventCubit, EventState>(
        builder: (context, state) {
          int count = 0;
          List<Color> colors = Styles.colors.values.toList();
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventLoaded) {
            final events = state.upcomingEvents;

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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: EventCard(
                      eventIcon: event.icon,
                      color: colors[count % colors.length],
                      eventTitle: event.name,
                      progress: event.progress,
                      daysLeft: event.date.difference(DateTime.now()).inDays,
                      height:180
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            );
          }

          if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
