// lib/features/profile/views/widgets/profile_events_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/home/views/widgets/personal_event_card.dart';
import 'profile_constant_event_tile.dart';
import 'profile_events_tab_bar.dart';

class ProfileEventsSection extends StatefulWidget {
  const ProfileEventsSection({super.key});

  @override
  State<ProfileEventsSection> createState() => _ProfileEventsSectionState();
}

class _ProfileEventsSectionState extends State<ProfileEventsSection> {
  int _selectedTab = 0;

  // بديل عن قائمة ألوان خارجية — تدوير بين لونَي العلامة التجارية الموجودين فعلياً
  final List<Color> _colors = [Styles.mainColor, Styles.primaryLight];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) => current is Authenticated,
      builder: (context, state) {
        if (state is! Authenticated || state.user is! NormalUser) {
          return const SizedBox.shrink();
        }

        final normalUser = state.user as NormalUser;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileEventsTabBar(
              selectedIndex: _selectedTab,
              onTabSelected: (index) => setState(() => _selectedTab = index),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _selectedTab == 0
                  ? _buildPersonalEvents(normalUser)
                  : _buildConstantEvents(context, normalUser),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPersonalEvents(NormalUser user) {
    final events = user.personalEvents;
    if (events.isEmpty) {
      return _emptyState(key: 'personal-empty', icon: Icons.event_busy_rounded, text: 'No personal events yet');
    }
    return GridView.builder(
      key: const ValueKey('personal-grid'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return PersonalEventCard(
          eventIcon: event.icon,
          color: _colors[index % _colors.length],
          eventTitle: event.name,
          progress: event.progress,
          daysLeft: event.startDate.difference(DateTime.now()).inDays,
          event: event,
        );
      },
    );
  }

  Widget _buildConstantEvents(BuildContext context, NormalUser user) {
    final events = user.constantEvents;
    if (events.isEmpty) {
      return _emptyState(key: 'constant-empty', icon: Icons.calendar_today_rounded, text: 'No constant events yet');
    }
    return ListView.builder(
      key: const ValueKey('constant-list'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ProfileConstantEventTile(
          event: event,
          onTap: () => GoRouter.of(context).push(
            AppRoutes.kConstantEventDetails,
            extra: {'event': event},
          ),
        );
      },
    );
  }

  Widget _emptyState({required String key, required IconData icon, required String text}) {
    return Padding(
      key: ValueKey(key),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Styles.textSecondary.withOpacity(0.5)),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(color: Styles.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}