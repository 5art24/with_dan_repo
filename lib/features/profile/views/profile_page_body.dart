// lib/features/profile/views/profile_page_body.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/service_provider_user.dart';
import 'package:project1_collage/core/models/user.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';
import 'package:project1_collage/features/profile/views/widgets/events_section.dart';
import 'widgets/service_profile_drawer.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is Authenticated,
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Scaffold(
            backgroundColor: Styles.background,
            body: Center(child: CircularProgressIndicator(color: Styles.mainColor)),
          );
        }

        final User user = state.user;

        return Scaffold(
          backgroundColor: Styles.background,
          drawer: ProfileDrawer(
            username: user.username,
            userImage: user.urlImage.isEmpty ? null : user.urlImage,
            userEmail: '',
            onLogout: () => context.read<AuthCubit>().logout(),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Styles.background,
                elevation: 0,
                pinned: true,
                iconTheme: const IconThemeData(color: Styles.primaryLight),
                title: Text(
                  user.username,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildProfileHeader(user)),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              if (user is ServiceProviderUser)
                ..._buildServiceProviderSlivers(context, user),

              if (user is NormalUser)
                const SliverToBoxAdapter(child: ProfileEventsSection()),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }

  //================= Header =================
  Widget _buildProfileHeader(User user) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Styles.cardBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 78,
                height: 78,
                padding: const EdgeInsets.all(3),
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
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Styles.cardBackground,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: user.urlImage.isNotEmpty
                      ? Image.network(user.urlImage, fit: BoxFit.cover)
                      : const Icon(Icons.person_rounded, size: 36, color: Styles.primaryLight),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (user.workOrStudy != null && user.workOrStudy!.isNotEmpty)
                      Text(
                        user.workOrStudy!,
                        style: const TextStyle(fontSize: 13, color: Styles.textSecondary),
                      ),
                    if (user.isVerified) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Styles.mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 12, color: Styles.mainColor),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Styles.mainColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: Styles.surface),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildStatsForUser(user),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStatsForUser(User user) {
    if (user is ServiceProviderUser) {
      return [_buildStat('${user.services.length}', 'Services')];
    }
    if (user is NormalUser) {
      return [
        _buildStat('${user.personalEvents.length}', 'Personal'),
        _buildStat('${user.constantEvents.length}', 'Constant'),
      ];
    }
    return const [];
  }

  Widget _buildStat(String value, String label) {
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
        Text(label, style: const TextStyle(fontSize: 12, color: Styles.textSecondary)),
      ],
    );
  }

  //================= Services (ServiceProviderUser فقط) =================
  List<Widget> _buildServiceProviderSlivers(BuildContext context, ServiceProviderUser provider) {
    return [
      const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 16, 10),
          child: Row(
            children: [
              Icon(Icons.grid_view_rounded, size: 18, color: Styles.primaryLight),
              SizedBox(width: 8),
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
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        sliver: provider.services.isEmpty
            ? const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('No services yet', style: TextStyle(color: Styles.textSecondary)),
                  ),
                ),
              )
            : SliverLayoutBuilder(
                builder: (context, constraints) {
                  const crossAxisCount = 2;
                  const spacing = 14.0;
                  final availableWidth = constraints.crossAxisExtent - spacing;
                  final cardWidth = availableWidth / crossAxisCount;
                  const cardHeight = 230.0;
                  final dynamicAspectRatio = cardWidth / cardHeight;

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: dynamicAspectRatio,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final service = provider.services[index];
                        return ServiceCard(
                          service: service,
                          isSelectionMode: false,
                          isSelected: false,
                          onTap: () => GoRouter.of(context).push(
                            AppRoutes.kServiceDetails,
                            extra: {'service': service, 'cubit': null},
                          ),
                        );
                      },
                      childCount: provider.services.length,
                    ),
                  );
                },
              ),
      ),
    ];
  }
}