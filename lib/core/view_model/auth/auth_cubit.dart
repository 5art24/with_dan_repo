import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  User? _currentUser;

  // Getter للوصول للمستخدم الحالي من أي مكان عبر context.read<AuthCubit>().currentUser
  User? get currentUser => _currentUser;

  AuthCubit() : super(AuthInitial());

  void setUser(User user) {
    _currentUser = user;
    emit(Authenticated(user));
  }

  void logout() {
    _currentUser = null;
    emit(Unauthenticated());
  }

  // أضف هذا التابع داخل class AuthCubit
  void updateUserData(User updatedUser) {
    _currentUser = updatedUser;
    emit(Authenticated(_currentUser!));
  }

  // auth_cubit.dart
  void deletePersonalEvent(String eventId) {
    if (_currentUser == null) return;

    final updatedEvents = List<PersonalEvent>.from(_currentUser!.personalEvents)
      ..removeWhere((e) => e.id == eventId);

    _currentUser = _currentUser!.copyWith(personalEvents: updatedEvents);
    emit(
      Authenticated(_currentUser!),
    ); // 🟢 يطلق حالة جديدة فتتحدث كل الشاشات المربوطة بـ AuthCubit
  }

  //========================Edit Info===========================
  // auth_cubit.dart
  void addPersonalEvent(PersonalEvent event) {
    if (_currentUser == null) return;
    final updatedEvents = List<PersonalEvent>.from(_currentUser!.personalEvents)
      ..add(event);
    _currentUser = _currentUser!.copyWith(personalEvents: updatedEvents);
    emit(Authenticated(_currentUser!));
  }

  // 🟢 تابع خاص بتعديل فعالية موجودة مسبقاً
  void updatePersonalEvent(PersonalEvent updatedEvent) {
    if (_currentUser == null) return;

    final updatedEvents = List<PersonalEvent>.from(
      _currentUser!.personalEvents,
    );
    final index = updatedEvents.indexWhere((e) => e.id == updatedEvent.id);

    if (index != -1) {
      updatedEvents[index] = updatedEvent; // 🔄 استبدال النسخة القديمة بالجديدة
      _currentUser = _currentUser!.copyWith(personalEvents: updatedEvents);
      emit(Authenticated(_currentUser!));
    }
  }
}
