// cubit/event_planning_state.dart
part of 'event_planning_cubit.dart';

abstract final class EventPlanningState extends Equatable {
  const EventPlanningState();

  @override
  List<Object?> get props => [];
}

//======================Basic states========================
final class EventPlanningInitial extends EventPlanningState {}

final class EventLoading extends EventPlanningState {}

final class EventLoaded extends EventPlanningState {
  final PersonalEvent event;
  const EventLoaded(this.event);
  @override
  List<Object?> get props => [event];
}

final class EventUpdated extends EventPlanningState {
  final PersonalEvent event;
  const EventUpdated(this.event);
  @override
  List<Object?> get props => [event];
}

final class EventSavedSuccess extends EventPlanningState {
  final PersonalEvent event;
  const EventSavedSuccess(this.event);
  @override
  List<Object?> get props => [event];
}

final class PersonalEventError extends EventPlanningState {
  final String error;
  const PersonalEventError(this.error);
  @override
  List<Object?> get props => [error];
}

//========================Location Selection States========================

final class LocationInitial extends EventPlanningState {}

final class LocationTypeChanged extends EventPlanningState {
  final String locationType;
  final String? selectedVenue;
  const LocationTypeChanged(this.locationType, this.selectedVenue);
  @override
  List<Object?> get props => [locationType, selectedVenue];
}

final class VenueSelected extends EventPlanningState {
  final String venue;
  const VenueSelected(this.venue);

  @override
  List<Object?> get props => [venue];
}

final class GPSSuccess extends EventPlanningState {
  final String address;
  const GPSSuccess(this.address);
  @override
  List<Object?> get props => [address];
}

final class GPSLoading extends EventPlanningState {}

final class GPSError extends EventPlanningState {
  final String error;
  const GPSError(this.error);
  @override
  List<Object?> get props => [error];
}

//==========================Service Display States========================
final class ServicesLoading extends EventPlanningState {}

final class ServiceAlreadyBooked extends EventPlanningState {
  final String serviceName;

  const ServiceAlreadyBooked(this.serviceName);

  @override
  List<Object?> get props => [serviceName];
}

final class ServicesError extends EventPlanningState {
  final String error;
  const ServicesError(this.error);
  @override
  List<Object?> get props => [error];
}

final class ServicesFilterChanged extends EventPlanningState {
  final ServiceType selectedType;
  final FilterType selectedFilter;
  final List<ServiceModel>
  services; // i add it cuz it might change bcuz anthor factors like having anthor services from the server

  const ServicesFilterChanged(
    this.selectedType,
    this.selectedFilter,
    this.services,
  );
  @override
  List<Object?> get props => [selectedType, selectedFilter, services];
}

final class EventNotInitialized extends EventPlanningState {}

//=========================Service Booking States========================
final class ServiceBookedSuccess extends EventPlanningState {
  final String serviceName;
  final PersonalEvent event;
  const ServiceBookedSuccess(this.serviceName, this.event);

  @override
  List<Object?> get props => [serviceName, event];
}




//==========================Explanation===================================
//Equatable is a package used to compare depending on references not values