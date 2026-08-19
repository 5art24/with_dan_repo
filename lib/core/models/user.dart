import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';

class User {
  // 1. الحقول الأساسية المطابقة للـ ERD
  final String id;
  final String username;
  final String urlImage;
  final String? phoneNumber;
  final String? workOrStudy;
  final bool isVerified;
  List<ConstantEventModel> _constantEvents = [];
  List<PersonalEvent> _personalEvents = [];

  List<PersonalEvent> get personalEvents => List.unmodifiable(_personalEvents);
  List<ConstantEventModel> get constantEvents => List.unmodifiable(_constantEvents);

  User({
    required this.id,
    required this.username,
    required this.urlImage,
    this.phoneNumber,
    this.workOrStudy,
    this.isVerified = false,
    List<PersonalEvent>? personalEvents,
    List<ConstantEventModel>? constantEvents, // تمكين تمرير الفعاليات عند الإنشاء
  }) {
    if (personalEvents != null) {
      _personalEvents = List.from(personalEvents);
    }
    if (constantEvents != null) {
      _constantEvents = List.from(constantEvents);
    }
  }

  // 2. التحويل من JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? '',
      username: json['user_name'] ?? '',
      urlImage: json['profile_image'] ?? '',
      phoneNumber: json['phone_number'],
      workOrStudy: json['work_or_study'],
      isVerified: json['is_verified'] ?? false,
       constantEvents: json['constant_events'] != null
          ? (json['constant_events'] as List)
              .map((e) => ConstantEventModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      personalEvents: json['personal_events'] != null
          ? (json['personal_events'] as List)
              .map((e) => PersonalEvent.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  // 3. التحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'user_name': username,
      'profile_image': urlImage,
      'phone_number': phoneNumber,
      'work_or_study': workOrStudy,
      'is_verified': isVerified,
    };
  }

  // 4. دالة copyWith لإدارة الحالة مع Cubit
  User copyWith({
    String? id,
    String? username,
    String? urlImage,
    String? phoneNumber,
    String? workOrStudy,
    bool? isVerified,
    List<PersonalEvent>? personalEvents,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      urlImage: urlImage ?? this.urlImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workOrStudy: workOrStudy ?? this.workOrStudy,
      isVerified: isVerified ?? this.isVerified,
      personalEvents: personalEvents ?? this._personalEvents,
    );
  }

  // --- الدوال الخاصة بك كما هي دون تعديل ---
  void addPersonalEvent(PersonalEvent event) {
    _personalEvents.add(event);
  }

  void removePersonalEvent(PersonalEvent event) {
    _personalEvents.remove(event);
  }

  void clearPersonalEvents() {
    _personalEvents.clear();
  }
}