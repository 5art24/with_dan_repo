// features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project1_collage/core/constants.dart';
import 'package:project1_collage/core/mock_services.dart';
import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/models/user.dart';
import 'package:project1_collage/features/planning_event/models/service_item.dart';
import 'package:equatable/equatable.dart';

part 'event_planning_state.dart';

class EventPlanningCubit extends Cubit<EventPlanningState> {
  //the current event that the user enters its info
  PersonalEvent? _currentEvent;
  late ServiceType _selectedServiceType;
  late FilterType _selectedFilter;
  final List<ServiceModel> _venues = [];
  final List<ServiceModel> _djs = [];
  final List<ServiceModel> _decors = [];
  final List<ServiceModel> _photographs = [];
  final List<ServiceModel> _lightings = MockServices.lightings;
  
  // displayed services depending on filters
  List<ServiceModel> _displayedServices = [];

  //========================Constructor and initial data========================
  EventPlanningCubit() : super(EventPlanningInitial()) {
    _selectedServiceType = ServiceType.venue;
    _selectedFilter = FilterType.none;
  }
  
  final List<ServiceModel> _allServices = MockServices.allServices;

  //a new event is created with default values and the user will update it
  void startNewEvent() {
    _currentEvent = PersonalEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '',
      category: '',
      date: DateTime.now(),
      bookedServices: [],
    );
    emit(EventLoaded(_currentEvent!));
  }

  PersonalEvent? get currentEvent => _currentEvent;
  ServiceType get selectedServiceType => _selectedServiceType;
  FilterType get selectedFilter => _selectedFilter;

  //=====================Location Handling========================
  String? getLocationType() {
    return _currentEvent?.locationType;
  }

  void changeLocationType(String locationType) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!
          .copyWith(locationType: locationType)
          .clearLocation();
      if (locationType == "Place You Choose by GPS") {
        getCurrentLocation(); // ✅ سيتم استدعاء هذه الدالة للحصول على الموقع الحالي
      }
      emit(EventUpdated(_currentEvent!));
    }
  }

  //When locationType is "Venue You Choose", this function will be called to set the selected venue
  void selectVenue(String venue) {
    if (_currentEvent != null &&
        _currentEvent!.locationType == "Venue You Choose") {
      _currentEvent = _currentEvent!.copyWith(selectedVenue: venue);
      emit(VenueSelected(venue));
    }
  }

  // ✅ دالة محدثة: الحصول على الموقع عبر GPS
  Future<void> getCurrentLocation() async {
    if (_currentEvent?.locationType != "Place You Choose by GPS") return;

    emit(GPSLoading());

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(GPSError("الرجاء السماح للتطبيق بالوصول إلى الموقع"));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(
          GPSError(
            "The location permission has denied forever. Please enable it from settings",
          ),
        );
        return;
      }
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(GPSError("الرجاء تشغيل خدمة تحديد الموقع (GPS)"));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // ✅ إضافة timeout
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final address = _formatAddress(placemarks.first);
        _currentEvent = _currentEvent!.copyWith(
          gpsAddress: address,
          latitude: position.latitude,  // ✅ حفظ الإحداثيات
          longitude: position.longitude, // ✅ حفظ الإحداثيات
        );
        emit(GPSSuccess(address));
        emit(EventUpdated(_currentEvent!));
      } else {
        emit(GPSError("تعذر تحديد العنوان"));
      }
    } catch (e) {
      emit(GPSError("فشل في الحصول على الموقع: ${e.toString()}"));
    }
  }

  // ✅ دالة مساعدة لتنسيق العنوان (مضافة)
  String _formatAddress(Placemark placemark) {
    List<String> parts = [];
    if (placemark.street != null && placemark.street!.isNotEmpty) 
      parts.add(placemark.street!);
    if (placemark.locality != null && placemark.locality!.isNotEmpty) 
      parts.add(placemark.locality!);
    if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) 
      parts.add(placemark.administrativeArea!);
    if (placemark.country != null && placemark.country!.isNotEmpty) 
      parts.add(placemark.country!);
    if (placemark.postalCode != null && placemark.postalCode!.isNotEmpty) 
      parts.add(placemark.postalCode!);
    
    return parts.join(', ');
  }

  // ✅ دالة جديدة: تحديث الموقع يدوياً (عند اختيار المستخدم موقع عبر الخريطة)
  void updateGPSLocation(String newAddress, double? lat, double? lng) {
    if (_currentEvent != null && _currentEvent!.locationType == "Place You Choose by GPS") {
      _currentEvent = _currentEvent!.copyWith(
        gpsAddress: newAddress,
        latitude: lat,
        longitude: lng,
      );
      emit(GPSSuccess(newAddress));
      emit(EventUpdated(_currentEvent!));
    }
  }

  //with dropdown menu
  String getDisplayLocation() {
    if (_currentEvent == null) return "اختر طريقة تحديد المكان أولاً";
    
    if (_currentEvent!.locationType == "Venue You Choose") {
      return _currentEvent!.selectedVenue ?? "لم يتم اختيار صالة بعد";
    } else if (_currentEvent!.locationType == "Place You Choose by GPS") {
      return _currentEvent!.gpsAddress ?? "جاري الحصول على الموقع...";
    }
    
    return "اختر طريقة تحديد المكان أولاً";
  }
  //=====================End of Location Handling========================

  //=====================Edit Event Info========================

  //load an existing event to edit it
  void loadEvent(PersonalEvent event) {
    _currentEvent = event;
    emit(EventLoaded(event));
  }

  void updateEventName(String name) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(name: name);
      emit(EventUpdated(_currentEvent!));
    }
  }

  void updateDescription(String description) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(description: description);
      emit(EventUpdated(_currentEvent!));
    }
  }

  bool isCategorySelected(String category) {
    return _currentEvent?.category == category;
  }

  void updateCategory(String category) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(category: category);
      emit(EventUpdated(_currentEvent!));
    }
  }

  void updateDate(DateTime date) {
    if (_currentEvent != null) {
      _currentEvent = _currentEvent!.copyWith(date: date);
      emit(EventUpdated(_currentEvent!));
    }
  }

  void addService(ServiceModel service) {
    if (_currentEvent != null) {
      final currentServices = List<ServiceModel>.from(
        _currentEvent!.bookedServices,
      );
      if (!currentServices.any((s) => s.name == service.name)) {
        currentServices.add(service);
        _currentEvent = _currentEvent!.copyWith(
          bookedServices: currentServices,
        );
        emit(EventUpdated(_currentEvent!));
      }
    }
  }

  void removeService(ServiceModel service) {
    if (_currentEvent != null) {
      final currentServices = List<ServiceModel>.from(
        _currentEvent!.bookedServices,
      );
      currentServices.removeWhere((s) => s.name == service.name);
      _currentEvent = _currentEvent!.copyWith(bookedServices: currentServices);
      emit(EventUpdated(_currentEvent!));
    }
  }

  Future<void> bookService(ServiceModel service) async {
    if (_currentEvent != null) {
      emit(EventLoading());

      await Future.delayed(const Duration(seconds: 1));

      addService(service);
      emit(ServiceBookedSuccess(service.name, _currentEvent!));
    }
  }

  Future<void> saveEvent() async {
    if (_currentEvent != null) {
      emit(EventLoading());

      await Future.delayed(const Duration(seconds: 1));

      emit(EventSavedSuccess(_currentEvent!));
    }
  }

  bool isVenueServiceVisible() {
    return _currentEvent?.locationType == "Venue You Choose";
  }

  List<ServiceItem> getServiceTypes() {
    List<ServiceItem> displayedServices = List.from(AppConstants.allServices);
    if (_currentEvent?.locationType != "Venue You Choose") {
      displayedServices.removeWhere(
        (service) => service.service.name == "Venue",
      );
    }
    return displayedServices;
  }

  //=====================End of Edit Event Info========================

  //=====================Displaying Services Logic========================

  void changeServiceType(ServiceType type) {
    if (_selectedServiceType != type) {
      emit(ServicesLoading());
      _selectedServiceType = type;
      _displayedServices = gettingServicesDependingOnType();
      emit(
        ServicesFilterChanged(
          _selectedServiceType,
          _selectedFilter,
          _displayedServices,
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
          _selectedServiceType,
          _selectedFilter,
          _displayedServices,
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
}