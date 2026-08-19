part of 'event_planning_cubit.dart';

/// 🌍 الحالة الأساسية المجرّدة لجميع حالات الشاشة
abstract class EventPlanningState extends Equatable {
  const EventPlanningState();

  @override
  List<Object?> get props => [];
}

// =========================================================================
// 🎯 1. الحالات المجرّدة العامة (Base Abstract States) - لمنع التكرار
// =========================================================================

/// حالة مجردة لجميع عمليات التحميل
abstract class EventPlanningLoadingState extends EventPlanningState {
  const EventPlanningLoadingState();
}

/// حالة مجردة لجميع الأخطاء (تضمن وجود نص الخطأ دائمًا)
abstract class EventPlanningErrorState extends EventPlanningState {
  final String error;

  const EventPlanningErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

/// حالة مجردة لجميع الحالات التي تتضمن كائن الفعالية (PersonalEvent)
abstract class EventWithDataState extends EventPlanningState {
  final PersonalEvent event;

  const EventWithDataState({required this.event});

  @override
  List<Object?> get props => [event];
}

/// حالة مجردة لكافة التغييرات المترتبة على الموقع والجغرافيا
abstract class LocationState extends EventPlanningState {
  const LocationState();
}

// =========================================================================
// 📅 2. حالات الفعالية الأساسية (Core Event States)
// =========================================================================

final class EventPlanningInitial extends EventPlanningState {
  const EventPlanningInitial();
}

final class EventReset extends EventPlanningState {
  const EventReset();
}

final class EventNotInitialized extends EventPlanningState {
  const EventNotInitialized();
}

final class EventLoading extends EventPlanningLoadingState {
  const EventLoading();
}

/// تحميل الفعالية لأول مرة
final class EventLoaded extends EventWithDataState {
  const EventLoaded({required super.event});
}

/// تحديث بيانات الفعالية (حالة أساسية لجميع التعديلات)
class EventUpdated extends EventWithDataState {
  const EventUpdated({required super.event});
}

/// حفظ الفعالية بنجاح
final class EventSavedSuccess extends EventUpdated {
  const EventSavedSuccess({required super.event});
}

/// حالة الخطأ الخاصة بالفعالية
final class PersonalEventError extends EventPlanningErrorState {
  const PersonalEventError({required super.error});
}

// =========================================================================
// 📍 3. حالات اختيار الموقع (Location States)
// =========================================================================

final class LocationInitial extends LocationState {
  const LocationInitial();
}

final class LocationTypeChanged extends LocationState {
  final String locationType;
  final String? selectedVenue;

  const LocationTypeChanged({
    required this.locationType,
    this.selectedVenue,
  });

  @override
  List<Object?> get props => [locationType, selectedVenue];
}

final class VenueSelected extends LocationState {
  final String venue;

  const VenueSelected({required this.venue});

  @override
  List<Object?> get props => [venue];
}

// =========================================================================
// 🛍️ 4. حالات عرض وفلترة الخدمات (Services Display & Filtering States)
// =========================================================================

final class ServicesLoading extends EventPlanningLoadingState {
  const ServicesLoading();
}

final class ServiceAlreadyBooked extends EventPlanningState {
  final String serviceName;

  const ServiceAlreadyBooked({required this.serviceName});

  @override
  List<Object?> get props => [serviceName];
}

final class ServicesError extends EventPlanningErrorState {
  const ServicesError({required super.error});
}

/// تغيير فلاتر الخدمات (يرث من EventUpdated لتمرير الفعالية المحدثة)
final class ServicesFilterChanged extends EventUpdated {
  final ServiceType selectedType;
  final FilterType selectedFilter;
  final List<ServiceModel> services;

  const ServicesFilterChanged({
    required this.selectedType,
    required this.selectedFilter,
    required this.services,
    required super.event,
  });

  @override
  List<Object?> get props => [selectedType, selectedFilter, services, event];
}

// =========================================================================
// 🎟️ 5. حالات حجز الخدمات (Service Booking States)
// =========================================================================

/// نجاح حجز خدمة (يرث من EventUpdated)
final class ServiceBookedSuccess extends EventUpdated {
  final String serviceName;

  const ServiceBookedSuccess({
    required this.serviceName,
    required super.event,
  });

  @override
  List<Object?> get props => [serviceName, event];
}