import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/bloc_observer.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/view_model/location/location_cubit.dart';
import 'package:project1_collage/core/repos/location_repo.dart';
import 'core/api_service.dart';
import 'package:dio/dio.dart';    
void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final mockNormalUser = NormalUser(
    id: 'u1',
    username: 'Rima',
    urlImage:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
    personalEvents: [
      // 1. حفلة تخرج (بعد يومين)
      PersonalEvent(
        id: 'p1',
        name: 'حفلة تخرج',
        category: 'party',
        date: DateTime.now().add(const Duration(days: 2)),
        area: 'المزّة',
        tasks: [
          TaskModel(
            id: 't1',
            title: 'تأكيد حجز الصالة',
            dateTime: DateTime.now().add(
              const Duration(hours: 2),
            ), // اليوم بعد ساعتين
            eventId: 'p1',
            eventTitle: 'حفلة تخرج',
            isDone: true,
            priority: 1, // أولوية عالية
          ),
          TaskModel(
            id: 't2',
            title: 'اختيار قالب الكيك',
            dateTime: DateTime.now().add(
              const Duration(hours: 6),
            ), // اليوم مساءً
            eventId: 'p1',
            eventTitle: 'حفلة تخرج',
            isDone: true,
            priority: 2, // أولوية متوسطة
          ),
          TaskModel(
            id: 't3',
            title: 'إرسال بطاقات الدعوة للأصدقاء',
            dateTime: DateTime.now().add(
              const Duration(days: 1, hours: 4),
            ), // غداً ظهراً
            eventId: 'p1',
            eventTitle: 'حفلة تخرج',
            isDone: false,
            priority: 1,
          ),
          TaskModel(
            id: 't4',
            title: 'شراء المستلزمات والزينة',
            dateTime: DateTime.now().add(
              const Duration(days: 2, hours: -3),
            ), // يوم الفعالية صباحاً
            eventId: 'p1',
            eventTitle: 'حفلة تخرج',
            isDone: false,
            priority: 3, // أولوية منخفضة
          ),
        ],
      ),

      // 2. مناقشة مشروع التخرج (بعد 7 أيام)
      PersonalEvent(
        id: 'p2',
        name: 'مناقشة مشروع التخرج',
        category: 'study',
        date: DateTime.now().add(const Duration(days: 7)),
        area: 'جامعة دمشق',
        tasks: [
          TaskModel(
            id: 't5',
            title: 'إتمام مخططات الـ UML والهيكلية',
            dateTime: DateTime.now().add(
              const Duration(days: 1, hours: 2),
            ), // بعد يوم
            eventId: 'p2',
            eventTitle: 'مناقشة مشروع التخرج',
            isDone: true,
            priority: 1,
          ),
          TaskModel(
            id: 't6',
            title: 'تجهيز السلايدات والعرض التقديمي',
            dateTime: DateTime.now().add(
              const Duration(days: 3, hours: 5),
            ), // بعد 3 أيام
            eventId: 'p2',
            eventTitle: 'مناقشة مشروع التخرج',
            isDone: false,
            priority: 1,
          ),
          TaskModel(
            id: 't7',
            title: 'مراجعة كود Flutter واختباره',
            dateTime: DateTime.now().add(
              const Duration(days: 5, hours: 3),
            ), // بعد 5 أيام
            eventId: 'p2',
            eventTitle: 'مناقشة مشروع التخرج',
            isDone: false,
            priority: 2,
          ),
          TaskModel(
            id: 't8',
            title: 'طباعة التقرير النهائي',
            dateTime: DateTime.now().add(
              const Duration(days: 6, hours: 8),
            ), // قبل المناقشة بيوم
            eventId: 'p2',
            eventTitle: 'مناقشة مشروع التخرج',
            isDone: false,
            priority: 1,
          ),
        ],
      ),

      // 3. رحلة نهاية الأسبوع (بعد 12 يوم)
      PersonalEvent(
        id: 'p3',
        name: 'رحلة نهاية الأسبوع',
        category: 'travel',
        date: DateTime.now().add(const Duration(days: 12)),
        area: 'صيدنايا',
        tasks: [
          TaskModel(
            id: 't9',
            title: 'حجز وسيلة النقل',
            dateTime: DateTime.now().add(
              const Duration(days: 8, hours: 4),
            ), // بعد 8 أيام
            eventId: 'p3',
            eventTitle: 'رحلة نهاية الأسبوع',
            isDone: true,
            priority: 2,
          ),
          TaskModel(
            id: 't10',
            title: 'تحضير قائمة الطعام والوجبات الخفيفة',
            dateTime: DateTime.now().add(
              const Duration(days: 10, hours: 6),
            ), // بعد 10 أيام
            eventId: 'p3',
            eventTitle: 'رحلة نهاية الأسبوع',
            isDone: false,
            priority: 3,
          ),
          TaskModel(
            id: 't11',
            title: 'تجهيز قائمة الأنشطة والألعاب الجماعية',
            dateTime: DateTime.now().add(
              const Duration(days: 11, hours: 5),
            ), // قبل الرحلة بيوم
            eventId: 'p3',
            eventTitle: 'رحلة نهاية الأسبوع',
            isDone: false,
            priority: 2,
          ),
        ],
      ),

      // 4. حفلة عيد ميلاد (بعد 18 يوم)
      PersonalEvent(
        id: 'p4',
        name: 'حفلة عيد ميلاد',
        category: 'celebration',
        date: DateTime.now().add(const Duration(days: 18)),
        area: 'المالكي',
        tasks: [
          TaskModel(
            id: 't12',
            title: 'شراء الهدية وتغليفها',
            dateTime: DateTime.now().add(
              const Duration(days: 15, hours: 4),
            ), // بعد 15 يوم
            eventId: 'p4',
            eventTitle: 'حفلة عيد ميلاد',
            isDone: false,
            priority: 2,
          ),
          TaskModel(
            id: 't13',
            title: 'تأكيد الحضور مع باقي الأصدقاء',
            dateTime: DateTime.now().add(
              const Duration(days: 17, hours: 2),
            ), // قبل الحفلة بيوم
            eventId: 'p4',
            eventTitle: 'حفلة عيد ميلاد',
            isDone: true,
            priority: 3,
          ),
        ],
      ),
    ],
    constantEvents: [
      // 1. معرض التكنولوجيا
      // 1. معرض التكنولوجيا والبرمجيات
      ConstantEventModel(
        id: 'c1',
        name: 'معرض التكنولوجيا والبرمجيات',
        city: 'دمشق',
        area: 'مدينة المعارض',
        type: EventType.technical,
        date: DateTime.now().add(const Duration(days: 5)),
        bookings: [],
        accommodation: 100,
      ),
      // 2. مهرجان الياسمين الثقافي
      ConstantEventModel(
        id: 'c2',
        name: 'مهرجان الياسمين الثقافي',
        city: 'دمشق',
        area: 'باب توما',
        type: EventType.cultural,
        date: DateTime.now().add(const Duration(days: 10)),
        bookings: [],
        accommodation: 150,
      ),
      // 3. معرض الفنون المعاصرة
      ConstantEventModel(
        id: 'c3',
        name: 'معرض الفنون والرسم المعاصر',
        city: 'دمشق',
        area: 'أبو رمانة',
        type: EventType.artistic,
        date: DateTime.now().add(const Duration(days: 15)),
        bookings: [],
        accommodation: 80,
      ),
      // 4. بطولة الشطرنج
      ConstantEventModel(
        id: 'c4',
        name: 'بطولة الشطرنج المفتوحة',
        city: 'دمشق',
        area: 'مشروع دمر',
        type: EventType.artistic,
        date: DateTime.now().add(const Duration(days: 22)),
        bookings: [],
        accommodation: 50,
      ),
    ],
  );
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LocationCubit(LocationRepository(ApiService(Dio())))
                ..fetchCountries(),
        ),
        BlocProvider(
          create: (context) => AuthCubit()..setUser(mockNormalUser),
          child: MyApp(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
