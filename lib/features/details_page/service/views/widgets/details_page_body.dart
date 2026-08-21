import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/widgets/calendar.dart';
import 'package:project1_collage/features/details_page/service/views/widgets/interactive_rating_bar.dart';
import 'package:project1_collage/features/details_page/shared_widgets/details_custom_button.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_description.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_images.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_provider.dart';
import 'package:project1_collage/features/details_page/service/views/widgets/unsupported_images.dart';
import 'package:project1_collage/features/details_page/shared_widgets/info_tile.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class DetailsPageBody extends StatefulWidget {
  const DetailsPageBody({super.key, required this.serviceModel, this.cubit});
  final ServiceModel serviceModel;
  final EventPlanningCubit? cubit;

  @override
  State<DetailsPageBody> createState() => _DetailsPageBodyState();
}

class _DetailsPageBodyState extends State<DetailsPageBody> {
  // التحكم في الـ PageView ومعرفة الصفحة الحالية
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEvent = widget.cubit?.currentEvent;
    const Color primaryColor = Styles.mainColor;
    final authCubit = context.read<AuthCubit>();
    final currentUserId = authCubit.currentUser?.id ?? '';
    final canRate =
        widget.cubit?.canRateService(widget.serviceModel.id, currentUserId) ??
        false;

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
                      UnsupportedImages(service: widget.serviceModel)
                    : DisplayingImages(
                        pageController: _pageController,
                        primaryColor: primaryColor,
                        imageUrls: imageUrls, service: widget.serviceModel,
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

                      if (widget.cubit != null)
                        SizedBox(
                          width: double.infinity,
                          child: DetailsCustomButton(
                            isEnabled: isAvailable && currentEvent != null,
                            onPressed: () =>
                                _onAddPressed(isAvailable, currentEvent),
                          ),
                        ),
                      SizedBox(height: 12),
                      if (canRate) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.amber,
                            ),
                            label: const Text("تقييم هذه الخدمة"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: const BorderSide(color: primaryColor),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () =>
                                _showRatingDialog(context, currentUserId),
                          ),
                        ),
                      ],
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
    // 👇 حالة جديدة: لا يوجد cubit إطلاقًا (قادمون من البروفايل، وضع عرض فقط)
    if (widget.cubit == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن حجز الخدمة من هذه الصفحة')),
      );
      return;
    }

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
    final currentEvent = widget.cubit?.currentEvent; // ✅ nullable-safe
    if (currentEvent == null) return false;

    return widget.serviceModel.isAvailableForEvent(
      eventStartDate: currentEvent.startDate,
      eventEndDate: currentEvent.endDate,
    );
  }

  void _showRatingDialog(BuildContext context, String userId) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Rate Of ${widget.serviceModel.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🟢 استخدام الـ Rating Bar التفاعلي بدعم النصف والـ Hover والأنيميشن
              InteractiveRatingBar(
                initialRating: selectedRating,
                onRatingChanged: (newRating) {
                  selectedRating = newRating;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'اكتب تعليقك (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.cubit?.submitServiceReview(
                  serviceId: widget.serviceModel.id,
                  userId: userId,
                  rating: selectedRating,
                  comment: commentController.text,
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('إرسال التقييم'),
            ),
          ],
        );
      },
    );
  }

  // ✅ دالة لحجز الخدمة
  void _bookService() {
    final eventCubit = widget.cubit; // ✅ بدل context.read
    if (eventCubit == null) return;

    final currentEvent = eventCubit.currentEvent;
    if (currentEvent == null) return;

    eventCubit.addService(widget.serviceModel);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ ${widget.serviceModel.name} has been booked for your event!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }
}
