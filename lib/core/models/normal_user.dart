// core/models/regular_NormalUser.dart
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/user.dart';

class NormalUser extends User {
  final List<PersonalEvent> _personalEvents;
  final List<ConstantEventModel> _constantEvents;
  final List<ServiceModel> _favoriteServices;

  List<PersonalEvent> get personalEvents => List.unmodifiable(_personalEvents);
  List<ConstantEventModel> get constantEvents =>
      List.unmodifiable(_constantEvents);
      List<ServiceModel> get favoriteServices => List.unmodifiable(_favoriteServices);

  NormalUser({
    required super.id,
    required super.username,
    required super.urlImage,
    super.phoneNumber,
    super.workOrStudy,
    super.isVerified,
    List<PersonalEvent>? personalEvents,
    List<ConstantEventModel>? constantEvents,
    List<ServiceModel>? favoriteServices,
  }) : _personalEvents = personalEvents ?? [],
       _constantEvents = constantEvents ?? [],
       _favoriteServices = favoriteServices ?? [];

  factory NormalUser.fromJson(Map<String, dynamic> json) {
    return NormalUser(
      id: json['userId'] ?? '',
      username: json['user_name'] ?? '',
      urlImage: json['profile_image'] ?? '',
      phoneNumber: json['phone_number'],
      workOrStudy: json['work_or_study'],
      isVerified: json['is_verified'] ?? false,
      constantEvents: json['constant_events'] != null
          ? (json['constant_events'] as List)
                .map(
                  (e) => ConstantEventModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : [],
      personalEvents: json['personal_events'] != null
          ? (json['personal_events'] as List)
                .map((e) => PersonalEvent.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],favoriteServices: json['favorites'] != null
          ? (json['favorites'] as List)
              .map((e) => ServiceModel.fromJson(e['service'] ?? e))
              .toList()
          : [],
    );
  }

  @override
  NormalUser copyWith({
    String? id,
    String? username,
    String? urlImage,
    String? phoneNumber,
    String? workOrStudy,
    bool? isVerified,
    List<PersonalEvent>? personalEvents,
    List<ConstantEventModel>? constantEvents,
    List<ServiceModel>? favoriteServices,
  }) {
    return NormalUser(
      id: id ?? this.id,
      username: username ?? this.username,
      urlImage: urlImage ?? this.urlImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workOrStudy: workOrStudy ?? this.workOrStudy,
      isVerified: isVerified ?? this.isVerified,
      personalEvents: personalEvents ?? _personalEvents,
      constantEvents: constantEvents ?? _constantEvents,
      favoriteServices: favoriteServices ?? _favoriteServices,
    );
  }
  // ---- عمليات المفضلة ----

  /// التحقق مما إذا كانت الخدمة مضافة للمفضلة
  bool isServiceFavorite(String serviceId) {
    return _favoriteServices.any((s) => s.id == serviceId);
  }

  /// إضافة خدمة إلى المفضلة
  NormalUser addingFavoriteService(ServiceModel service) {
    if (isServiceFavorite(service.id)) return this;
    final updatedService = service.copyWith(isFavorite: true);
    return copyWith(favoriteServices: [..._favoriteServices, updatedService]);
  }

  /// إزالة خدمة من المفضلة
  NormalUser removingFavoriteService(String serviceId) {
    return copyWith(
      favoriteServices: _favoriteServices.where((s) => s.id != serviceId).toList(),
    );
  }

  /// تبديل حالة المفضلة (إضافة / حذف)
  NormalUser togglingFavoriteService(ServiceModel service) {
    if (isServiceFavorite(service.id)) {
      return removingFavoriteService(service.id);
    } else {
      return addingFavoriteService(service);
    }
  }
  // ---- عمليات جاهزة تُرجع نسخة جديدة (immutable) ----

  NormalUser addingPersonalEvent(PersonalEvent event) =>
      copyWith(personalEvents: [..._personalEvents, event]);

  NormalUser removingPersonalEvent(String eventId) => copyWith(
    personalEvents: _personalEvents.where((e) => e.id != eventId).toList(),
  );

  NormalUser updatingPersonalEvent(PersonalEvent updatedEvent) {
    final updated = _personalEvents
        .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
        .toList();
    return copyWith(personalEvents: updated);
  }

  NormalUser addingConstantEvent(ConstantEventModel event) =>
      copyWith(constantEvents: [..._constantEvents, event]);

  NormalUser removingConstantEvent(String eventId) => copyWith(
    constantEvents: _constantEvents.where((e) => e.id != eventId).toList(),
  );
}
