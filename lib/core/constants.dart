import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/user.dart';
import 'package:project1_collage/features/planning_event/models/service_item.dart';

enum Category { wedding, cultural, birthday, artistic }

// core/constants/app_constants.dart
class AppConstants {
  
  static const Map<String, List<String>> cityAreaMap = {
    "syria":["damascus"],
    "ksa":["riyadh"],
    "usa":["manhatan"],
    "uk":["london"],
    "سوريا": ["دمشق", "حلب", "اللاذقية", "حمص", "حماة", "طرطوس"],
    "السعودية": ["الرياض", "جدة", "مكة المكرمة", "الدمام", "المدينة المنورة"],
    "الإمارات": ["دبي", "أبوظبي", "الشارقة", "العين"],
    "مصر": ["القاهرة", "الإسكندرية", "الجيزة"],
    "الأردن": ["عمان", "إربد", "الزرقاء"],
  };
  
  static final List<ServiceItem> allServices = [
    ServiceItem(
      service: ServiceModel(
        bookings: // الحالة الأولى: حجز نطاق أيام متصلة (من 16 مارس إلى 20 مارس)
        [
          BookingRange(
            startDate: DateTime(2026, 3, 16),
            endDate: DateTime(2026, 3, 20),
          ),

          // الحالة الثانية: حجز يوم واحد منفرد (يوم 10 مارس فقط)
          BookingRange(
            startDate: DateTime(2026, 3, 10),
            endDate: DateTime(2026, 3, 10), // البداية والنهاية نفس اليوم
          ),
        ],
        name: "Lighting",
        price: 200,
        id: '',
        imageUrl: [''],
        rating: 5.0,
        location: '',
        preparationDays: 2,
        capacity: null,
        type: ServiceType.lighting,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',
        provider: User(
          username: 'user1',
          urlImage:
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop", id: '',
        ),
      ),
      icon: "assets/icons/lighting.png",
    ),
    ServiceItem(
      service: ServiceModel(
        bookings: // الحالة الأولى: حجز نطاق أيام متصلة (من 16 مارس إلى 20 مارس)
        [
          BookingRange(
            startDate: DateTime(2026, 3, 16),
            endDate: DateTime(2026, 3, 20),
          ),

          // الحالة الثانية: حجز يوم واحد منفرد (يوم 10 مارس فقط)
          BookingRange(
            startDate: DateTime(2026, 3, 10),
            endDate: DateTime(2026, 3, 10), // البداية والنهاية نفس اليوم
          ),
        ],
        name: "Photograph",
        price: 300,
        id: '',
        imageUrl: [''],
        rating: 5.0,
        location: '',
        capacity: null,
        type: ServiceType.photograph,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',
        provider: User(
          username: 'user1',
          urlImage:
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop", id: '',
        ),
      ),
      icon: "assets/icons/photograph.png",
    ),
    ServiceItem(
      service: ServiceModel(
        bookings: // الحالة الأولى: حجز نطاق أيام متصلة (من 16 مارس إلى 20 مارس)
        [
          BookingRange(
            startDate: DateTime(2026, 3, 16),
            endDate: DateTime(2026, 3, 20),
          ),

          // الحالة الثانية: حجز يوم واحد منفرد (يوم 10 مارس فقط)
          BookingRange(
            startDate: DateTime(2026, 3, 10),
            endDate: DateTime(2026, 3, 10), // البداية والنهاية نفس اليوم
          ),
        ],
        name: "Dj",
        price: 400,
        id: '',
        imageUrl: [''],
        rating: 5.0,
        location: '',
        capacity: null,
        type: ServiceType.dj,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',

        provider: User(
          username: 'user1',
          urlImage:
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop", id: '',
        ),
      ),
      icon: "assets/icons/dj.png",
    ),
    ServiceItem(
      service: ServiceModel(
        name: "Venue",
        price: 500,
        id: '',
        bookings: // الحالة الأولى: حجز نطاق أيام متصلة (من 16 مارس إلى 20 مارس)
        [
          BookingRange(
            startDate: DateTime(2026, 3, 16),
            endDate: DateTime(2026, 3, 20),
          ),

          // الحالة الثانية: حجز يوم واحد منفرد (يوم 10 مارس فقط)
          BookingRange(
            startDate: DateTime(2026, 3, 10),
            endDate: DateTime(2026, 3, 10), // البداية والنهاية نفس اليوم
          ),
        ],
        imageUrl: [''],
        rating: 5.0,
        location: '',
        capacity: null,
        type: ServiceType.venue,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',

        provider: User(
          username: 'user1',
          urlImage:
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop", id: '',
        ),
      ),
      icon: "assets/icons/venue.png",
    ),
    ServiceItem(
      icon: "assets/icons/decor.png",
      service: ServiceModel(
        name: "Decor",
        price: 350,
        id: '',
        bookings: // الحالة الأولى: حجز نطاق أيام متصلة (من 16 مارس إلى 20 مارس)
        [
          BookingRange(
            startDate: DateTime(2026, 3, 16),
            endDate: DateTime(2026, 3, 20),
          ),

          // الحالة الثانية: حجز يوم واحد منفرد (يوم 10 مارس فقط)
          BookingRange(
            startDate: DateTime(2026, 3, 10),
            endDate: DateTime(2026, 3, 10), // البداية والنهاية نفس اليوم
          ),
        ],
        imageUrl: [''],
        rating: 5.0,
        location: '',
        capacity: null,
        type: ServiceType.decor,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',

        provider: User(
          username: 'user1',
          urlImage:
              "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop", id: '',
        ),
      ),
    ),
  ];
}
