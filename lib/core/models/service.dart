import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/models/user.dart';

class ServiceModel {
  final String id;
  final String name;
  final List<String>? imageUrl;
  final double rating;
  final int price;
  final String location;
  final int? capacity;
  final ServiceType type;
  final String? description;
  final User provider;
  final List<BookingRange>? bookings;
  final int preparationDays;
  final bool isFavorite;

  ServiceModel( {
     this.isFavorite=false,
    required this.bookings,
    required this.provider,
    required this.id,
    required this.name,
    required this.imageUrl,
    this.rating = 0.0,
    required this.price,
    required this.location,
    this.capacity,
    required this.type,
    required this.description,
    this.preparationDays = 0,
  });
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: (json['servId'] ?? json['id'])?.toString() ?? '',
      name: json['title'] ?? json['name'] ?? '',
      imageUrl: _parseImageUrls(json['main_image'] ?? json['imageUrl']),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: (json['price_per_day'] ?? json['price'] as num?)?.toInt() ?? 0,
      location: json['location'] ?? json['area'] ?? '',
      capacity: json['capacity'],
      type: _parseServiceType(json['category'] ?? json['type']),
      description: json['description'],
      provider: json['provider'] != null 
          ? User.fromJson(json['provider']) 
          : User(id: json['userId']?.toString() ?? '', username: '', urlImage: ''),
      bookings: json['bookings'] != null
          ? (json['bookings'] as List)
              .map((e) => BookingRange.fromJson(e))
              .toList()
          : null,
      preparationDays: json['preparation_days'] ?? json['preparationDays'] ?? 0,
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
    );
  }
  // دالة مساعدة لتحويل النصوص إلى ServiceType Enum
  static ServiceType _parseServiceType(String? typeStr) {
    switch (typeStr?.toLowerCase()) {
      case 'venue':
        return ServiceType.venue;
      case 'dj':
        return ServiceType.dj;
      case 'decor':
        return ServiceType.decor;
      case 'photograph':
      case 'photography':
        return ServiceType.photograph;
      case 'lighting':
        return ServiceType.lighting;
      default:
        return ServiceType.none;
    }
  }
  /// يتحقق هل الخدمة متاحة لفترة فعالية كاملة (من startDate لـ endDate)
  /// مع الأخذ بعين الاعتبار أيام التجهيز المطلوبة قبل بداية الفعالية
  bool isAvailableForEvent({
    required DateTime eventStartDate,
    DateTime? eventEndDate,
  }) {
    final effectiveEnd = eventEndDate ?? eventStartDate;

    final daysToCheck = <DateTime>[];

    // كل أيام مدة الفعالية (وليس يوم البداية فقط)
    for (
      DateTime day = eventStartDate;
      !day.isAfter(effectiveEnd);
      day = day.add(const Duration(days: 1))
    ) {
      daysToCheck.add(day);
    }

    // أيام التجهيز المطلوبة قبل بداية الفعالية (يوم تجهيز = يوم لازم يكون فاضي)
    for (int i = 1; i <= preparationDays; i++) {
      daysToCheck.add(eventStartDate.subtract(Duration(days: i)));
    }

    for (final day in daysToCheck) {
      for (final booking in bookings ?? const []) {
        if (booking.contains(day)) {
          return false;
        }
      }
    }
    return true;
  }

  // دالة مساعدة لمعالجة رابط أو قائمة الصور
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
}

enum ServiceType { none, venue, dj, decor, photograph, lighting }

enum FilterType { none, topRated, minPrice }
