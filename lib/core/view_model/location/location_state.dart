// core/view_model/location/location_state.dart
part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final Map<String, List<String>> countriesData;
  const LocationLoaded({required this.countriesData});

  @override
  List<Object?> get props => [countriesData];
}

class LocationError extends LocationState {
  final String error;
  const LocationError({required this.error});

  @override
  List<Object?> get props => [error];
}