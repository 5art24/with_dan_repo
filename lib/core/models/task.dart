// core/models/task_model.dart
import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isDone;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final int priority;
  final String eventId;
  final String eventTitle;

  TaskModel({
    this.eventTitle = '',
    required this.eventId,
    required this.id,
    required this.title,
    DateTime? endDateTime,
    this.isDone = false,
    DateTime? dateTime, // ✅ تغيير النوع إلى nullable
    this.priority = 3,
  }) : startDateTime = dateTime ?? DateTime.now(),
       endDateTime = endDateTime ?? DateTime.now();

  // كبسولة الـ Priority لعرض نصوص متوافقة
  String get priorityString {
    switch (priority) {
      case 1:
        return 'High';
      case 2:
        return 'Medium';
      case 3:
      default:
        return 'Normal';
    }
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: (json['taskId'] ?? json['id'])?.toString() ?? '',
      title: json['task_name'] ?? json['title'] ?? '',
      // التعامل مع bool أو int (0/1) القادم من قواعد البيانات
      isDone:
          json['is_completed'] == true ||
          json['is_completed'] == 1 ||
          json['isDone'] == true,
      dateTime:
          json['due_date'] !=
              null //see
          ? DateTime.tryParse(json['due_date'])
          : (json['dateTime'] != null
                ? DateTime.tryParse(json['dateTime'])
                : null),
      priority: json['priority'] ?? 3,
      eventId: (json['eventId'] ?? json['event_id'])?.toString() ?? '',
      eventTitle: json['eventTitle'] ?? json['event_title'] ?? '',
    );
  }

  TaskModel copyWith({
    String? eventId,
    String? id,
    String? title,
    bool? isDone,
    DateTime? dateTime,
    DateTime? endDateTime, // 🆕
    int? priority,
    String? eventTitle,
  }) {
    return TaskModel(
      eventId: eventId ?? this.eventId,
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dateTime: dateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime, // 🆕
      priority: priority ?? this.priority,
      eventTitle: eventTitle ?? this.eventTitle,
    );
  }
}
