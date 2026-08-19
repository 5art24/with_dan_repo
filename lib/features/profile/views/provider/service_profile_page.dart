import 'package:flutter/material.dart';
import '../../../../../core/models/service.dart';
import '../../../../../core/models/user.dart';
import 'package:project1_collage/core/styles.dart';
import '../widgets/profile_header.dart';
import '../widgets/service_grid_card.dart';
import '../widgets/service_profile_drawer.dart';

/// صفحة بروفايل عارض الخدمة — تعرض الصورة، الاسم، الوصف، الموقع، والخدمات
class ServiceProfilePage extends StatefulWidget {
  const ServiceProfilePage({super.key});

  @override
  State<ServiceProfilePage> createState() => _ServiceProfilePageState();
}

class _ServiceProfilePageState extends State<ServiceProfilePage> {
  // بيانات وهمية مؤقتة (mock) حتى ترتبط بالـ API لاحقاً
  final User _provider = User(
    username: 'luminous_studios',
    urlImage: '', id: '',
  );

  final String _bio =
      'Photographer & lighting specialist for weddings and events.';

  final String _location = 'Damascus, Syria';

  final List<ServiceModel> _services = [
    ServiceModel(
      id: 's1',
      name: 'Wedding Photography',
      imageUrl: const [],
      rating: 4.8,
      price: 1200,
      location: 'Damascus',
      type: ServiceType.photograph,
      description: 'Full-day wedding coverage',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 7,
    ),
    ServiceModel(
      id: 's2',
      name: 'Ambient Lighting',
      imageUrl: const [],
      rating: 4.6,
      price: 600,
      location: 'Damascus',
      type: ServiceType.lighting,
      description: 'Indoor event lighting setup',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 3,
    ),
    ServiceModel(
      id: 's3',
      name: 'Garden Venue',
      imageUrl: const [],
      rating: 4.9,
      price: 3500,
      location: 'Bloudan',
      type: ServiceType.venue,
      description: 'Outdoor venue for up to 300 guests',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 14,
    ),
    ServiceModel(
      id: 's4',
      name: 'DJ Set',
      imageUrl: const [],
      rating: 4.7,
      price: 450,
      location: 'Damascus',
      type: ServiceType.dj,
      description: 'Professional DJ for 4 hours',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 5,
    ),
    ServiceModel(
      id: 's5',
      name: 'Floral Decor',
      imageUrl: const [],
      rating: 4.5,
      price: 800,
      location: 'Aleppo',
      type: ServiceType.decor,
      description: 'Custom floral arrangements',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 4,
    ),
    ServiceModel(
      id: 's6',
      name: 'Pre-wedding Shoot',
      imageUrl: const [],
      rating: 5.0,
      price: 700,
      location: 'Tartous',
      type: ServiceType.photograph,
      description: 'Outdoor pre-wedding photoshoot',
      provider: User(username: 'p', urlImage: '', id: '',),
      bookings: const [],
      preparationDays: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      drawer: ServiceProfileDrawer(
        userName: _provider.username,
        userEmail: '',
        userImage: _provider.urlImage.isEmpty ? null : _provider.urlImage,
        onLogout: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out')),
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Styles.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Styles.primaryLight),
        title: Text(
          _provider.username,
          style: const TextStyle(
            color: Styles.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildProfileHeader(),
          ),
          const SliverToBoxAdapter(
            child: Divider(height: 1, thickness: 0.5, color: Styles.surface),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.grid_on, size: 18, color: Styles.primaryLight),
                  SizedBox(width: 6),
                  Text(
                    'Services',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Styles.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final s = _services[index];
                  return ServiceGridCard(
                    service: s,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Open ${s.name}')),
                      );
                    },
                  );
                },
                childCount: _services.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile image and name
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
                  child: _provider.urlImage.isNotEmpty
                      ? Image.network(_provider.urlImage, fit: BoxFit.cover)
                      : const Icon(Icons.person,
                          size: 40, color: Styles.primaryLight),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luminous Studios',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${_provider.username}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bio
          if (_bio.isNotEmpty)
            Text(
              _bio,
              style: const TextStyle(
                fontSize: 14,
                color: Styles.textSecondary,
                height: 1.5,
              ),
            ),
          const SizedBox(height: 16),

          // Location
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 18, color: Styles.primaryLight),
              const SizedBox(width: 6),
              Text(
                _location,
                style: const TextStyle(
                  fontSize: 14,
                  color: Styles.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _buildStat('${_services.length}', 'Services'),
              const SizedBox(width: 24),
              _buildStat('4.7', 'Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

