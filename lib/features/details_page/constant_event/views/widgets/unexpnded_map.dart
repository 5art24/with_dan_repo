import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/widgets/map_screen.dart';

class UnExpandedMap extends StatelessWidget {
  const UnExpandedMap({
    super.key,
    required this.serviceCoordinates,
    required this.serviceName,
  });

  final LatLng serviceCoordinates;
  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When you tap on the small map, it switches to full screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(
              location: serviceCoordinates,
              title: serviceName,
              //name of service displayed on the top
            ),
          ),
        );
      },
      child: Container(
        height: 150,
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
              // 1. The displayed thumbnail map
              FlutterMap(
                options: MapOptions(
                  initialCenter: serviceCoordinates,
                  initialZoom: 14.0,
                  // We completely disable the interaction here so the NormalUser doesn’t have trouble scrolling the screen up and down
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  //the basic map
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.eva',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: serviceCoordinates,
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

              // 2. Transparent zoom button
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.fullscreen, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        "Zoom in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
