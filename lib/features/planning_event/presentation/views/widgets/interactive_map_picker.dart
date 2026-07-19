// features/planning_event/presentation/views/widgets/interactive_map_picker.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:geocoding/geocoding.dart';

class InteractiveMapPicker extends StatefulWidget {
  const InteractiveMapPicker({super.key});

  @override
  State<InteractiveMapPicker> createState() => _InteractiveMapPickerState();
}

class _InteractiveMapPickerState extends State<InteractiveMapPicker> {
  late MapController _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;
  bool _isFullScreen = false;
  bool _isMapReady = false; // ✅ إضافة متغير لتتبع جاهزية الخريطة

  // موقع افتراضي (يمكنك تغييره حسب منطقتك)
  final LatLng _defaultLocation = const LatLng(24.7136, 46.6753); // الرياض

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    
    // ✅ استخدام addPostFrameCallback لتنفيذ الكود بعد بناء الـ Widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLocation();
    });
  }

  // ✅ دالة التحميل: تستخدم getCurrentLocation()
  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      final cubit = context.read<EventPlanningCubit>();
      final event = cubit.currentEvent;
      
      // إذا كان هناك موقع محدد مسبقاً في الحدث
      if (event != null && event.latitude != null && event.longitude != null) {
        _selectedLocation = LatLng(event.latitude!, event.longitude!);
        _selectedAddress = event.gpsAddress ?? '';
        _moveMapToLocation(_selectedLocation!);
      } else {
        // ✅ استخدام getCurrentLocation() للحصول على الموقع الحالي
        await cubit.getCurrentLocation();
        final updatedEvent = cubit.currentEvent;
        if (updatedEvent != null && updatedEvent.latitude != null && updatedEvent.longitude != null) {
          _selectedLocation = LatLng(updatedEvent.latitude!, updatedEvent.longitude!);
          _selectedAddress = updatedEvent.gpsAddress ?? '';
          _moveMapToLocation(_selectedLocation!);
        } else {
          // استخدام الموقع الافتراضي
          _selectedLocation = _defaultLocation;
          _moveMapToLocation(_defaultLocation);
        }
      }
    } catch (e) {
      // في حالة الخطأ، استخدم الموقع الافتراضي
      _selectedLocation = _defaultLocation;
      _moveMapToLocation(_defaultLocation);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ دالة مساعدة لتحريك الخريطة مع التحقق من الجاهزية
  void _moveMapToLocation(LatLng location) {
    if (_isMapReady && mounted) {
      _mapController.move(location, 14.0);
    }
  }

  // ✅ عند النقر على الخريطة: تستخدم updateGPSLocation()
  void _onMapTap(TapPosition position, LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
    _getAddressFromCoordinates(point);
  }

  // تحويل الإحداثيات إلى عنوان وحفظه
  Future<void> _getAddressFromCoordinates(LatLng coordinates) async {
    setState(() => _isLoading = true);
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final address = _formatAddress(placemarks.first);
        setState(() {
          _selectedAddress = address;
        });
        
        // ✅ استخدام updateGPSLocation() لحفظ الموقع المختار
        final cubit = context.read<EventPlanningCubit>();
        cubit.updateGPSLocation(
          address,
          coordinates.latitude,
          coordinates.longitude,
        );
      } else {
        // في حالة عدم وجود عنوان، استخدم الإحداثيات كعنوان
        final fallbackAddress = '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
        setState(() {
          _selectedAddress = fallbackAddress;
        });
        
        final cubit = context.read<EventPlanningCubit>();
        cubit.updateGPSLocation(
          fallbackAddress,
          coordinates.latitude,
          coordinates.longitude,
        );
      }
    } catch (e) {
      // في حالة فشل تحويل الإحداثيات
      final fallbackAddress = '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
      setState(() {
        _selectedAddress = fallbackAddress;
      });
      
      final cubit = context.read<EventPlanningCubit>();
      cubit.updateGPSLocation(
        fallbackAddress,
        coordinates.latitude,
        coordinates.longitude,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // دالة مساعدة لتنسيق العنوان
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

  // ✅ زر تحديث الموقع: يستخدم getCurrentLocation()
  Future<void> _updateToCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      final cubit = context.read<EventPlanningCubit>();
      
      // ✅ استخدام getCurrentLocation() للحصول على الموقع الحالي
      await cubit.getCurrentLocation();
      
      final event = cubit.currentEvent;
      if (event != null && event.latitude != null && event.longitude != null) {
        setState(() {
          _selectedLocation = LatLng(event.latitude!, event.longitude!);
          _selectedAddress = event.gpsAddress ?? '';
        });
        _moveMapToLocation(_selectedLocation!);
      } else {
        // إذا لم يتم الحصول على الموقع، استخدم الافتراضي
        _selectedLocation = _defaultLocation;
        _moveMapToLocation(_defaultLocation);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تعذر الحصول على الموقع الحالي')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في الحصول على الموقع: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // التبديل بين وضعية ملء الشاشة والعادية
  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedLocation == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return _isFullScreen 
        ? _buildFullScreenMap()
        : _buildCompactMap();
  }

  // الخريطة المدمجة
  Widget _buildCompactMap() {
    return GestureDetector(
      onTap: _toggleFullScreen,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // الخريطة الأساسية
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _selectedLocation!,
                  initialZoom: 14.0,
                  onTap: _onMapTap,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.eva',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // معلومات الموقع في الأعلى
              Positioned(
                top: 8,
                left: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _selectedAddress.isNotEmpty ? _selectedAddress : 'اختر موقعك على الخريطة',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Tajawal',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // أزرار التحكم
              Positioned(
                bottom: 8,
                right: 8,
                child: Column(
                  children: [
                    // زر التكبير
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.zoom_in, size: 20),
                        onPressed: () {
                          if (_selectedLocation != null) {
                            _mapController.move(
                              _selectedLocation!,
                              _mapController.zoom + 1,
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.zoom_out, size: 20),
                        onPressed: () {
                          if (_selectedLocation != null) {
                            _mapController.move(
                              _selectedLocation!,
                              _mapController.zoom - 1,
                            );
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.fullscreen, size: 20),
                        onPressed: _toggleFullScreen,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // ✅ زر تحديث الموقع الحالي - يستخدم getCurrentLocation()
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, color: Colors.blue, size: 20),
                    onPressed: _isLoading ? null : _updateToCurrentLocation,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الخريطة بملء الشاشة
  Widget _buildFullScreenMap() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر موقع الفعالية'),
        backgroundColor: Styles.mainColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation!,
              initialZoom: 14.0,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.eva',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // معلومات الموقع في الأعلى
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedAddress.isNotEmpty 
                              ? _selectedAddress 
                              : 'اضغط على الخريطة لتحديد الموقع',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedLocation != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'الإحداثيات: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // أزرار التحكم في الأسفل
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_in, size: 24),
                    onPressed: () {
                      if (_selectedLocation != null) {
                        _mapController.move(
                          _selectedLocation!,
                          _mapController.zoom + 1,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.zoom_out, size: 24),
                    onPressed: () {
                      if (_selectedLocation != null) {
                        _mapController.move(
                          _selectedLocation!,
                          _mapController.zoom - 1,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // ✅ زر تحديث الموقع - يستخدم getCurrentLocation()
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.my_location, color: Colors.white, size: 24),
                    onPressed: _isLoading ? null : _updateToCurrentLocation,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.white, size: 24),
                    onPressed: _toggleFullScreen,
                  ),
                ),
              ],
            ),
          ),
          
          // زر العودة
          Positioned(
            top: 80,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 24),
                onPressed: _toggleFullScreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}