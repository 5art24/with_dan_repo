import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/service_provider_user.dart';
import 'package:project1_collage/core/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  User? _currentUser;

  User? get currentUser => _currentUser;

  // 🟢 وصول مُنمَّط حسب نوع المستخدم الفعلي
  NormalUser? get currentNormalUser =>
      _currentUser is NormalUser ? _currentUser as NormalUser : null;

  ServiceProviderUser? get currentProviderUser =>
      _currentUser is ServiceProviderUser
          ? _currentUser as ServiceProviderUser
          : null;

  AuthCubit() : super(AuthInitial());

  void setUser(User user) {
    _currentUser = user;
    emit(Authenticated(user));
  }

  void logout() {
    _currentUser = null;
    emit(Unauthenticated());
  }

  void updateUserData(User updatedUser) {
    _currentUser = updatedUser;
    emit(Authenticated(_currentUser!));
  }

  //==================== Personal Events (NormalUser فقط) ====================

  void addPersonalEvent(PersonalEvent event) {
    final normal = currentNormalUser;
    if (normal == null) return;
    _currentUser = normal.addingPersonalEvent(event);
    emit(Authenticated(_currentUser!));
  }

  void updatePersonalEvent(PersonalEvent updatedEvent) {
    final normal = currentNormalUser;
    if (normal == null) return;
    _currentUser = normal.updatingPersonalEvent(updatedEvent);
    emit(Authenticated(_currentUser!));
  }

  void deletePersonalEvent(String eventId) {
    final normal = currentNormalUser;
    if (normal == null) return;
    _currentUser = normal.removingPersonalEvent(eventId);
    emit(Authenticated(_currentUser!));
  }

  //==================== Constant Events (NormalUser فقط) ====================

  void bookConstantEvent(ConstantEventModel event) {
    final normal = currentNormalUser;
    if (normal == null) return;
    _currentUser = normal.addingConstantEvent(event);
    emit(Authenticated(_currentUser!));
  }

  void cancelConstantEvent(String eventId) {
    final normal = currentNormalUser;
    if (normal == null) return;
    _currentUser = normal.removingConstantEvent(eventId);
    emit(Authenticated(_currentUser!));
  }

  //==================== Services (ServiceProviderUser فقط) ====================

  void addService(ServiceModel service) {
    final provider = currentProviderUser;
    if (provider == null) return;
    _currentUser = provider.addingService(service);
    emit(Authenticated(_currentUser!));
  }

  void removeService(String serviceId) {
    final provider = currentProviderUser;
    if (provider == null) return;
    _currentUser = provider.removingService(serviceId);
    emit(Authenticated(_currentUser!));
  }
  //==================== Favorites (NormalUser فقط) ====================

/// 🟢 إضافة أو إزالة الخدمة من المفضلة
Future<void> toggleFavoriteService(ServiceModel service) async {
  final normal = currentNormalUser;
  if (normal == null) return;

  // 1. الاحتفاظ بالنسخة القديمة لاسترجاعها في حال الفشل
  final previousUser = _currentUser;

  // 2. تحديث الواجهة فوراً لتوفير تجربة مستخدم سريعة
  _currentUser = normal.togglingFavoriteService(service);
  emit(Authenticated(_currentUser!));

  try {
    // 3. استدعاء الـ API الخاص بالمفضلة هنا
    // await favoriteRepository.toggleFavorite(service.id);
  } catch (e) {
    // 4. إرجاع الحالة السابقة في حال حدوث خطأ بالنظام أو الشبكة
    _currentUser = previousUser;
    emit(Authenticated(_currentUser!));
    
    // يمكن هنا إرسال حالة خطأ مؤقتة أو إظهار SnackBar من الواجهة
  }
}

/// 🟢 التحقق هل الخدمة مفضلة للمستخدم الحالي أم لا
bool isServiceFavorite(String serviceId) {
  final normal = currentNormalUser;
  if (normal == null) return false;
  return normal.isServiceFavorite(serviceId);
}
}