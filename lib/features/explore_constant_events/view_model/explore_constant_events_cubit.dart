import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:equatable/equatable.dart';

part 'explore_constant_events_state.dart';

class ExploreConstantEventsCubit extends Cubit<ExploreConstantEventsState> {
  ExploreConstantEventsCubit() : super(ExploreConstantEventsInitial());

  // قائمة الفعاليات الكاملة
  final List<ConstantEventModel> _allEvents = _generateSampleEvents();

  // الفعاليات المعروضة في شبكة التصنيفات (Categories Grid)
  List<ConstantEventModel> _filteredEvents = [];

  // قائمة فعاليات Happening Soon (مفلترة بالموقع والتاريخ فقط)
  List<ConstantEventModel> _happeningSoonEvents = [];

  // الفلاتر المحددة
  String _selectedCategory = 'All';
  String _selectedCity = '';
  String _selectedArea = '';

  List<ConstantEventModel> get filteredEvents => _filteredEvents;
  List<ConstantEventModel> get happeningSoonEvents => _happeningSoonEvents;

  String get selectedCategory => _selectedCategory;
  String get selectedCity => _selectedCity;
  String get selectedArea => _selectedArea;

  /// 🟢 تحميل البيانات أول مرة (يفلتر القائمتين معاً)
  void loadEvents() {
    emit(ExploreConstantEventsLoading());
    try {
      _filterHappeningSoon();
      _filterCategoryEvents();

      // 🟢 إرسال القائمتين في الحالة
      emit(
        ExploreConstantEventsLoaded(
          categoryEvents: _filteredEvents,
          happeningSoonEvents: _happeningSoonEvents,
        ),
      );
    } catch (e) {
      emit(ExploreConstantEventsError(e.toString()));
    }
  }

  /// ⚡ [تحسين الأداء]: عند تغيير التصنيف فقط -> يُعيد فلترة الفعاليات المصنفة دون مساس بـ Happening Soon
  void filterByCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;

    emit(ExploreConstantEventsLoading());
    try {
      _filterCategoryEvents(); // تنفيـذ سريـع جداً (بدون ترتيب Happening Soon)
      emit(
        ExploreConstantEventsLoaded(
          categoryEvents: _filteredEvents,
          happeningSoonEvents: _happeningSoonEvents,
        ),
      );
    } catch (e) {
      emit(ExploreConstantEventsError(e.toString()));
    }
  }

  /// 🟢 عند تغيير الموقع -> يُعيد فلترة القائمتين لأن الموقع يؤثر على كليهما
  void updateLocation(String city, String area) {
    _selectedCity = city;
    _selectedArea = area;

    emit(ExploreConstantEventsLoading());
    try {
      _filterHappeningSoon();
      _filterCategoryEvents();
      emit(
        ExploreConstantEventsLoaded(
          categoryEvents: _filteredEvents,
          happeningSoonEvents: _happeningSoonEvents,
        ),
      );
    } catch (e) {
      emit(ExploreConstantEventsError(e.toString()));
    }
  }

  // ========================================================================
  // 🟢 1. دالة مستقلة لفلترة وترتيب Happening Soon (تعتمد على الموقع والتاريخ فقط)
  // ========================================================================
  void _filterHappeningSoon() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _happeningSoonEvents =
        _allEvents.where((event) {
            // شرط التاريخ
            bool isFutureOrToday = !event.startDate.isBefore(today);

            // شرط المدينة والمنطقة
            bool matchesCity =
                _selectedCity.isEmpty ||
                event.city.toLowerCase().contains(_selectedCity.toLowerCase());

            bool matchesArea =
                _selectedArea.isEmpty ||
                event.area.toLowerCase().contains(_selectedArea.toLowerCase());

            return isFutureOrToday && matchesCity && matchesArea;
          }).toList()
          ..sort((a, b) => a.startDate.compareTo(b.startDate)); // ترتيب تصاعدي
  }

  // ========================================================================
  // 🟢 2. دالة مستقلة لفلترة قائمة التصنيفات (تعتمد على التصنيف والموقع)
  // ========================================================================
  void _filterCategoryEvents() {
    _filteredEvents = _allEvents.where((event) {
      // شرط التصنيف
      bool matchesCategory = true;
      if (_selectedCategory != 'All') {
        final eventType = _getEventTypeFromString(_selectedCategory);
        matchesCategory = (event.type == eventType);
      }

      // شرط المدينة والمنطقة
      bool matchesCity =
          _selectedCity.isEmpty ||
          event.city.toLowerCase().contains(_selectedCity.toLowerCase());

      bool matchesArea =
          _selectedArea.isEmpty ||
          event.area.toLowerCase().contains(_selectedArea.toLowerCase());

      return matchesCategory && matchesCity && matchesArea;
    }).toList();
  }

  // تحويل النص إلى EventType
  EventType _getEventTypeFromString(String category) {
    switch (category.toLowerCase()) {
      case 'music':
        return EventType.music;
      case 'art':
        return EventType.artistic;
      case 'workshop':
        return EventType.workshop;
      default:
        return EventType.music;
    }
  }

  static List<ConstantEventModel> _generateSampleEvents() {
    return List.generate(12, (index) {
      final types = [EventType.music, EventType.artistic, EventType.workshop];
      final type = types[index % types.length];
      final names = [
        'Music Festival',
        'Art Exhibition',
        'Photography Workshop',
        'Jazz Concert',
        'Painting Class',
        'Coding Workshop',
        'Rock Concert',
        'Sculpture Exhibition',
        'Writing Workshop',
        'Classical Music',
        'Digital Art',
        'Design Workshop',
      ];
      final mockCities = ['syria', 'ksa', 'usa', 'uk'];
      final mockAreas = ['damascus', 'riyadh', 'manhatan', 'london'];
      return ConstantEventModel(
        id: 'event_$index',
        name: names[index % names.length],
        accommodation: 100 + (index * 50),
        date: DateTime(2026, 12, 20 + index),
        bookings: const [],
        imageUrl: ['https://picsum.photos/seed/${index + 1}/200/200'],
        city: mockCities[index % mockCities.length],
        area: mockAreas[index % mockAreas.length],
        type: type,
        description: 'This is a ${type.name} event description...',
      );
    });
  }

  void addEvent(ConstantEventModel event) {
    _allEvents.add(event);
    loadEvents();
  }

  void removeEvent(String eventId) {
    _allEvents.removeWhere((event) => event.id == eventId);
    loadEvents();
  }
}
