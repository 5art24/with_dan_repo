
import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/base_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/task.dart';

class PersonalEvent extends BaseEvent {
  final String category;
  final List<ServiceModel> bookedServices;
  final List<TaskModel> tasks;
  final String? locationType;
  final String? selectedVenue;
  final String? gpsAddress;
  final double? latitude;  
  final double? longitude;

  PersonalEvent({
    required String id,
    required String name,
    required DateTime date,
    String? description,
    required this.category,
    this.bookedServices = const [],
    this.tasks = const [],
    this.locationType,
    this.selectedVenue,
    this.gpsAddress,
    this.latitude,
    this.longitude,
  }) : super(id: id, name: name, date: date,description: description);

  String get location {
    if (locationType == "Venue You Choose") {
      return selectedVenue ?? "لم يتم اختيار صالة بعد";
    } else if (locationType == "Place You Choose by GPS") {
      return gpsAddress ?? "لم يتم تحديد موقع GPS بعد";
    }
    return "لم يتم اختيار موقع بعد";
  }

  bool get hasValidLocation {
    if (locationType == "Venue You Choose") {
      return selectedVenue != null && selectedVenue!.isNotEmpty;
    } else if (locationType == "Place You Choose by GPS") {
      return gpsAddress != null && gpsAddress!.isNotEmpty;
    }
    return false;
  }

  PersonalEvent copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    DateTime? date,
    List<ServiceModel>? bookedServices,
    List<TaskModel>? tasks,
    String? locationType,
    String? selectedVenue,
    String? gpsAddress,
    double? latitude,
    double? longitude,
  }) {
    return PersonalEvent(
      description: description?? this.description,
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      date: date ?? this.date,
      tasks: tasks ?? this.tasks,
      bookedServices: bookedServices ?? this.bookedServices,
      locationType: locationType ?? this.locationType,
      selectedVenue: selectedVenue ?? this.selectedVenue,
      gpsAddress: gpsAddress ?? this.gpsAddress,
           latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  IconData get icon {
    switch (category) {
      case 'wedding': return Icons.favorite;
      case 'birthday': return Icons.cake;
      case 'party': return Icons.celebration;
      case 'meeting': return Icons.meeting_room;
      default: return Icons.event_note;
    }
  }
  double get progress {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((t) => t.isDone).length;
    return completed / tasks.length;
  }

  
  int get tasksCount => tasks.length;
  int get completedTasksCount => tasks.where((t) => t.isDone).length;

   // دالة لمسح الموقع عند تغيير نوع الموقع
  PersonalEvent clearLocation() {
    return copyWith(
      selectedVenue: null,
      gpsAddress: null,
      latitude: null,
      longitude: null,
    );
  }
}