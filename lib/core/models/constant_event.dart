import 'package:intl/intl.dart';
import 'package:project1_collage/core/models/base_event.dart';
import 'package:project1_collage/core/models/booking_range.dart';

enum EventType {
  artistic,
  technical,
  cultural,
  comedy,
  educational,
  commercial,
  music,
  workshop,
  fitness,
}

class ConstantEventModel extends BaseEvent {
  final List<String>? imageUrl;
  final EventType type;
  final List<BookingRange>? bookings;
  final int accommodation;
  final double? latitude;
  final double? longitude;

  ConstantEventModel({
    required String id,
    required String name,
    required DateTime date,
    required this.type,
    String? description,
    DateTime? endDate,
    String city = '', // 🟢 تم التعديل: إضافة city كبرامتر اختياري
    String area = '',
    required this.bookings,
    required this.accommodation,
    this.imageUrl,
    this.latitude,
    this.longitude,
  }) : super(
         id: id,
         name: name,
         startDate: date,
         description: description,
         city: city,
         area: area,
         endDate: endDate ?? date,
       );

  factory ConstantEventModel.fromJson(Map<String, dynamic> json) {
    // 🟢 قراءة المدينة والمنطقة بشكل منفصل من JSON
    final parsedCity = json['city']?.toString() ?? '';
    final parsedArea = json['area']?.toString() ?? '';
    return ConstantEventModel(
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
      city: parsedCity, // 🟢 إسناد المدينة
      area: parsedArea, // 🟢 إسناد المنطقة
      type: _parseEventType(json['category'] ?? json['type']),
      bookings: json['bookings'] != null
          ? (json['bookings'] as List)
                .map((e) => BookingRange.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      accommodation: (json['accommodation'] as num?)?.toInt() ?? 0,
      imageUrl: _parseImageUrls(
        json['main_image'] ?? json['imageUrl'] ?? json['images'],
      ),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  static EventType _parseEventType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'artistic':
        return EventType.artistic;
      case 'technical':
        return EventType.technical;
      case 'cultural':
        return EventType.cultural;
      case 'comedy':
        return EventType.comedy;
      case 'educational':
        return EventType.educational;
      case 'commercial':
        return EventType.commercial;
      case 'music':
        return EventType.music;
      case 'workshop':
        return EventType.workshop;
      case 'fitness':
        return EventType.fitness;
      default:
        return EventType.cultural;
    }
  }

  // دالة مساعدة للتعامل مع روابط الصور سواء كانت String واحدة أو List
  static List<String>? _parseImageUrls(dynamic imageData) {
    if (imageData == null) return null;
    if (imageData is List) {
      return imageData.map((e) => e.toString()).toList();
    }
    if (imageData is String) {
      return [imageData];
    }
    return null;
  }

  String get location {
    if (area.isNotEmpty && city.isNotEmpty) {
      return '$city - $area';
    }
    return city.isNotEmpty ? city : area;
  }

  String get formattedDateTime {
    String dayDate = DateFormat('E, MMM d').format(startDate);
    return "$dayDate • 18:00 - 23:00 PM";
  }
}
