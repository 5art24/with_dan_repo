import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class SelectedServicesDisplayBody extends StatelessWidget {
  final PersonalEvent event;

  const SelectedServicesDisplayBody({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // جلب عدد أيام الفعالية لحساب الإجمالي
    final cubit = context.read<EventPlanningCubit>();
    final eventDays = cubit.eventDurationInDays;
    final services = event.bookedServices;

    // حساب المجموع الكلي للخدمات المحجوزة
    final totalPrice = services.fold(
      0,
      (sum, item) => sum + (item.price * eventDays),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FA),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const crossAxisCount = 2;
                const spacing = 12.0;
                const horizontalPadding = 24.0;
                final totalSpacing = spacing * (crossAxisCount - 1);
                final availableWidth =
                    constraints.maxWidth - horizontalPadding * 2 - totalSpacing;
                final cardWidth = availableWidth / crossAxisCount;

                const cardHeight = 280.0;
                final dynamicAspectRatio = cardWidth / cardHeight;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // 1. العنوان الرئيسي للصفحة
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 8,
                          bottom: 18,
                        ),
                        child: Text(
                          "Selected Services",
                          style: Styles.largeTitle,
                        ),
                      ),
                    ),

                    // 2. حالة القائمة الفارغة
                    if (services.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text("No services booked yet."),
                        ),
                      )
                    else
                      // 3. شبكة عرض الخدمات المتجاوبة (عرض فقط)
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: dynamicAspectRatio,
                            crossAxisSpacing: spacing,
                            mainAxisSpacing: spacing,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final service = services[index];

                              return ServiceCard(
                                key: ValueKey(service.id),
                                service: service,
                                eventDays: eventDays,
                                isSelectionMode: false,
                                isSelected: false,
                                onTap: () {
                                  // الانتقال لتفاصيل الخدمة للعرض فقط
                                  GoRouter.of(context).push(
                                    AppRoutes.kServiceDetails,
                                    extra: {'service': service, 'cubit': cubit},
                                  );
                                },
                              );
                            },
                            childCount: services.length,
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
          ),

          // 🌟 الجزء السفلي: عرض السعر الإجمالي وحالة الحجز المؤكدة
          Container(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total: \$$totalPrice",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // 🌟 بطاقة حالة الحجز المؤكدة
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Booking Status:",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "CONFIRMED",
                            style: TextStyle(
                              color: Styles.mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        backgroundColor:Styles.mainColor,
                        radius: 16,
                        child: Icon(Icons.check, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}