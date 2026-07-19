import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/styles.dart';

class MapScreen extends StatelessWidget {
  final LatLng location;
  final String title;

  const MapScreen({
    super.key, 
    required this.location, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Styles.mainColor, // لون تطبيقكِ الأساسي
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: location,
          initialZoom: 16.0, // زووم أقرب وأوضح للشاشة الكاملة
          // نترك الخيارات الافتراضية هنا لتكون الخريطة تفاعلية بالكامل (تكبير، تصغير، تدوير)
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.your_app_name',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: location,
                width: 50,
                height: 50,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}