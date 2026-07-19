import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/styles.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});
  
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  static int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          BottomNavigationBarButton(
            index: 0,
            onTap: (index) {
                setState(() => selectedIndex = index);
              GoRouter.of(context).go(AppRoutes.kHomeView);
            },
            selectedIndex: selectedIndex,
          ),
          BottomNavigationBarButton(
            index: 1,
            onTap: (index) {
                setState(() => selectedIndex = index);
              GoRouter.of(context).go(AppRoutes.kPlanEvent);
            },
            selectedIndex: selectedIndex,
          ),
          BottomNavigationBarButton(
            selectedIndex: selectedIndex,
            index: 2,
            onTap: (index) {
              setState(() => selectedIndex = index);
              GoRouter.of(context).go(AppRoutes.kExploreConstantEvents);
            },
          ),
          BottomNavigationBarButton(
            selectedIndex: selectedIndex,
            index: 3,
            onTap: (index) {
             setState(() => selectedIndex = index);
             //should be profile
              
            },
          ),
        ],
      ),
    );
  }
}

class BottomNavigationBarButton extends StatelessWidget {
  const BottomNavigationBarButton({
    super.key,
    required this.selectedIndex, //what the user chose
    required this.index, //i define which button user pressed so i can define selectedIndex
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
              ? const Color.fromARGB(255, 92, 85, 159).withAlpha(70)
              : Colors.transparent,
        ),
        shape: WidgetStateProperty.all(const CircleBorder()),
        padding: WidgetStateProperty.all(const EdgeInsets.all(14)),
        backgroundColor: WidgetStateProperty.all(
          selectedIndex == index
              ? Styles.mainColor
              : Styles.mainColor.withAlpha(50),
        ),
      ),
    );
  }
}
