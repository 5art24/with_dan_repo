// core/models/user.dart
class User {
  final String id;
  final String username;
  final String urlImage;
  final String? phoneNumber;
  final String? workOrStudy;
  final bool isVerified;

  const User({
    required this.id,
    required this.username,
    required this.urlImage,
    this.phoneNumber,
    this.workOrStudy,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['userId'] ?? '',
      username: json['user_name'] ?? '',
      urlImage: json['profile_image'] ?? '',
      phoneNumber: json['phone_number'],
      workOrStudy: json['work_or_study'],
      isVerified: json['is_verified'] ?? false,
    );
  }

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

  User copyWith({
    String? id,
    String? username,
    String? urlImage,
    String? phoneNumber,
    String? workOrStudy,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      urlImage: urlImage ?? this.urlImage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      workOrStudy: workOrStudy ?? this.workOrStudy,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}