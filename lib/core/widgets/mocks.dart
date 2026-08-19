// lib/core/repositories/mock_event_repository.dart
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/task.dart';

class MockEventRepository {
  static List<ConstantEventModel> getConstantEvents() {
    final now = DateTime.now();
    return [
      ConstantEventModel(
        id: '1',
        name: 'معرض الفنون الدولي',
        imageUrl: ['https://picsum.photos/400/200?random=1'],
        city: 'القاهرة',
        area: '',
        type: EventType.artistic,
        date: now.add(const Duration(days: 3)),
        description: 'معرض فني ضخم',
        bookings: [],
        accommodation: 100,
      ),
      ConstantEventModel(
        id: '2',
        name: 'مؤتمر التكنولوجيا',
        imageUrl: ['https://picsum.photos/400/200?random=2'],
        city: 'دبي',
        area: 'مركز دبي التجاري',
        type: EventType.technical,
        date: now.add(const Duration(days: 7)),
        description: 'مؤتمر تقني عالمي',
        bookings: [],
        accommodation: 200,
      ),
    ];
  }

  static List<PersonalEvent> getPersonalEvents() {
    final now = DateTime.now();
    return [
      PersonalEvent(
        id: 'p1',
        name: '🎂 عيد ميلاد سارة',
        category: 'birthday',
        date: now,
        tasks: [
          TaskModel(id: 't1', title: 'شراء كعكة عيد الميلاد', dateTime: DateTime(now.year, now.month, now.day, 10, 0), eventId: 'p1', eventTitle: 'عيد ميلاد سارة', priority: 1, isDone: false),
          TaskModel(id: 't2', title: 'تزيين الغرفة بالبالونات', dateTime: DateTime(now.year, now.month, now.day, 12, 0), eventId: 'p1', eventTitle: 'عيد ميلاد سارة', priority: 2, isDone: false),
          TaskModel(id: 't3', title: 'شراء هدية لسارة', dateTime: DateTime(now.year, now.month, now.day, 8, 0), eventId: 'p1', eventTitle: 'عيد ميلاد سارة', priority: 1, isDone: true),
        ],
        area: 'قاعة الأفراح - القاهرة',
      ),
      PersonalEvent(
        id: 'p2',
        name: '💻 اجتماع العمل السنوي',
        category: 'meeting',
        date: now.add(const Duration(days: 1)),
        tasks: [
          TaskModel(id: 't4', title: 'تجهيز عرض البوربوينت', dateTime: DateTime(now.year, now.month, now.day + 1, 9, 0), eventId: 'p2', eventTitle: 'اجتماع العمل السنوي', priority: 1, isDone: false),
          TaskModel(id: 't5', title: 'طباعة التقارير', dateTime: DateTime(now.year, now.month, now.day + 1, 8, 0), eventId: 'p2', eventTitle: 'اجتماع العمل السنوي', priority: 2, isDone: false),
          TaskModel(id: 't6', title: 'تأكيد حضور المدير', dateTime: DateTime(now.year, now.month, now.day, 16, 0), eventId: 'p2', eventTitle: 'اجتماع العمل السنوي', priority: 3, isDone: true),
        ],
        area: 'فندق النيل - القاهرة',
      ),
      // ... باقي الفعاليات (p3 - p7) بنفس الطريقة
    ];
  }
}