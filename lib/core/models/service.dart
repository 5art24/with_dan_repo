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
}

enum ServiceType { none, venue, dj, decor, photograph, lighting }

enum FilterType { none, topRated, minPrice }
