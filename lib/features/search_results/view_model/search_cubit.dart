// lib/features/search/cubit/search_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/features/search_results/view_model/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

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

  // 🔹 البحث الكامل مع محاكاة API
  Future<void> searchEvents(String query) async {
    if (query.trim().isEmpty) {
      emit(SearchEmpty());
      return;
    }

    emit(SearchLoading());

    try {
      // محاكاة تأخير الـ API
      await Future.delayed(const Duration(milliseconds: 200));

      // محاكاة البحث المحلي
      final filtered = _allEvents
          .where((event) => event.toLowerCase().contains(query.toLowerCase()))
          .toList();

      final results = List.generate(
        filtered.length > 0 ? filtered.length : 0,
        (index) {
          final name = filtered.isNotEmpty
              ? filtered[index % filtered.length]
              : 'No results';
          return ConstantEventModel(
            id: 'result_$index',
            name: name,
            accommodation: 100 + index * 50,
            date: DateTime.now().add(Duration(days: index * 7)),
            bookings: const [],
            imageUrl: ['https://picsum.photos/200/200?random=$index'],
            location: index % 2 == 0 ? 'New York, NY' : 'Los Angeles, CA',
            type: index % 2 == 0 ? EventType.music : EventType.artistic,
            description: 'Description for $name',
          );
        },
      );

      if (results.isEmpty) {
        emit(SearchEmpty(query: query));
      } else {
        emit(SearchLoaded(results: results, query: query));
      }
    } catch (e) {
      emit(SearchError('Failed to search: $e'));
    }
  }

  // 🔹 الحصول على اقتراحات البحث
  List<String> getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _allEvents
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // 🔹 مسح النتائج
  void clear() {
    emit(SearchInitial());
  }
}