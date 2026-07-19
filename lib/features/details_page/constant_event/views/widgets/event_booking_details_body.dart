
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:project1_collage/core/models/constant_event.dart'; // الموديل الخاص بالفعاليات الثابتة
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/details_page/constant_event/views/widgets/unexpnded_map.dart';
import 'package:project1_collage/features/details_page/shared_widgets/details_custom_button.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_description.dart';
import 'package:project1_collage/features/details_page/shared_widgets/displaying_images.dart';
import 'package:project1_collage/features/details_page/service/views/widgets/unsupported_images.dart';
import 'package:project1_collage/features/details_page/shared_widgets/info_tile.dart';

class ConstantEventDetailsBody extends StatefulWidget {
  const ConstantEventDetailsBody({super.key, required this.constantEvent});
  final ConstantEventModel constantEvent; // استقبال موديل الفعالية الثابتة بدلاً من الخدمة

  @override
  State<ConstantEventDetailsBody> createState() => _ConstantEventDetailsBodyState();
}

class _ConstantEventDetailsBodyState extends State<ConstantEventDetailsBody> {
  final PageController _pageController = PageController();

  // قائمة روابط الصور التجريبية في حال لم تتوفر صور مخصصة
  final List<String> _defaultImages = [
    'https://picsum.photos/400/250',
    'https://picsum.photos/id/1015/400/300',
    'https://picsum.photos/id/104/400/300',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Styles.mainColor;
    List<String>? imageUrls = widget.constantEvent.imageUrl;
    
    // جلب الإحداثيات من الموديل ديناميكياً أو وضع إحداثيات افتراضية
    final LatLng eventCoordinates = LatLng(
      widget.constantEvent.latitude ?? 24.7117, 
      widget.constantEvent.longitude ?? 46.6744,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============================== Top Image Slider ===========================
                (imageUrls == null || imageUrls.isEmpty)
                    ? UnsupportedImages()
                    : DisplayingImages(
                        pageController: _pageController,
                        primaryColor: primaryColor, imageUrls:imageUrls,
                      ),

                // ============================== Content Details ===========================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الفعالية
                      Text(
                        widget.constantEvent.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // نوع الفعالية والتصنيف
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              border: Border.all(color: primaryColor.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              widget.constantEvent.type.name.toUpperCase(),
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // 1. بطاقة عرض التاريخ والوقت
                      InfoTile(
                        icon: Icons.calendar_month_outlined,
                        title: widget.constantEvent.formattedDateTime,
                        subtitle: 'Scheduled Event Time',
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // 2. بطاقة عرض الموقع الجغرافي كنص
                      InfoTile(
                        icon: Icons.location_on_outlined,
                        title: widget.constantEvent.location,
                        subtitle: 'Event Venue Location',
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // 3. بطاقة عرض استيعاب المكان (تعديل السعر ليصبح عدداً للأشخاص)
                      InfoTile(
                        icon: Icons.people_alt_outlined,
                        title: '${widget.constantEvent.accommodation} People Max',
                        subtitle: 'Maximum venue capacity allowed',
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // وصف الفعالية
                      const Text(
                        'About Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DisplayingDescription(
                        description: widget.constantEvent.description ?? 'No description available for this event.',
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(height: 24),

                      // الخريطة التفاعلية المقصوصة
                      const Text(
                        'Location Map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      UnExpandedMap(
                        serviceCoordinates: eventCoordinates,
                        serviceName: widget.constantEvent.name,
                      ),
                      const SizedBox(height: 32),

                      // زر تأكيد الحجز / الاتخاذ لإجراء سفلي
                      SizedBox(
                        width: double.infinity,
                        child: DetailsCustomButton(),
                      ),
                      const SizedBox(height: 20),
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