import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/base_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/task.dart';

class PersonalEvent extends BaseEvent {
  final String category;
  final List<ServiceModel> bookedServices;
  final List<TaskModel> tasks;

  PersonalEvent({
    required String id,
    required String name,
    required DateTime date,
    String? description,
    required this.category,
    DateTime? endDate,
    this.bookedServices = const [],
    this.tasks = const [],
    String? city,
    String? area,
  }) : super(
         id: id,
         name: name,
         startDate: date,
         description: description,
         city: city ?? '',
         area: area ?? '',
         endDate: endDate ?? date,
       );

  PersonalEvent copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    DateTime? date,
    List<ServiceModel>? bookedServices,
    List<TaskModel>? tasks,
    DateTime? endDate,
    String? city,
    String? area,
  }) {
    return PersonalEvent(
      id: id ?? this.id,
      name: name ?? this.name,
      endDate: endDate ?? this.endDate,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.startDate,
      tasks: tasks ?? this.tasks,
      bookedServices: bookedServices ?? this.bookedServices,
      city: city ?? this.city,
      area: area ?? this.area,
    );
  }

  IconData get icon {
    switch (category) {
      case 'wedding':
        return Icons.favorite;
      case 'birthday':
        return Icons.cake;
      case 'party':
        return Icons.celebration;
      case 'meeting':
        return Icons.meeting_room;
      default:
        return Icons.event_note;
    }
  }

  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isDone).length;
    return completed / tasks.length;
  }

  String get location =>
      area.isNotEmpty ? "$city $area".trim() : "لم يتم تحديد المنطقة بعد";
  bool get hasValidLocation => area.isNotEmpty;
  factory PersonalEvent.fromJson(Map<String, dynamic> json) {
    return PersonalEvent(
      id: (json['eventId'] ?? json['id'])?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      date: json['event_date'] != null
          ? DateTime.parse(json['event_date'])
          : (json['date'] != null
                ? DateTime.parse(json['date'])
                : DateTime.now()),
      endDate:
          json['event_end_date'] !=
              null // 🆕
          ? DateTime.parse(json['event_end_date'])
          : (json['end_date'] != null
                ? DateTime.parse(json['end_date'])
                : null),
      description: json['description'],

      category: json['category'] ?? '',
      area: json['area'],
      bookedServices: json['booked_services'] != null
          ? (json['booked_services'] as List)
                .map((e) => ServiceModel.fromJson(e))
                .toList()
          : [],
      tasks: json['tasks'] != null
          ? (json['tasks'] as List).map((e) => TaskModel.fromJson(e)).toList()
          : [],
    );
  }

  int get tasksCount => tasks.length;
  int get completedTasksCount => tasks.where((t) => t.isDone).length;
}
