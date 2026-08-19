import 'package:flutter/material.dart';
import '../../../../core/models/service.dart';
import 'package:project1_collage/core/styles.dart';

/// كرت خدمة واحدة في شبكة البروفايل (شبيه بمنشور انستا).
class ServiceGridCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceGridCard({
    Key? key,
    required this.service,
    required this.onTap,
  }) : super(key: key);

  IconData _iconFor(ServiceType type) {
    switch (type) {
      case ServiceType.venue:
        return Icons.location_on;
      case ServiceType.dj:
        return Icons.music_note;
      case ServiceType.decor:
        return Icons.celebration;
      case ServiceType.photograph:
        return Icons.camera_alt;
      case ServiceType.lighting:
        return Icons.lightbulb;
      case ServiceType.none:
        return Icons.business;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cover = service.imageUrl != null && service.imageUrl!.isNotEmpty
        ? Image.network(
            service.imageUrl!.first,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _iconFallback(_iconFor(service.type)),
            loadingBuilder: (_, child, progress) =>
                progress == null ? child : _iconFallback(_iconFor(service.type)),
          )
        : _iconFallback(_iconFor(service.type));

return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Styles.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            cover,
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        service.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${service.price}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconFallback(IconData icon) {
    return Container(
      color: Styles.surface,
      alignment: Alignment.center,
      child: Icon(icon, size: 36, color: Styles.primaryLight),
    );
  }
}



