import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/base_event.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final AuthCubit authCubit;
  StreamSubscription? _authSubscription;

  EventCubit(this.authCubit) : super(EventInitial()) {
    // 1. تحميل الفعاليات عند البناء
    loadUpcomingEvents();

    // 2. الاستماع لتحديثات AuthCubit فور تعديل أو حفظ أي فعالية
    _authSubscription = authCubit.stream.listen((authState) {
      if (authState is Authenticated) {
        loadUpcomingEvents();
      }
    });
  }

  void loadUpcomingEvents() {
    emit(EventLoading());
    try {
      final NormalUser = authCubit.currentNormalUser;

      if (NormalUser == null) {
        emit(EventError("لا يوجد مستخدم مسجل دخول"));
        return;
      }

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      // دمج الفعاليات الخاصة والعامة المضافة عند المستخدم
      final allNormalUserEvents = <BaseEvent>[
        ...NormalUser.personalEvents,
        ...NormalUser.constantEvents,
      ];

      // تصفية وترتيب الفعاليات القادمة من اليوم فصاعداً
      final upcoming =
          allNormalUserEvents
              .where(
                (e) => e.startDate.isAfter(
                  todayStart.subtract(const Duration(seconds: 1)),
                ),
              )
              .toList()
            ..sort((a, b) => a.startDate.compareTo(b.startDate));

      emit(EventLoaded(upcoming));
    } catch (e) {
      emit(EventError("حدث خطأ أثناء تحميل الفعاليات: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
