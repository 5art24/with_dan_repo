import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/details_page/constant_event/views/widgets/unexpnded_map.dart';
import 'package:project1_collage/features/details_page/shared_widgets/back_and_favorite_button.dart';
import 'package:project1_collage/core/widgets/calendar.dart';
import 'package:project1_collage/features/details_page/shared_widgets/details_custom_button.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_description.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_images.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_provider.dart';
import 'package:project1_collage/features/details_page/shared_widgets/dots_indicator.dart';
import 'package:project1_collage/core/widgets/map_screen.dart';
import 'package:project1_collage/features/details_page/service/views/widgets/unsupported_images.dart';
import 'package:project1_collage/features/details_page/shared_widgets/info_tile.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // استيراد حزمة الخرائط
// استيراد حزمة الإحداثيات

class DetailsPageBody extends StatefulWidget {
  const DetailsPageBody({super.key, required this.serviceModel});
  final ServiceModel serviceModel;

  @override
  State<DetailsPageBody> createState() => _DetailsPageBodyState();
}

class _DetailsPageBodyState extends State<DetailsPageBody> {
  // التحكم في الـ PageView ومعرفة الصفحة الحالية
  final PageController _pageController = PageController();

  // قائمة روابط الصور التجريبية للمهرجان
  final List<String> _images = [
    'https://picsum.photos/400/250',
    // "assets/icons/photograph.png",
    // "assets/icons/dj.png",
    // "assets/icons/lighting.png",
    'https://picsum.photos/id/1015/400/300', // منظر جبلي
    'https://picsum.photos/id/104/400/300', // كلب
    'https://picsum.photos/id/106/400/300', // زهور
    'https://picsum.photos/id/155/400/300',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventCubit = context.watch<EventPlanningCubit>();
    final currentEvent = eventCubit.currentEvent;
    const Color primaryColor = Styles.mainColor;

    // ✅ حساب التوفر
    final isAvailable = _isServiceAvailableForEvent();

    List<String>? imageUrls = widget.serviceModel.imageUrl;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //==============================Top Image Slider===========================

                // التحقق مما إذا كانت القائمة فارغة أو تساوي null
                (imageUrls == null || imageUrls.isEmpty)
                    ?
                      // يظهر هذا الـ Container مباشرة إذا لم تتوفر أي صور
                      UnsupportedImages()
                    : DisplayingImages(
                        pageController: _pageController,
                        primaryColor: primaryColor,
                        imageUrls: imageUrls,
                      ),

                // Service details content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceModel.name,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: primaryColor.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.serviceModel.type.name,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.star, color: primaryColor, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            widget.serviceModel.rating.toString(),
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      InfoTile(
                        icon: Icons.location_on,
                        title: widget.serviceModel.location,
                        subtitle: '', // نص فارغ
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 20),
                      const InfoTile(
                        icon: Icons.confirmation_number_outlined,
                        title: '\$20.00 - \$100.00',
                        subtitle:
                            'The final price is determined after contacting.',
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      DispalyingProvider(
                        service: widget.serviceModel,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'About Service',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DisplayingDescription(
                        description: widget.serviceModel.description,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Availability',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ServiceCalendarWidget(
                        bookings: widget.serviceModel.bookings ?? [],
                        eventDate: currentEvent?.startDate,
                        eventEndDate: currentEvent?.endDate, // ✅ جديد
                        preparationDays: widget.serviceModel.preparationDays,
                      ),
                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: DetailsCustomButton(
                          isEnabled:
                              isAvailable &&
                              currentEvent != null, // فقط للتلوين/الشكل
                          onPressed: () =>
                              _onAddPressed(isAvailable, currentEvent),
                        ),
                      ),
                      SizedBox(height: 55),
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

  void _onAddPressed(bool isAvailable, dynamic currentEvent) {
    if (currentEvent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار فعالية أولاً')),
      );
      return;
    }

    if (!isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'عذراً، الخدمة غير متوفرة في وقت تاريخ فعاليتك (خذ بعين الاعتبار أيام التجهيز المطلوبة قبل الفعالية).',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _bookService();
  }

  bool _isServiceAvailableForEvent() {
    final eventCubit = context.read<EventPlanningCubit>();
    final currentEvent = eventCubit.currentEvent;
    if (currentEvent == null) return false;

    return widget.serviceModel.isAvailableForEvent(
      eventStartDate: currentEvent.startDate,
      eventEndDate: currentEvent.endDate,
    );
  }

  // ✅ دالة لحجز الخدمة
  void _bookService() {
    final eventCubit = context.read<EventPlanningCubit>();
    final currentEvent = eventCubit.currentEvent;

    if (currentEvent == null) return;

    // إضافة الخدمة إلى الفعالية
    eventCubit.addService(widget.serviceModel);

    // إظهار رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ ${widget.serviceModel.name} has been booked for your event!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // العودة إلى صفحة التخطيط
    Navigator.pop(context);
  }
}
