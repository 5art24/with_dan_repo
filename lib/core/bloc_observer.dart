import 'package:bloc/bloc.dart';

// إنشاء مراقب مخصص
class SimpleBlocObserver extends BlocObserver {
  // يتم استدعاؤها عند كل تغيير في الحالة (Cubit)
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print("====================================");
    print('${bloc.runtimeType} Change: $change');
    // change.currentState -> الحالة الحالية (السابقة)
    // change.nextState -> الحالة الجديدة
    print('From: ${change.currentState}');
    print('To: ${change.nextState}');
    print("====================================");
  }

  // يتم استدعاؤها عند كل transition في Bloc (مع الأحداث)
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print("====================================");
    print('${bloc.runtimeType} Transition: $transition');
    print('Current State: ${transition.currentState}');
    print('Event: ${transition.event}');
    print('Next State: ${transition.nextState}');
    print("====================================");
  }
}
