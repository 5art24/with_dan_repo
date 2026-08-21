import 'package:project1_collage/core/models/service.dart';

class FavoriteModel {
  final String favoritesId;
  final String userId;
  final String serviceId;
  final ServiceModel? service; // كائن الخدمة المحمل لتسهيل العرض في واجهة المفضلة

  FavoriteModel({
    required this.favoritesId,
    required this.userId,
    required this.serviceId,
    this.service,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      favoritesId: json['favoritesID']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString() ?? '',
      service: json['service'] != null ? ServiceModel.fromJson(json['service']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoritesID': favoritesId,
      'user_id': userId,
      'service_id': serviceId,
    };
  }
}