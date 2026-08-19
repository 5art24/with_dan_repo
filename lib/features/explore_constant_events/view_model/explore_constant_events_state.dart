part of 'explore_constant_events_cubit.dart';

abstract class ExploreConstantEventsState extends Equatable {
  const ExploreConstantEventsState();
  
  @override
  List<Object?> get props => [];
}

class ExploreConstantEventsInitial extends ExploreConstantEventsState {}

class ExploreConstantEventsLoading extends ExploreConstantEventsState {}

class ExploreConstantEventsLoaded extends ExploreConstantEventsState {
  final List<ConstantEventModel> categoryEvents;
  final List<ConstantEventModel> happeningSoonEvents;

  const ExploreConstantEventsLoaded({
    required this.categoryEvents,
    required this.happeningSoonEvents,
  });

  @override
  List<Object?> get props => [categoryEvents, happeningSoonEvents];
}

class ExploreConstantEventsError extends ExploreConstantEventsState {
  final String message;
  
  const ExploreConstantEventsError(this.message);
  
  @override
  List<Object?> get props => [message];
}