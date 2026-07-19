import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/base_event.dart';
import 'package:project1_collage/core/widgets/mocks.dart';
import 'package:project1_collage/features/home/models/displayed_event.dart';

part 'event_state.dart';

// Cubit
class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial()) {
    loadUpcomingEvents();
  }

  Future<void> loadUpcomingEvents() async {
    emit(EventLoading());
    try {
      ///////////////see delete 
      final constantEvents = MockEventRepository.getConstantEvents();
      final personalEvents = MockEventRepository.getPersonalEvents();

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      final allEvents = <BaseEvent>[
        ...constantEvents,
        ...personalEvents
      ];

      // future events
      final upcoming = allEvents
          .where((e) => e.date.isAfter(todayStart.subtract(const Duration(days: 1))))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      emit(EventLoaded(upcoming));
    } catch (e) {
      emit(EventError(e.toString()));
    }
  }
}