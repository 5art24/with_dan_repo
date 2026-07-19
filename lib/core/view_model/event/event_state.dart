
part of 'event_cubit.dart';
abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  final List<BaseEvent> upcomingEvents;
  EventLoaded(this.upcomingEvents);
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}