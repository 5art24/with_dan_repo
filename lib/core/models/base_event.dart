// lib/core/models/base_event.dart
abstract class BaseEvent {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;
  final String city; // 🏙️ اسم المحافظة/المدينة (مثل: دمشق، الرياض)
  final String area;

  BaseEvent({
    required this.id,
    required this.name,
    required this.startDate,
    DateTime? endDate,
    this.city = '',
    this.area = '',
    this.description,
  }): endDate = endDate ?? startDate ;
}
