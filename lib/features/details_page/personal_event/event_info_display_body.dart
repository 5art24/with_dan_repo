import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class EventInfoDisplayBody extends StatelessWidget {
  final VoidCallback? onEditPressed;

  const EventInfoDisplayBody({super.key, this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    final categories = ["Birthday", "Wedding", "Party", "Meeting", "Concert"];

    return BlocBuilder<EventPlanningCubit, EventPlanningState>(
      builder: (context, state) {
        // 🟢 جلب الفعالية الحالية مباشرة من الـ Cubit
        final currentEvent = context.watch<EventPlanningCubit>().currentEvent;

        if (currentEvent == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text("Plan Your Event", style: Styles.largeTitle),
                  const SizedBox(height: 20),

                  // 1️⃣ Category
                  Text(
                    "Category",
                    style: Styles.smallTitle.copyWith(color: Styles.mainColor),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected =
                            cat.toLowerCase() ==
                            currentEvent.category.toLowerCase();
                        return _buildCategoryChip(cat, isSelected);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2️⃣ Event Title
                  Text(
                    "Event Title",
                    style: Styles.smallTitle.copyWith(color: Styles.mainColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentEvent.name.isNotEmpty
                        ? currentEvent.name
                        : "بدون عنوان",
                    style: Styles.body,
                  ),
                  const SizedBox(height: 20),

                  // 3️⃣ Date
                  Text(
                    "Date",
                    style: Styles.smallTitle.copyWith(color: Styles.mainColor),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_formatDate(currentEvent.startDate)}->${_formatDate(currentEvent.endDate ?? currentEvent.startDate)}",
                        style: Styles.body,
                      ),
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 25,
                        color: Styles.mainColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4️⃣ Location
                  Text(
                    "Location",
                    style: Styles.smallTitle.copyWith(color: Styles.mainColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentEvent.hasValidLocation
                        ? currentEvent.location
                        : (currentEvent.city.isNotEmpty
                              ? currentEvent.city
                              : "لم يتم تحديد المنطقة بعد"),
                    style: Styles.body,
                  ),
                  const SizedBox(height: 20),

                  // 5️⃣ Description
                  Text(
                    "Description",
                    style: Styles.smallTitle.copyWith(color: Styles.mainColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (currentEvent.description != null &&
                            currentEvent.description!.isNotEmpty)
                        ? currentEvent.description!
                        : "لا يوجد وصف لهذه الفعالية",
                    style: Styles.body,
                  ),
                  const SizedBox(height: 140), // مساحة للأزرار العائمة
                ],
              ),
            ),

            // 🟢 الأزرار العائمة (حذف وتعديل)
            Positioned(
              bottom: 16,
              right: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🗑️ زر الحذف
                  FloatingActionButton(
                    heroTag: 'delete_event_btn',
                    backgroundColor: Colors.redAccent,
                    onPressed: () {
                      _showDeleteDialog(context, currentEvent.id);
                    },
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),

                  const SizedBox(height: 12), // مسافة بين زر الحذف والتعديل
                  // ✏️ زر التعديل
                  FloatingActionButton(
                    heroTag: 'edit_event_btn',
                    backgroundColor: Styles.mainColor,
                    onPressed:
                        onEditPressed ??
                        () {
                          final cubit = context.read<EventPlanningCubit>();
                          final currentEvent = cubit.currentEvent;

                          if (currentEvent != null) {
                            cubit.loadEvent(currentEvent);

                            GoRouter.of(
                              context,
                            ).push(AppRoutes.kEditEvent, extra: cubit);
                          }
                        },
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // 🟢 حوار تأكيد الحذف
  void _showDeleteDialog(BuildContext context, String eventId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // 1. إغلاق الحوار
              Navigator.pop(dialogContext);

              // 2. استدعاء حذف الفعالية من AuthCubit
              context.read<AuthCubit>().deletePersonalEvent(eventId);

              // 3. الرجوع إلى الشاشة السابقة
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Styles.mainColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }
}
