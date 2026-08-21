import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/app_routes.dart';

class CustomNavBar extends StatefulWidget {
  final bool isServiceProvider;
  final VoidCallback? onModeSwitch;

  const CustomNavBar({
    super.key,
    this.isServiceProvider = false,
    this.onModeSwitch,
  });
  
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  static int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // List of tabs - profile only for service providers
    final List<_NavTab> tabs = [
      _NavTab(index: 0, icon: Icons.home, route: AppRoutes.kHomeView),
      _NavTab(index: 1, icon: Icons.add, route: AppRoutes.kPlanEvent),
      _NavTab(index: 2, icon: Icons.search, route: AppRoutes.kExploreConstantEvents),
      // if (widget.isServiceProvider)
        _NavTab(index: 3, icon: Icons.person, route: AppRoutes.kProfile),
    ];

    return Container(
      constraints: const BoxConstraints(
        minHeight: 65,
        maxHeight: 75,
        maxWidth: 260,
      ),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...tabs.map((tab) => BottomNavigationBarButton(
            index: tab.index,
            onTap: (index) {
              setState(() => selectedIndex = index);
              GoRouter.of(context).go(tab.route);
            },
            selectedIndex: selectedIndex,
          )),
          // Mode switch button for service providers
          if (widget.isServiceProvider && widget.onModeSwitch != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: widget.onModeSwitch,
                icon: Icon(
                  Icons.swap_horiz,
                  size: 28,
                  color: Styles.primary,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Styles.primary.withValues(alpha: 0.1),
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavTab {
  final int index;
  final IconData icon;
  final String route;

  _NavTab({
    required this.index,
    required this.icon,
    required this.route,
  });
}

class BottomNavigationBarButton extends StatelessWidget {
  const BottomNavigationBarButton({
    super.key,
    required this.selectedIndex,
    required this.index,
    required this.onTap,
  });

  final int selectedIndex;
  final int index;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final icons = [Icons.home, Icons.search, Icons.add, Icons.person];

    return FilledButton.icon(
      onPressed: () => onTap(index),
      label: Icon(icons[index], size: 28),
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(selectedIndex == index ? 12 : 0),
        shadowColor: WidgetStateProperty.all(
          selectedIndex == index
              ? Styles.primary.withValues(alpha: 0.27)
              : Colors.transparent,
        ),
        shape: WidgetStateProperty.all(const CircleBorder()),
        padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
        backgroundColor: WidgetStateProperty.all(
          selectedIndex == index
              ? Styles.primary
              : Styles.primary.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}
