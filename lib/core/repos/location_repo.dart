// core/repositories/location_repository.dart
import 'package:project1_collage/core/api_service.dart';
class LocationRepository {
  final  ApiService _apiService;
  LocationRepository(this._apiService);

  /// يرجع Map<اسم الدولة, قائمة المدن>
  Future<Map<String, List<String>>> getCountries() async {
    final response = await _apiService.get(endPoint: 'locations/countries');

    final rawData = response['data'] as Map<String, dynamic>;

    return rawData.map(
      (country, cities) => MapEntry(
        country,
        List<String>.from(cities as List),
      ),
    );
  }
}