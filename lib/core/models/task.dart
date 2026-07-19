// core/models/task_model.dart
import 'package:flutter/material.dart';


class TaskModel {
  final String id;
  final String title;
  final bool isDone;
  final DateTime dateTime;
  final int priority;
  final String eventId;
  final String eventTitle;

 TaskModel({
    this.eventTitle = '',
    required this.eventId,
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? dateTime, // ✅ تغيير النوع إلى nullable
    this.priority = 3,
  }) : dateTime = dateTime ?? DateTime.now(); 

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

  TaskModel copyWith({
    String? eventId,
    String? id,
    String? title,
    bool? isDone,
    DateTime? dateTime,
    int? priority,
    String? eventTitle,
  }) {
    return TaskModel(
      eventId: eventId ?? this.eventId,
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      eventTitle: eventTitle ?? this.eventTitle,
    );
  }
}