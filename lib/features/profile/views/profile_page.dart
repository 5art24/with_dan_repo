// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project1_collage/core/styles.dart';
// import 'package:project1_collage/core/app_routes.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Styles.background,
//       appBar: AppBar(
//         backgroundColor: Styles.background,
//         elevation: 0,
//         title: const Text(
//           'البروفايل',
//           style: TextStyle(
//             color: Styles.primary,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Styles.primary.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.person,
//                 size: 60,
//                 color: Styles.primary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'أحمد الزعبي',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Styles.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'ahmed@example.com',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Styles.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () {
//                 GoRouter.of(context).push(AppRoutes.kProfile);
//               },
//               icon: const Icon(Icons.storefront),
//               label: const Text('عرض بروفايل مزود الخدمة'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Styles.primary,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }