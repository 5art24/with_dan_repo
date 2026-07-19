// import 'package:intl/intl.dart';
// import 'package:project1_collage/core/models/booking_range.dart';
// import 'package:project1_collage/core/models/user.dart';
// enum EventType {
//   artistic,
//   technical,
//   cultural,
//   comedy,
//   educational,
//   commercial,
//   music,     // تم إضافة الأنواع الإضافية لتطابق التصميم
//   workshop,
//   fitness,
// }
// class ConstantEventModel {
//   final String id;
//   final String name;
//   final List<String>? imageUrl;
//   final String location;
//   final EventType type;
//   final DateTime date;
//   final String? description;
//   final List<BookingRange>? bookings;
//   final int accommodation;
//   // إحداثيات الخريطة المطلوبة لعرض موقع المكان
//   final double? latitude;
//   final double? longitude;
  
//   // // خاصية إضافية لتسهيل الإعجاب بالحدث (Heart Icon)
//   // final bool isFavorite;

//   ConstantEventModel( {
//     required this.accommodation,
//     required this.date,
//     required this.bookings,
//     required this.id,
//     required this.name,
//     required this.imageUrl,
//     required this.location,
//     required this.type,
//     required this.description,
//     this.latitude,
//     this.longitude,
//     // this.isFavorite = false,
//   });
//   // دالة مساعدة لتنسيق الوقت والتاريخ المعروض على البطاقات
//   String get formattedDateTime {
//     // مثال: Mon, Dec 24
//     String dayDate = DateFormat('E, MMM d').format(date);
//     // وقت افتراضي أو يمكنك حسابه من الـ bookings إذا أردت ديناميكية كاملة
//     return "$dayDate • 18:00 - 23:00 PM"; 
//   }
// }

// lib/core/models/constant_event.dart
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
  final String location;
  final EventType type;
  final List<BookingRange>? bookings;
  final int accommodation;
  final double? latitude;
  final double? longitude;

  ConstantEventModel({
    required String id,
    required String name,
    required DateTime date,
    required this.location,
    required this.type,
    String? description,
    required this.bookings,
    required this.accommodation,
    this.imageUrl,
    this.latitude,
    this.longitude,
  }) : super(id: id, name: name, date: date,description: description);

  String get formattedDateTime {
    String dayDate = DateFormat('E, MMM d').format(date);
    return "$dayDate • 18:00 - 23:00 PM";
  }
}