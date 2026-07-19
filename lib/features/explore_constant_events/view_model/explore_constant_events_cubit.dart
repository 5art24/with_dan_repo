import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:equatable/equatable.dart';

part 'explore_constant_events_state.dart';

class ExploreConstantEventsCubit extends Cubit<ExploreConstantEventsState> {
  ExploreConstantEventsCubit() : super(ExploreConstantEventsInitial());

  // قائمة الفعاليات الكاملة
  final List<ConstantEventModel> _allEvents = _generateSampleEvents();

  // الفعاليات المعروضة بعد الفلترة
  List<ConstantEventModel> _filteredEvents = [];

  // الفلتر المحدد حالياً
  String _selectedCategory = 'All';

  List<ConstantEventModel> get filteredEvents => _filteredEvents;
  String get selectedCategory => _selectedCategory;

  // تحميل البيانات الأولية
  void loadEvents() {
    emit(ExploreConstantEventsLoading());
    try {
      _filteredEvents = List.from(_allEvents);
      emit(ExploreConstantEventsLoaded(_filteredEvents));
    } catch (e) {
      emit(ExploreConstantEventsError(e.toString()));
    }
  }

  // تغيير الفلتر وتحديث الفعاليات
  void filterByCategory(String category) {
    if (_selectedCategory == category) return;

    emit(ExploreConstantEventsLoading());
    _selectedCategory = category;

    if (category == 'All') {
      _filteredEvents = List.from(_allEvents);
    } else {
      // تحويل النص إلى EventType
      final eventType = _getEventTypeFromString(category);
      _filteredEvents = _allEvents
          .where((event) => event.type == eventType)
          .toList();
    }

    emit(ExploreConstantEventsLoaded(_filteredEvents));
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
        return EventType.music; // قيمة افتراضية
    }
  }

  // دالة مساعدة لتوليد بيانات وهمية
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

      return ConstantEventModel(
        id: 'event_$index',
        name: names[index % names.length],
        accommodation: 100 + (index * 50),
        date: DateTime(2026, 12, 20 + index),
        bookings: const [],
        imageUrl: ['https://picsum.photos/seed/${index + 1}/200/200'],
        location: ['New York', 'Los Angeles', 'Chicago', 'Miami'][index % 4],
        type: type,
        description: 'This is a ${type.name} event description...',
      );
    });
  }

  // إضافة فعالية جديدة (للاستخدام المستقبلي)
  void addEvent(ConstantEventModel event) {
    _allEvents.add(event);
    filterByCategory(_selectedCategory);
  }

  // حذف فعالية (للاستخدام المستقبلي)
  void removeEvent(String eventId) {
    _allEvents.removeWhere((event) => event.id == eventId);
    filterByCategory(_selectedCategory);
  }
}
