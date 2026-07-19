// import 'package:flutter/material.dart';
// import 'package:project1_collage/core/models/service.dart';
// import 'package:project1_collage/core/styles.dart';

// class ServiceCard extends StatelessWidget {
//   final ServiceModel service;
//   final VoidCallback? onTap;

//   const ServiceCard({super.key, required this.service, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // صورة الخدمة
//             Expanded(
//               child: ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//                 child: Image.network(
//                   service.imageUrl?[0] ?? "",
//                   // height:160,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => Container(
//                     height: 160,
//                     width: double.infinity,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image_not_supported, size: 40),
//                   ),
//                 ),
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   //  service name
//                   Text(
//                     service.name,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),

//                   const SizedBox(height: 6),

//                   // Location
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: Styles.mainColor,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         service.location,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 8),

//                   //rate & price
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // التقييم
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.star,
//                             color: Styles.mainColor,
//                             size: 18,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             service.rating.toString(),
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),

//                       // السعر
//                       Text(
//                         "\$${service.price}",
//                         style: const TextStyle(
//                           fontSize: 17,
//                           fontWeight: FontWeight.bold,
//                           color: Styles.mainColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:project1_collage/core/models/service.dart';

// class ServiceCard extends StatelessWidget {
//   final ServiceModel service;
//   final VoidCallback? onTap;
//   final bool isSelectionMode;
//   final bool isSelected;
//   final VoidCallback? onSelectToggle;

//   const ServiceCard({
//     super.key,
//     required this.service,
//     this.onTap,
//     required this.isSelectionMode,
//     required this.isSelected,
//     this.onSelectToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isSelectionMode ? onSelectToggle : onTap,
//       child: Stack(
//         children: [
//           // جسم البطاقة الأساسي
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // صورة الخدمة
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                     child: Image.network(
//                       service.imageUrl != null && service.imageUrl!.isNotEmpty
//                           ? service.imageUrl![0]
//                           : "",
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: double.infinity,
//                         color: Colors.grey.shade200,
//                         child: const Icon(Icons.image_not_supported, size: 40),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // تفاصيل الخدمة المختارة
//                 Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // اسم الخدمة
//                       Text(
//                         service.name,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),

//                       // الموقع
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on,
//                             size: 14,
//                             color: Colors.orange,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               service.location,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 6),

//                       // التقييم والسعر
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.star,
//                                 color: Colors.orange,
//                                 size: 16,
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 service.rating.toString(),
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Text(
//                             "\$${service.price}",
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.orange,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // الدائرة البنفسجية الخاصة بالتحديد (تظهر فقط عند تفعيل وضع التحديد)
//           if (isSelectionMode)
//             Positioned(
//               top: 12,
//               left: 12,
//               child: Container(
//                 width: 28,
//                 height: 28,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color.fromARGB(255, 144, 134, 231),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: isSelected
//                     ? const Icon(Icons.check, color: Colors.white, size: 16)
//                     : Container(
//                         margin: const EdgeInsets.all(3),
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/styles.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onSelectToggle;
  final VoidCallback? onFavoriteTap; // اختياري للتحكم في الضغط على المفضلة

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    required this.isSelectionMode,
    required this.isSelected,
    this.onSelectToggle,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSelectionMode ? onSelectToggle : onTap,
      child: Stack(
        children: [
          // جسم البطاقة الأساسي المحسن
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. صورة الخدمة المقصوصة بعناية
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      service.imageUrl != null && service.imageUrl!.isNotEmpty
                          ? service.imageUrl![0]
                          : "",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_not_supported, size: 35, color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                // 2. تفاصيل وبيانات الخدمة المعروضة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الخدمة
                      Text(
                        service.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // الموقع الجغرافي
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Styles.mainColor, // استخدام لون التطبيق الرئيسي
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              service.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // خط الـ التقييم والسعر
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // التقييم بالنجوم
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Styles.mainColor,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                service.rating?.toString() ?? "0.0",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          // سعر الخدمة
                          Text(
                            "\$${service.price}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Styles.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. زر الـ Favorite (يظهر أعلى اليمين)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: onFavoriteTap ?? () {
                // منطق حفظ الخدمة في المفضلة هنا
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  // يمكنك استبدال الشرط بمتغير الـ favorite الحقيقي من الموديل الخاص بك
                  service.isFavorite == true ? Icons.favorite : Icons.favorite_border,
                  color: service.isFavorite == true ? Colors.red : Styles.mainColor,
                  size: 16,
                ),
              ),
            ),
          ),

          // 4. خيار الدائرة البنفسجية الخاصة بالتحديد (يظهر فقط عند تفعيل وضع التحديد أعلى اليسار)
          if (isSelectionMode)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Styles.mainColor,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Container(
                        margin: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}