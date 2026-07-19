part of 'explore_constant_events_cubit.dart';

abstract class ExploreConstantEventsState extends Equatable {
  const ExploreConstantEventsState();
  
  @override
  List<Object?> get props => [];
}

class ExploreConstantEventsInitial extends ExploreConstantEventsState {}

class ExploreConstantEventsLoading extends ExploreConstantEventsState {}

class ExploreConstantEventsLoaded extends ExploreConstantEventsState {
  final List<ConstantEventModel> events;
  
  const ExploreConstantEventsLoaded(this.events);
  
  @override
  List<Object?> get props => [events];
}

class ExploreConstantEventsError extends ExploreConstantEventsState {
  final String message;
  
  const ExploreConstantEventsError(this.message);
  
  @override
  List<Object?> get props => [message];
}