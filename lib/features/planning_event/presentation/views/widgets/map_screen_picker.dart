// features/planning_event/presentation/views/map_picker_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late MapController _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;
  bool _isMapReady = false;
  
  // ✅ موقع افتراضي فقط كملاذ أخير
  final LatLng _defaultLocation = const LatLng(24.7136, 46.6753);

  // ✅ متغير للتحكم في مستوى التكبير
  double _currentZoom = 14.0;
  final double _minZoom = 3.0;  // ✅ مستوى تصغير أوسع
  final double _maxZoom = 18.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentLocation();
    });
  }

  // ✅ دالة محسنة لتحميل الموقع
  Future<void> _loadCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      final cubit = context.read<EventPlanningCubit>();
      final event = cubit.currentEvent;
      
      // ✅ أولاً: محاولة الحصول على الموقع الحالي للجهاز
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (permission != LocationPermission.denied && 
          permission != LocationPermission.deniedForever && 
          serviceEnabled) {
        try {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10),
          );
          
          // تحويل الإحداثيات إلى عنوان
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            final address = _formatAddress(placemarks.first);
            _selectedLocation = LatLng(position.latitude, position.longitude);
            _selectedAddress = address;
            
            // حفظ في الـ Cubit
            cubit.updateGPSLocation(
              address,
              position.latitude,
              position.longitude,
            );
            
            _moveMapToLocation(_selectedLocation!);
            return;
          }
        } catch (e) {
          // إذا فشل الحصول على الموقع، ننتقل للخيار التالي
          debugPrint('فشل الحصول على الموقع الحالي: $e');
        }
      }
      
      // ✅ ثانياً: إذا كان هناك موقع محفوض في الـ Cubit
      if (event != null && event.latitude != null && event.longitude != null) {
        _selectedLocation = LatLng(event.latitude!, event.longitude!);
        _selectedAddress = event.gpsAddress ?? '';
        _moveMapToLocation(_selectedLocation!);
        return;
      }
      
      // ✅ ثالثاً: استخدام الموقع الافتراضي (كملاذ أخير)
      _selectedLocation = _defaultLocation;
      _selectedAddress = 'الرياض، السعودية';
      _moveMapToLocation(_defaultLocation);
      
    } catch (e) {
      _selectedLocation = _defaultLocation;
      _selectedAddress = 'الرياض، السعودية';
      _moveMapToLocation(_defaultLocation);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _moveMapToLocation(LatLng location) {
    if (_isMapReady && mounted) {
      _mapController.move(location, _currentZoom);
    }
  }

  void _onMapTap(TapPosition position, LatLng point) {
    setState(() {
      _selectedLocation = point;
    });
    _getAddressFromCoordinates(point);
  }

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
      } else {
        setState(() {
          _selectedAddress = '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
    
    return parts.join(', ');
  }

  Future<void> _updateToCurrentLocation() async {
    setState(() => _isLoading = true);
    
    try {
      final cubit = context.read<EventPlanningCubit>();
      await cubit.getCurrentLocation();
      
      final event = cubit.currentEvent;
      if (event != null && event.latitude != null && event.longitude != null) {
        setState(() {
          _selectedLocation = LatLng(event.latitude!, event.longitude!);
          _selectedAddress = event.gpsAddress ?? '';
        });
        _moveMapToLocation(_selectedLocation!);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في الحصول على الموقع: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ✅ دالة البحث عن موقع
  void _searchLocation() async {
    final TextEditingController searchController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('البحث عن موقع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'أدخل اسم المدينة أو المنطقة...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pop(context, value);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                Navigator.pop(context, searchController.text);
              }
            },
            child: const Text('بحث'),
          ),
        ],
      ),
    ).then((searchQuery) async {
      if (searchQuery != null && searchQuery.isNotEmpty) {
        await _searchAndNavigateToLocation(searchQuery);
      }
    });
  }

  // ✅ دالة للبحث والانتقال إلى الموقع
  Future<void> _searchAndNavigateToLocation(String query) async {
    setState(() => _isLoading = true);
    
    try {
      List<Location> locations = await locationFromAddress(query);
      
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        
        // الحصول على العنوان
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          final address = _formatAddress(placemarks.first);
          setState(() {
            _selectedLocation = latLng;
            _selectedAddress = address;
          });
          _moveMapToLocation(latLng);
          
          // حفظ في الـ Cubit
          final cubit = context.read<EventPlanningCubit>();
          cubit.updateGPSLocation(
            address,
            location.latitude,
            location.longitude,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لم يتم العثور على الموقع')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في البحث: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _confirmLocation() {
    if (_selectedLocation != null && _selectedAddress.isNotEmpty) {
      final cubit = context.read<EventPlanningCubit>();
      cubit.updateGPSLocation(
        _selectedAddress,
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      
      Navigator.pop(context, {
        'address': _selectedAddress,
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار موقع أولاً')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر موقع الفعالية'),
        backgroundColor: Styles.mainColor,
        foregroundColor: Colors.white,
        actions: [
          // ✅ زر البحث
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchLocation,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmLocation,
          ),
        ],
      ),
      body: _selectedLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ✅ الخريطة مع دعم التكبير والتصغير الكامل
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation!,
                    initialZoom: _currentZoom,
                    minZoom: _minZoom,  // ✅ مستوى التصغير الأدنى
                    maxZoom: _maxZoom,  // ✅ مستوى التكبير الأقصى
                    onTap: _onMapTap,
                    onPositionChanged: (position, hasGesture) {
                      // ✅ تحديث مستوى التكبير الحالي
                      if (hasGesture) {
                        _currentZoom = position.zoom ?? 0;
                      }
                    },
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
                
                // ✅ معلومات الموقع في الأعلى
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
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
                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedAddress.isNotEmpty 
                                    ? _selectedAddress 
                                    : 'اضغط على الخريطة لتحديد الموقع',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (_selectedLocation != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'الإحداثيات: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                
                // ✅ أزرار التحكم في الأسفل مع مستوى تكبير محسن
                Positioned(
                  bottom: 20,
                  right: 20,
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
                          icon: const Icon(Icons.zoom_in, size: 24),
                          onPressed: () {
                            if (_selectedLocation != null && _isMapReady) {
                              _currentZoom = (_currentZoom + 1).clamp(_minZoom, _maxZoom);
                              _mapController.move(
                                _selectedLocation!,
                                _currentZoom,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      // زر التصغير
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
                            if (_selectedLocation != null && _isMapReady) {
                              _currentZoom = (_currentZoom - 1).clamp(_minZoom, _maxZoom);
                              _mapController.move(
                                _selectedLocation!,
                                _currentZoom,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // زر الموقع الحالي
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
                      // زر تأكيد الموقع
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
                          onPressed: _confirmLocation,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // ✅ زر العودة
                Positioned(
                  top: 60,
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
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                
                // ✅ زر البحث في الأسفل
                Positioned(
                  bottom: 20,
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
                      icon: const Icon(Icons.search, color: Colors.blue, size: 24),
                      onPressed: _searchLocation,
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