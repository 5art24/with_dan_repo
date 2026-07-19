import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart'; // مسار الموديل لديكِ
import 'package:project1_collage/core/models/user.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class DisplayingSelectedServices extends StatefulWidget {
  const DisplayingSelectedServices({super.key, required this.event});
  final PersonalEvent event;
  @override
  State<DisplayingSelectedServices> createState() =>
      _DisplayingSelectedServicesState();
}

class _DisplayingSelectedServicesState
    extends State<DisplayingSelectedServices> {
  late List<ServiceModel> services;
  static const mainColor = Styles.mainColor;

  // // قائمة تجريبية للخدمات المحجوزة
  // List<ServiceModel> services = [
  //   ServiceModel(
  //     id: '1',
  //     name: 'Lighting Service',
  //     price: 200,
  //     location: 'Syria',
  //     rating: 3.0,
  //     imageUrl: [],
  //     bookings: null,
  //     provider: User(
  //       username: 'user1',
  //       urlImage:
  //           "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
  //     ),
  //     type: ServiceType.lighting,
  //     description: '',
  //   ),
  //   ServiceModel(
  //     id: '2',
  //     name: 'hi900,4 Lighting',
  //     price: 900,
  //     location: 'Syria',
  //     rating: 4.0,
  //     imageUrl: [],
  //     bookings: null,
  //     provider: User(
  //       username: 'user1',
  //       urlImage:
  //           "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
  //     ),
  //     type: ServiceType.lighting,
  //     description: '',
  //   ),
  //   ServiceModel(
  //     id: '3',
  //     name: 'hi700,5 Light',
  //     price: 700,
  //     location: 'Syria',
  //     rating: 5.0,
  //     imageUrl: [],
  //     bookings: null,
  //     provider: User(
  //       username: 'user1',
  //       urlImage:
  //           "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200&auto=format&fit=crop",
  //     ),
  //     type: ServiceType.lighting,
  //     description: '',
  //   ),
  // ];

  bool isSelectionMode = false;
  final Set<String> selectedServiceIds = {};

  @override
  void initState() {
    super.initState();
    services = widget.event.bookedServices;
  }

  int get totalPrice => services.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (isSelectionMode && selectedServiceIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    services.removeWhere(
                      (item) => selectedServiceIds.contains(item.id),
                    );
                    selectedServiceIds.clear();
                    isSelectionMode = false;
                  });
                },
                icon: const Icon(Icons.delete_outline, size: 16),
                label: Text("Delete (${selectedServiceIds.length})"),
              ),
            ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              GoRouter.of(context).push(AppRoutes.kAddTask, extra: {'event': widget.event});
            },
          ),
        ],
      ),
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
                    // 1. العنوان الرئيسي يتحول إلى جزء من السكرول عبر SliverToBoxAdapter
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 8,
                          bottom: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Selected Services",
                              style: Styles.largeTitle,
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: mainColor,
                                side: const BorderSide(
                                  color: mainColor,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  isSelectionMode = !isSelectionMode;
                                  if (!isSelectionMode)
                                    selectedServiceIds.clear();
                                });
                              },
                              child: Text(
                                isSelectionMode ? "Cancel" : "Select",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. حالة القائمة الفارغة
                    if (services.isEmpty)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text("No services booked yet.")),
                      )
                    else
                      // 3. شبكة عرض الخدمات المتجاوبة كجزء مكمل للتمرير
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
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final service = services[index];
                            final isSelected = selectedServiceIds.contains(
                              service.id,
                            );

                            return ServiceCard(
                              service: service,
                              isSelectionMode: isSelectionMode,
                              isSelected: isSelected,
                              onSelectToggle: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedServiceIds.remove(service.id);
                                  } else {
                                    selectedServiceIds.add(service.id);
                                  }
                                });
                              },
                              onTap: () {
                                /*
                                  GoRouter.of(context).push(
                                    AppRoutes.kServiceDetails,
                                    extra: {'service': service, 'cubit': cubit},
                                  );
                                  */
                              },
                            );
                          }, childCount: services.length),
                        ),
                      ),
                    // مسافة أمان صغيرة أسفل السكرول قبل الشريط الثابت
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            ),
          ),

          // شريط السعر السفلي وأزرار التحكم (يبقى ثابتاً في الأسفل خارج التمرير)
          // شريط السعر السفلي وأزرار التحكم
          Container(
            padding: const EdgeInsets.only(
              top: 20,
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
              children: [
                // عرض السعر وتعديل الدفع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: \$$totalPrice",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    // 1. زر تعديل معلومات الدفع (نصي تفاعلي مع سهم مائل وألوان متناسقة)
                    InkWell(
                      onTap: () {
                        // الانتقال لصفحة تعديل معلومات الدفع
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Modify Payment",
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                // خط سفلي متقطع أو خفيف يعطي إيحاء الرابط القابل للضغط
                                decoration: TextDecoration.underline,
                                decorationColor: mainColor.withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(width: 4),
                            // أيقونة السهم المائل تخبر المستخدم أن هذا الرابط سيفتتح صفحة أخرى
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 14,
                              color: mainColor.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. زر إضافة أو تعديل الخدمات (نصي بلمسة زر حقيقي: حدود خفيفة جداً وظل ناعم)
                InkWell(
                  onTap: () {
                    // كود إضافة أو تعديل الخدمات
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white, // خلفية بيضاء ليبقى نصياً
                      borderRadius: BorderRadius.circular(12),
                      // حد خارجي رمادي دقيق جداً (Border) ليحدد أبعاد الزر للمستخدم
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1.5,
                      ),
                      // ظل ناعم وخفيف جداً (Elevation) ليعطيه عمقاً ويشعر المستخدم أنه قابل للضغط
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Add / Modify Services",
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. زر تأكيد الحجز الرئيسي (الزر المصمت الأساسي في الصفحة مع ظل احترافي ملوّن)
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      // إضافة ظل يحمل تلميحة من لون الزر نفسه يعطي مظهر فخم جداً (Glow Effect)
                      BoxShadow(
                        color: mainColor.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation:
                          0, // نعتمد على ظل الـ BoxDecoration الخارجي لأنه أجمل وأدق
                    ),
                    onPressed: services.isEmpty
                        ? null
                        : () {
                            // كود تأكيد الحجز
                          },
                    child: const Text(
                      "Confirm Booking",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
