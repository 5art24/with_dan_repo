// lib/features/profile/views/widgets/profile_constant_event_tile.dart
import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/styles.dart';

class ProfileConstantEventTile extends StatelessWidget {
  final ConstantEventModel event;
  final VoidCallback? onTap;

  const ProfileConstantEventTile({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Styles.cardBackground,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
              child: SizedBox(
                width: 96,
                height: 96,
                child: (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                    ? Image.network(
                        event.imageUrl![0],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Styles.surface,
                          child: const Icon(Icons.image_rounded, color: Styles.textSecondary),
                        ),
                      )
                    : Container(
                        color: Styles.surface,
                        child: const Icon(Icons.image_rounded, color: Styles.textSecondary),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 13, color: Styles.mainColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.formattedDateTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Styles.mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 13, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Styles.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded, color: Styles.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}