// core/models/service_provider_user.dart
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/user.dart';

class ServiceProviderUser extends User {
  final List<ServiceModel> _services;

  List<ServiceModel> get services => List.unmodifiable(_services);

  ServiceProviderUser({
    required super.id,
    required super.username,
    required super.urlImage,
    super.phoneNumber,
    super.workOrStudy,
    super.isVerified,
    List<ServiceModel>? services,
  }) : _services = services ?? [];

  factory ServiceProviderUser.fromJson(Map<String, dynamic> json) {
    return ServiceProviderUser(
      id: json['userId'] ?? '',
      username: json['user_name'] ?? '',
      urlImage: json['profile_image'] ?? '',
      phoneNumber: json['phone_number'],
      workOrStudy: json['work_or_study'],
      isVerified: json['is_verified'] ?? false,
      services: json['services'] != null
          ? (json['services'] as List)
              .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  @override
  ServiceProviderUser copyWith({
    String? id,
    String? username,
    String? urlImage,
    String? phoneNumber,
    String? workOrStudy,
    bool? isVerified,
    List<ServiceModel>? services,
  }) {
    return ServiceProviderUser(
      id: id ?? this.id,
      username: username ?? this.username,
      urlImage: urlImage ?? this.urlImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workOrStudy: workOrStudy ?? this.workOrStudy,
      isVerified: isVerified ?? this.isVerified,
      services: services ?? _services,
    );
  }

  ServiceProviderUser addingService(ServiceModel service) =>
      copyWith(services: [..._services, service]);

  ServiceProviderUser removingService(String serviceId) => copyWith(
        services: _services.where((s) => s.id != serviceId).toList(),
      );
}