import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/features/search_results/view_model/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  // 🟢 متغيرات الفلترة الخاصة بالموقع
  String _selectedCity = '';
  String _selectedArea = '';
  String _lastQuery = '';
  // 🟢 المتغير الجديد للتحكم بتفعيل الفلتر
  bool _isLocationFilterEnabled = false;

  // Getters للواجهات
  String get selectedCity => _selectedCity;
  String get selectedArea => _selectedArea;
  bool get isLocationFilterEnabled => _isLocationFilterEnabled;


  /// 🟢 تحديث city وتفريغ area
  void updateCity(String city) {
    _selectedCity = city;
    _selectedArea = ''; // تفريغ المنطقة لتفادي التعارض
    // تفعيل الفلتر تلقائياً عند تحديد مدينة، وتعطيله إذا تم إلغاؤها
    _isLocationFilterEnabled = city.isNotEmpty;
    _applySearchAndFilter();
  }

  /// 🟢 تحديث area
  void updateArea(String area) {
    _selectedArea = area;
    if (area.isNotEmpty) {
      _isLocationFilterEnabled = true;
    }
    _applySearchAndFilter();
  }

  void clearLocation() {
    _selectedCity = '';
    _selectedArea = '';
    _isLocationFilterEnabled = false; // 👈 مهم جداً: إيقاف الفلتر عند المسح
    _applySearchAndFilter();
  }

  /// 🟢 دالة التبديل (إن احتجتها)
  void toggleLocationFilter() {
    if (_isLocationFilterEnabled) {
      clearLocation(); // عند إيقاف الفلتر نمسح القيم لكي يفتح BottomSheet في المرة القادمة
    }
  }

  /// 🟢 صياغة نص الموقع للعرض
  String getDisplayLocation() {
    List<String> parts = [];
    if (_selectedCity.isNotEmpty) parts.add(_selectedCity);
    if (_selectedArea.isNotEmpty) parts.add(_selectedArea);

    if (parts.isNotEmpty) {
      return parts.join(" - ");
    }
    return "اختر الموقع من القائمة";
  }

  // 🔹 بيانات البحث المحلية (Mock)
  final List<String> _allEvents = [
    'Music Festival',
    'Art Exhibition',
    'Tech Conference',
    'Food Festival',
    'Sports Event',
    'Theatre Show',
    'Comedy Night',
    'Workshop',
    'Concert',
    'Movie Premiere',
    'Dance Performance',
    'Poetry Reading',
    'Book Fair',
    'Science Fair',
    'Cooking Class',
    'Photography Exhibition',
    'Fashion Show',
    'Business Seminar',
    'Health Workshop',
    'Charity Gala',
  ];

  // 🔹 تنفيذ البحث
  Future<void> searchEvents(String query) async {
    _lastQuery = query;
    _applySearchAndFilter();
  }

  // 🟢 دالة لاستقبال النتائج الأولية وتطبيق الفلاتر الحالية عليها
  void setInitialResults(List<ConstantEventModel> initialResults) {
    final filtered = _applyCityAndAreaFilter(initialResults);

    if (filtered.isEmpty) {
      emit(SearchEmpty(query: ''));
    } else {
      emit(SearchLoaded(results: filtered, query: _lastQuery));
    }
  }

  // 🟢 دالة مساعدة لفلترة أي قائمة بـ city و area
  List<ConstantEventModel> _applyCityAndAreaFilter(
    List<ConstantEventModel> list,
  ) {
    return list.where((event) {
      if (_selectedCity.isNotEmpty &&
          event.city.toLowerCase() != _selectedCity.toLowerCase()) {
        return false;
      }
      if (_selectedArea.isNotEmpty &&
          event.area.toLowerCase() != _selectedArea.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  // 🔹 تطبيق الفلترة بالاسم والموقع
  Future<void> _applySearchAndFilter() async {
    // 🟢 1. حساب هل يوجد فلتر موقع مفعل ونشط حالياً
    final bool hasActiveLocationFilter =
        _isLocationFilterEnabled &&
        (_selectedCity.isNotEmpty || _selectedArea.isNotEmpty);

    // 🟢 2. إذا لم يكن هناك نص بحث ولا فلتر موقع مفعل، نرجع حالة فارغة
    if (_lastQuery.trim().isEmpty && !hasActiveLocationFilter) {
      emit(SearchEmpty());
      return;
    }

    emit(SearchLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 200));

      final filtered = _allEvents
          .where(
            (event) =>
                _lastQuery.isEmpty ||
                event.toLowerCase().contains(_lastQuery.toLowerCase()),
          )
          .toList();

      final results =
          List.generate(filtered.length, (index) {
            final name = filtered[index];
            // مدن ومناطق وهمية للتجربة
            final mockCities = ['syria', 'ksa', 'usa', 'uk'];
            final mockAreas = ['damascus', 'riyadh', 'manhatan', 'london'];

            return ConstantEventModel(
              id: 'result_$index',
              name: name,
              accommodation: 100 + index * 50,
              date: DateTime.now().add(Duration(days: index * 7)),
              bookings: const [],
              imageUrl: ['https://picsum.photos/200/200?random=$index'],
              city: mockCities[index % mockCities.length],
              area: mockAreas[index % mockAreas.length],
              type: index % 2 == 0 ? EventType.music : EventType.artistic,
              description: 'Description for $name',
            );
          }).where((event) {
            // 🟢 3. تطبيق فلترة المدينة والمنطقة فقط إذا كان المفتاح مفعلاً (_isLocationFilterEnabled == true)
            if (_isLocationFilterEnabled) {
              if (_selectedCity.isNotEmpty &&
                  event.city.toLowerCase() != _selectedCity.toLowerCase()) {
                return false;
              }
              if (_selectedArea.isNotEmpty &&
                  event.area.toLowerCase() != _selectedArea.toLowerCase()) {
                return false;
              }
            }

            return true; // إذا كان الفلتر معطلاً يُمرر كل العناصر
          }).toList();

      if (results.isEmpty) {
        emit(SearchEmpty(query: _lastQuery));
      } else {
        emit(SearchLoaded(results: results, query: _lastQuery));
      }
    } catch (e) {
      emit(SearchError('Failed to search: $e'));
    }
  }

  List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _allEvents
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void clear() {
    _lastQuery = '';
    emit(SearchInitial());
  }
}
