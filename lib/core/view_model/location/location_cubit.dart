// core/view_model/location/location_cubit.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/repos/location_repo.dart';
part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _repository;
  LocationCubit(this._repository) : super(const LocationInitial());

  Map<String, List<String>> _countriesData = {};

  Future<void> fetchCountries() async {
    emit(const LocationLoading());
    try {
      _countriesData = await _repository.getCountries();
      emit(LocationLoaded(countriesData: _countriesData));
    } catch (e) {
      emit(LocationError(error: "فشل تحميل الدول والمدن: ${e.toString()}"));
    }
  }

  List<String> get countries => _countriesData.keys.toList();

  List<String> getCitiesForCountry(String country) {
    return _countriesData[country] ?? [];
  }
}