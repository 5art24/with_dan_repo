import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/event/event_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/widgets/happening_soon_event_card.dart';
import 'package:project1_collage/features/home/models/displayed_event.dart';
import 'package:project1_collage/features/home/views/widgets/event_card.dart';

class UpcomingEventsCards extends StatelessWidget {
  const UpcomingEventsCards({super.key});

  @override
  Widget build(BuildContext context) {
      int count = 0;
    return BlocBuilder<EventCubit, EventState>(
      builder: (context, state) {
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
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      // top: 8.0,
                      // bottom: 8.0,
                    ),
                    child: HappeningSoonEventCard(
                      event: event, 
                      onTap: () {},
                    ),
                  );
                } else {
                  count++;
                  event
                      as PersonalEvent; 
                  // event is PersonalEventAdapter
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.6,
                      child: EventCard(
                        eventIcon: event.icon,
                        color: colors[count%colors.length],
                        eventTitle: event.name,
                        progress: event.progress,
                        daysLeft: event.date.difference(DateTime.now()).inDays,
                      ),
                    ),
                  );
                }
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
  }
}
