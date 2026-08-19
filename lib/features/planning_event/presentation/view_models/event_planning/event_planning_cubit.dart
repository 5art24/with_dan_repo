// features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/constants.dart';
import 'package:project1_collage/core/mock_services.dart';
import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/models/user.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/planning_event/models/service_item.dart';
import 'package:equatable/equatable.dart';

part 'event_planning_state.dart';

class EventPlanningCubit extends Cubit<EventPlanningState> {
  bool _isEditing = false;
  PersonalEvent? _currentEvent;
  late ServiceType _selectedServiceType;
  late FilterType _selectedFilter;

  // 🌍 إدارة نمط الموقع (القيم المتاحة: "Venue You Choose" أو "By Country/City")
  String _locationType = "Venue You Choose";

  final List<ServiceModel> _venues = [];
  final List<ServiceModel> _djs = [];
  final List<ServiceModel> _decors = [];
  final List<ServiceModel> _photographs = [];
  final List<ServiceModel> _lightings = MockServices.lightings;

  List<ServiceModel> _displayedServices = [];

  //======================== Constructor and Initial Data ========================
  EventPlanningCubit() : super(const EventPlanningInitial()) {
    _selectedServiceType = ServiceType.venue;
    _selectedFilter = FilterType.none;
  }
  bool get isEditing => _isEditing;

  final List<ServiceModel> _allServices = MockServices.allServices;

  void startNewEvent() {
    _isEditing = false;
    _currentEvent = PersonalEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      category: '',
      date: DateTime.now(),
      city: '', // 👈 التأكيد على إسناد قيمة نصية
      area: '',
      bookedServices: [],
    );
    emit(EventLoaded(event: _currentEvent!));
  }

  //======================== Set Initial Event Handling ========================

  /// 🟢 البحث عن الفعالية بوساطة ID داخل قائمة فعاليات المستخدم في AuthCubit وتعيينها كـ currentEvent
  void setInitialEventById(String eventId, AuthCubit authCubit) {
    // 1. الحصول على قائمة فعاليات المستخدم المسجل
    final userEvents = authCubit.currentUser?.personalEvents ?? [];

    try {
      // 2. البحث عن الفعالية بالـ ID
      final foundEvent = userEvents.firstWhere((event) => event.id == eventId);

      // 3. تعيين الفعالية الحالية وإصدار الحالة
      _currentEvent = foundEvent;
      emit(EventLoaded(event: _currentEvent!));
    } catch (e) {
      // 4. في حال عدم العثور على الفعالية بالـ ID الممرر
      emit(PersonalEventError(error: 'لم يتم العثور على الفعالية المطلوبة'));
    }
  }

  /// 🟢 دالة اختيارية: تعيين الفعالية مباشرة إذا كان كائن PersonalEvent متوفراً لديك بالكامل
  void setInitialEvent(PersonalEvent event) {
    _currentEvent = event;
    emit(EventLoaded(event: _currentEvent!));
  }

  void clearEvent() {
    emit(const EventReset());
    startNewEvent();
  }

  PersonalEvent? get currentEvent => _currentEvent;
  ServiceType get selectedServiceType => _selectedServiceType;
  FilterType get selectedFilter => _selectedFilter;

  //===================== Location & Area Handling ========================
  /// إرجاع طريقة اختيار المكان الحالية ("Venue You Choose" أو "By Country/City")
  String getLocationType() => _locationType;

  /// تغيير طريقة اختيار المكان وتصفير القيم لمنع التعارض
  void changeLocationType(String type) {
    _locationType = type;
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(city: '', area: '');
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  /// 🟢 تحديث city (وتفريغ area لتفادي التعارض مع الخيارات الجديدة)
  void updateCity(String city) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(city: city, area: '');
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  /// 🟢 تحديث area المحددة من القائمة الفرعية
  void updateArea(String area) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(area: area);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  /// 🟢 اختيار القاعة من كروت الخدمات وحفظ اسمها في area
  void selectVenue(String venueName) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(area: venueName);
      emit(VenueSelected(venue: venueName));
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  /// 🟢 إرجاع القيم المحددة حالياً (Getters مفيدة للواجهات)
  String getSelectedCity() => _currentEvent?.city ?? '';
  String getSelectedArea() => _currentEvent?.area ?? '';

  /// 🟢 صياغة نص الموقع للعرض في الواجهة (مثل: "السعودية - الرياض")
  String getDisplayLocation() {
    if (_currentEvent == null) return "لم يتم تحديد المكان بعد";

    List<String> parts = [];

    // 🛡️ استخدام ?. وتأكيد القراءة بأمان
    final city = _currentEvent!.city;
    final area = _currentEvent!.area;

    if (city.isNotEmpty) parts.add(city);
    if (area.isNotEmpty) parts.add(area);

    if (parts.isNotEmpty) {
      return parts.join(" - ");
    }

    return _locationType == "By Country/City"
        ? "اختر الموقع من القائمة"
        : "اختر صالة من قسم الخدمات";
  }

  /// 🟢 التحقق من صحة واكتمال بيانات الموقع
  bool isLocationValid() {
    if (_currentEvent == null) return false;
    if (_locationType == "By Country/City") {
      return _currentEvent!.city.isNotEmpty && _currentEvent!.area.isNotEmpty;
    } else {
      return _currentEvent!.area.isNotEmpty;
    }
  }

  /// 🟢 مسح المكان المحدد بالكامل
  void clearLocation() {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(city: '', area: '');
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  //===================== Edit Event Info ========================
  void loadEvent(PersonalEvent event) {
    _isEditing = true;
    _currentEvent = event;

    // 🟢 تحديد نمط الموقع تلقائياً بناءً على بيانات الفعالية المحملة
    if (event.city.isNotEmpty) {
      _locationType = "By Country/City";
    } else {
      _locationType = "Venue You Choose";
    }

    emit(EventLoaded(event: event));
  }

  // Helper Function لحساب التقدم
  double calculateEventProgress(List<TaskModel> tasks) {
    if (tasks.isEmpty) return 0.0;
    final completedCount = tasks.where((t) => t.isDone).length;
    return completedCount / tasks.length;
  }

  void updateEventName(String name) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(name: name);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  void updateDescription(String description) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(description: description);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  bool isCategorySelected(String category) {
    return _currentEvent?.category == category;
  }

  void updateCategory(String category) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(category: category);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  void updateDate(DateTime date) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(date: date, endDate: date);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  // 🆕 أضف هنا:
  void updateEndDate(DateTime endDate) {
    if (_currentEvent != null) {
      if (endDate.isBefore(_currentEvent!.startDate)) {
        emit(
          PersonalEventError(
            error: "تاريخ النهاية لا يمكن أن يسبق تاريخ البداية",
          ),
        );
        return; // 🛑 لا يُطبَّق التحديث إطلاقًا
      }
      _currentEvent = _currentEvent!.copyWith(endDate: endDate);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  bool isDateRangeValid() {
    if (_currentEvent == null) return false;
    return !_currentEvent!.endDate!.isBefore(_currentEvent!.startDate);
  }

  int get eventDurationInDays {
    if (_currentEvent == null) return 1;
    final days =
        _currentEvent!.endDate!.difference(_currentEvent!.startDate).inDays + 1;
    return days < 1 ? 1 : days;
  }

  void addService(ServiceModel service) {
    if (_currentEvent != null) {
      final currentServices = List<ServiceModel>.from(
        _currentEvent!.bookedServices,
      );
      if (!currentServices.any((s) => s.id == service.id)) {
        currentServices.add(service);
        _currentEvent = _currentEvent!.copyWith(
          bookedServices: currentServices,
        );
        emit(EventUpdated(event: _currentEvent!));
      } else {
        emit(
          ServiceAlreadyBooked(serviceName: service.name),
        ); // 👈 وصلنا الحالة الميتة أخيرًا
      }
    }
  }

  // 🆕 دالة جديدة للحذف الجماعي (تصدر emit واحد بدل تكراره)
  void removeServicesByIds(Set<String> serviceIds) {
    if (_currentEvent != null) {
      final currentServices = List<ServiceModel>.from(
        _currentEvent!.bookedServices,
      )..removeWhere((s) => serviceIds.contains(s.id));
      _currentEvent = _currentEvent!.copyWith(bookedServices: currentServices);
      emit(EventUpdated(event: _currentEvent!));
    }
  }

  Future<void> bookService(ServiceModel service) async {
    if (_currentEvent != null) {
      emit(const EventLoading());

      await Future.delayed(const Duration(seconds: 1));

      addService(service);
      emit(
        ServiceBookedSuccess(serviceName: service.name, event: _currentEvent!),
      );
    }
  }

  // 1️⃣ التحقق من صحة التاريخ
  bool isDateValid() {
    final date = currentEvent?.startDate;
    return date != null;
  }

  // 3️⃣ التحقق من اكتمال كافة البيانات الإلزامية
  bool isEventDataComplete() {
    if (currentEvent == null) return false;

    final isNameValid = currentEvent!.name.trim().isNotEmpty;
    final isCategoryValid = currentEvent!.category.trim().isNotEmpty;
    final isDateComplete = isDateValid();
    final isLocationComplete = isLocationValid();
    final isDateRangeComplete = isDateRangeValid(); // 🆕 هذا السطر يُضاف هنا

    return isNameValid &&
        isCategoryValid &&
        isDateComplete &&
        isLocationComplete &&
        isDateRangeComplete; // 🆕 و هذا يُضاف هنا بنهاية شرط الـ return
  }

  // 4️⃣ حفظ الفعالية
  void saveEvent() async {
    if (!isEventDataComplete()) {
      emit(
        PersonalEventError(
          error:
              "يرجى ملء جميع الحقول الإلزامية: الاسم، النوع، التاريخ، والمكان.",
        ),
      );
      return;
    }

    try {
      emit(const EventLoading());
      // await _eventRepository.save(currentEvent!);
      emit(EventSavedSuccess(event: currentEvent!));
    } catch (e) {
      emit(PersonalEventError(error: "حدث خطأ أثناء الحفظ: ${e.toString()}"));
    }
  }

  List<ServiceItem> getServiceTypes() {
    return List.from(AppConstants.allServices);
  }

  //===================== Displaying Services Logic ========================

  void changeServiceType(ServiceType type) {
    if (_selectedServiceType != type) {
      emit(ServicesLoading());
      _selectedServiceType = type;
      _displayedServices = gettingServicesDependingOnType();
      emit(
        ServicesFilterChanged(
          event: currentEvent!,
          selectedType: _selectedServiceType,
          selectedFilter: _selectedFilter,
          services: _displayedServices,
        ),
      );
    }
  }

  void changeFilter(FilterType filter) {
    if (_selectedFilter != filter) {
      _selectedFilter = filter;
      _displayedServices = gettingServicesDependingOnType();

      switch (_selectedFilter) {
        case FilterType.topRated:
          _displayedServices.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case FilterType.minPrice:
          _displayedServices.sort((a, b) => a.price.compareTo(b.price));
          break;
        case FilterType.none:
          break;
      }
      emit(
        ServicesFilterChanged(
          event: currentEvent!,
          selectedType: _selectedServiceType,
          selectedFilter: _selectedFilter,
          services: _displayedServices,
        ),
      );
    }
  }

  List<ServiceModel> gettingServicesDependingOnType() {
    List<ServiceModel> originalList = [];
    switch (_selectedServiceType) {
      case ServiceType.none:
        break;
      case ServiceType.venue:
        originalList = _venues;
        break;
      case ServiceType.dj:
        originalList = _djs;
        break;
      case ServiceType.decor:
        originalList = _decors;
        break;
      case ServiceType.photograph:
        originalList = _photographs;
        break;
      case ServiceType.lighting:
        originalList = _lightings;
        break;
    }
    return originalList;
  }

  List<ServiceModel> get filteredAndSortedServices => _displayedServices;

  bool isFilterSelected(FilterType filter) => _selectedFilter == filter;

  String getFilterLabel(FilterType filter) {
    switch (filter) {
      case FilterType.none:
        return 'All';
      case FilterType.topRated:
        return 'Top Rated';
      case FilterType.minPrice:
        return 'Min Price';
    }
  }

  //===================== Tasks logic ========================

  void addTask(TaskModel newTask) {
    if (_currentEvent == null) return;

    final updatedTasks = List<TaskModel>.from(_currentEvent!.tasks)
      ..add(newTask);
    _currentEvent = _currentEvent!.copyWith(tasks: updatedTasks);

    emit(EventUpdated(event: _currentEvent!));
  }

  // 🆕 تعديل مهمة موجودة والاحتفاظ بالتغييرات
  void updateTask(TaskModel updatedTask) {
    if (_currentEvent == null) return;

    final updatedTasks = _currentEvent!.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    _currentEvent = _currentEvent!.copyWith(tasks: updatedTasks);
    emit(EventUpdated(event: _currentEvent!));
  }

  // 🆕 حذف مهمة من الفعالية
  void deleteTask(String taskId) {
    if (_currentEvent == null) return;

    final updatedTasks = List<TaskModel>.from(_currentEvent!.tasks)
      ..removeWhere((task) => task.id == taskId);

    _currentEvent = _currentEvent!.copyWith(tasks: updatedTasks);
    emit(EventUpdated(event: _currentEvent!));
  }

  // ✅ تم إصلاحها: تعتمد على _currentEvent مباشرة بدل فحص نوع state،
  // وتُحدّث _currentEvent قبل emit لضمان تزامن البيانات مع الواجهة
  void toggleTaskStatus(String taskId) {
    if (_currentEvent == null) return;

    final updatedTasks = _currentEvent!.tasks.map((task) {
      return task.id == taskId ? task.copyWith(isDone: !task.isDone) : task;
    }).toList();

    _currentEvent = _currentEvent!.copyWith(tasks: updatedTasks);
    emit(EventUpdated(event: _currentEvent!));
  }
}
