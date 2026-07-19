import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/user.dart';

class MockServices {
  static final List<ServiceModel> lightings = [
    ServiceModel(
      name: "Lighting",
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 6, 15),
          endDate: DateTime(2026, 6, 15),
        ),
        BookingRange(
          startDate: DateTime(2026, 6, 20),
          endDate: DateTime(2026, 6, 25),
        ),
        BookingRange(
          startDate: DateTime(2026, 7, 12),
          endDate: DateTime(2026, 7, 25),
        ),
      ],
      price: 200,
      id: '',
      imageUrl: [
        'https://picsum.photos/400/250',
        'https://picsum.photos/id/1015/400/300',
        'https://picsum.photos/id/104/400/300',
        'https://picsum.photos/id/106/400/300',
        'https://picsum.photos/id/155/400/300',
      ],
      rating: 3.0,
      location: 'Syria',
      capacity: null,
      type: ServiceType.lighting,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut... ',
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
    ),
    ServiceModel(
      id: '',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: "hi900,4",
      imageUrl: null,
      rating: 4.0,
      price: 900,
      location: "Syria",
      type: ServiceType.lighting,
      description: "description",
      provider: User(
        username: 'user2',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
    ),
    ServiceModel(
      id: '',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: "hi700,5",
      imageUrl: null,
      rating: 5.0,
      price: 700,
      location: "Syria",
      type: ServiceType.lighting,
      description: "description",
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
    ),
  ];

  static final List<ServiceModel> allServices = [
    // صالات (Venues)
    ServiceModel(
      id: '1',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'قصر الأفراح الفاخر',
      imageUrl: ['https://picsum.photos/id/106/400/300'],
      rating: 4.9,
      price: 5000,
      location: 'الرياض - حي النخيل',
      capacity: 300,
      type: ServiceType.venue,
      description: 'قصر فاخر مع حدائق ومواقف سيارات واسعة',
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
    ),
    ServiceModel(
      id: '2',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'صالة النورس',
      imageUrl: ['https://picsum.photos/id/96/400/300'],
      rating: 4.7,
      price: 3500,
      location: 'جدة - كورنيش',
      capacity: 200,
      type: ServiceType.venue,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      description: 'إطلالة بحرية ساحرة',
    ),
    ServiceModel(
      id: '3',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'قصر البيلسان',
      imageUrl: ['https://picsum.photos/id/30/400/300'],
      rating: 5.0,
      price: 8000,
      location: 'الدمام - حي لبن',
      capacity: 500,
      type: ServiceType.venue,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      description: 'أفخم القاعات مع خدمات راقية',
    ),
    ServiceModel(
      id: '4',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'صالة الزهور',
      imageUrl: ['https://picsum.photos/id/20/400/300'],
      rating: 4.3,
      price: 2800,
      location: 'مكة - العزيزية',
      capacity: 150,
      type: ServiceType.venue,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      description: 'ديكورات زهور طبيعية',
    ),
    // DJs
    ServiceModel(
      id: '7',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'DJ Cosmic',
      imageUrl: ['https://picsum.photos/id/145/400/300'],
      rating: 4.8,
      price: 2000,
      location: 'الرياض',
      capacity: 0,
      type: ServiceType.dj,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      description: 'متخصص في الأعراس والحفلات',
    ),
    ServiceModel(
      id: '8',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'DJ Pulse',
      imageUrl: ['https://picsum.photos/id/147/400/300'],
      rating: 4.6,
      price: 1800,
      location: 'جدة',
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      capacity: 0,
      type: ServiceType.dj,
      description: 'موسيقى حديثة وإضاءة',
    ),
    ServiceModel(
      id: '9',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'DJ Echo',
      imageUrl: ['https://picsum.photos/id/29/400/300'],
      rating: 4.9,
      price: 2500,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      location: 'الدمام',
      capacity: 0,
      type: ServiceType.dj,
      description: 'خبرة 10 سنوات',
    ),
    ServiceModel(
      id: '10',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'DJ Moon',
      imageUrl: ['https://picsum.photos/id/76/400/300'],
      rating: 4.7,
      price: 2200,
      location: 'مكة',
      capacity: 0,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      type: ServiceType.dj,
      description: 'أجواء هادئة ومناسبة',
    ),
    // ديكور
    ServiceModel(
      id: '11',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'ديكورات رويال',
      imageUrl: ['https://picsum.photos/id/72/400/300'],
      rating: 4.9,
      price: 3000,
      location: 'الرياض',
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      capacity: 0,
      type: ServiceType.decor,
      description: 'ديكورات فاخرة',
    ),
    ServiceModel(
      id: '12',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'زهور وأضواء',
      imageUrl: ['https://picsum.photos/id/58/400/300'],
      rating: 4.7,
      price: 2500,
      location: 'جدة',
      capacity: 0,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      type: ServiceType.decor,
      description: 'تنسيق زهور وإضاءة',
    ),
    ServiceModel(
      id: '13',
      bookings: [
        BookingRange(
          startDate: DateTime(2026, 3, 16),
          endDate: DateTime(2026, 3, 20),
        ),
        BookingRange(
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 10),
        ),
      ],
      name: 'ديكور ليلي',
      imageUrl: ['https://picsum.photos/id/43/400/300'],
      rating: 4.8,
      price: 3500,
      location: 'الخبر',
      capacity: 0,
      provider: User(
        username: 'user1',
        urlImage:
            "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
      ),
      type: ServiceType.decor,
      description: 'إضاءة مبتكرة وديكورات عصرية',
    ),
  ];
}