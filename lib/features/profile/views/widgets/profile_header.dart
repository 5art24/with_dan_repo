import 'package:flutter/material.dart';
import '../../../../core/models/user.dart';
import 'package:project1_collage/core/styles.dart';

/// هيدر بروفايل عارض الخدمة — شبيه بانستا.
class ProfileHeader extends StatelessWidget {
  final User provider;
  final String displayName;
  final String? bio;
  final int servicesCount;
  final int reviewsCount;
  final int followersCount;
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final VoidCallback onMessageTap;

  const ProfileHeader({
    Key? key,
    required this.provider,
    required this.displayName,
    this.bio,
    required this.servicesCount,
    required this.reviewsCount,
    required this.followersCount,
    required this.isFollowing,
    required this.onFollowTap,
    required this.onMessageTap,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Styles.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Styles.primaryLight.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    color: Styles.cardBackground,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: provider.urlImage.isNotEmpty
                      ? Image.network(provider.urlImage, fit: BoxFit.cover)
                      : const Icon(Icons.person,
                          size: 40, color: Styles.primaryLight),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('$servicesCount', 'Services'),
                    _stat('$reviewsCount', 'Reviews'),
                    _stat('$followersCount', 'Followers'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            displayName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Styles.textPrimary,
            ),
          ),
          const SizedBox(height: 2),

          if (bio != null && bio!.isNotEmpty)
            Text(
              bio!,
              style: const TextStyle(
                fontSize: 13,
                color: Styles.textSecondary,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onFollowTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? Styles.cardBackground
                        : Styles.primaryLight,
                    foregroundColor: isFollowing
                        ? Styles.textPrimary
                        : Colors.white,
                    elevation: isFollowing ? 0 : 3,
                    side: isFollowing
                        ? const BorderSide(color: Styles.surface, width: 1)
                        : BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onMessageTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Styles.cardBackground,
                    foregroundColor: Styles.textPrimary,
                    elevation: 0,
                    side: const BorderSide(color: Styles.surface, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Styles.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Styles.textSecondary),
        ),
      ],
    );
  }
}


