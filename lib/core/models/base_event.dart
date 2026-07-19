// lib/core/models/base_event.dart
abstract class BaseEvent {
  final String id;
  final String name;
  final DateTime date;
  final String? description;

  BaseEvent({
    required this.id,
    required this.name,
    required this.date,
    this.description,
  });
}