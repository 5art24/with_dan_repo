// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:project1_collage/core/app_routes.dart';
// import 'package:project1_collage/core/models/service.dart';
// import 'package:project1_collage/core/styles.dart';
// import 'package:project1_collage/core/widgets/custom_progress_indicator.dart';
// import 'package:project1_collage/core/widgets/custom_show_error.dart';
// import 'package:project1_collage/features/browsing_services/presentation/views/widgets/displaying_service_filters.dart';
// import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';
// import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
// import 'package:project1_collage/features/planning_event/presentation/views/widgets/custom_button.dart';

// class ServicesBrowserPageBody extends StatelessWidget {
//   const ServicesBrowserPageBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = context.watch<EventPlanningCubit>();
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverToBoxAdapter(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   Text(
//                     "Pick a ${cubit.selectedServiceType.name}",
//                     style: Styles.largeTitle,
//                   ),
//                   // أزرار الترتيب
//                   SizedBox(
//                     height: 60,
//                     child: DisplayingServiceFilters(
//                       fieldWidth: MediaQuery.of(context).size.width,
//                       filters: FilterType.values,
//                       cubit: cubit,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           ];
//         },
//         body: BlocBuilder<EventPlanningCubit, EventPlanningState>(
//           builder: (context, state) {
//             //here after click on the service button to browse ther services or change the filter
//             if (state is ServicesFilterChanged) {
//               List services = state.services;
//               return services.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'There are no services available for this type currently',
//                       ),
//                     )
//                   : LayoutBuilder(
//                       builder: (context, constraints) {
//                         //Calculating the ratio dynamically
//                         // const crossAxisCount = 2;
//                         // const spacing = 12.0;
//                         // const horizontalPadding =
//                         //     24.0; // padding left + right in GridView
//                         // final totalSpacing = spacing * (crossAxisCount - 1);
//                         // final availableWidth =
//                         //     constraints.maxWidth -
//                         //     horizontalPadding * 2 -
//                         //     totalSpacing;
//                         // final cardWidth = availableWidth / crossAxisCount;
//                         // //constant height
//                         // const cardHeight = 245.0;
//                         // final dynamicAspectRatio = cardWidth / cardHeight;
//                         const crossAxisCount = 2;
//                         const spacing = 12.0;
//                         const horizontalPadding = 24.0;
//                         final totalSpacing = spacing * (crossAxisCount - 1);
//                         final availableWidth =
//                             constraints.maxWidth -
//                             horizontalPadding * 2 -
//                             totalSpacing;
//                         final cardWidth = availableWidth / crossAxisCount;

//                         const cardHeight = 280.0;
//                         final dynamicAspectRatio = cardWidth / cardHeight;
//                         print(
//                           "media:${MediaQuery.of(context).size.width} constraints : ${constraints.maxWidth} ,Ratio: $dynamicAspectRatio",
//                         );
//                         return GridView.builder(
//                           padding: const EdgeInsets.all(horizontalPadding / 2),
//                           gridDelegate:
//                               SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 2,
//                                 childAspectRatio: dynamicAspectRatio,
//                                 crossAxisSpacing: spacing,
//                                 mainAxisSpacing: spacing,
//                               ),
//                           itemCount: services.length,
//                           itemBuilder: (context, index) {
//                             final service = services[index];
//                             return ServiceCard(
//                               service: service,
//                               onTap: () {
//                                 GoRouter.of(context).push(
//                                   AppRoutes.kServiceDetails,
//                                   extra: {
//                                     'service': service,
//                                   }, //, 'cubit': cubit
//                                 );
//                               },
//                               isSelectionMode: false,
//                               isSelected: false,
//                             );
//                           },
//                         );
//                       },
//                     );
//             } else if (state is ServicesLoading) {
//               return CustomProgressIndicator();
//             } else if (state is ServicesError) {
//               return CustomShowError(error: state.error);
//             } else {
//               // حالة احتياطية: نستخدم read للحصول على الخدمات دون استماع
//               final cubit = context.read<EventPlanningCubit>();
//               final services = cubit.filteredAndSortedServices;
//               if (services.isNotEmpty) {
//                 return GridView.builder(
//                   padding: const EdgeInsets.all(12),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 12,
//                     mainAxisSpacing: 12,
//                   ),
//                   itemCount: services.length,
//                   itemBuilder: (context, index) {
//                     final service = services[index];
//                     return ServiceCard(
//                       service: service,
//                       onTap: () {},
//                       isSelectionMode: false,
//                       isSelected: false,
//                     );
//                   },
//                 );
//               }
//               return CustomShowError(error: 'حالة غير متوقعة. حاول مرة أخرى.');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/custom_progress_indicator.dart';
import 'package:project1_collage/core/widgets/custom_show_error.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/displaying_service_filters.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/service_card.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class ServicesBrowserPageBody extends StatelessWidget {
  const ServicesBrowserPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<EventPlanningCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // متناسق مع الصفحة السابقة
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Pick a ${cubit.selectedServiceType.name}",
                    style: Styles.largeTitle,
                  ),
                  const SizedBox(height: 12),
                  // sorting filters
                  SizedBox(
                    height: 60,
                    child: DisplayingServiceFilters(
                      fieldWidth: MediaQuery.of(context).size.width,
                      filters: FilterType.values,
                      cubit: cubit,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ];
        },
        body: BlocBuilder<EventPlanningCubit, EventPlanningState>(
          builder: (context, state) {
            List services = [];

            if (state is ServicesFilterChanged) {
              services = state.services;
            } else if (state is ServicesLoading) {
              return CustomProgressIndicator();
            } else if (state is ServicesError) {
              return CustomShowError(error: state.error);
            } else {
              // الحالة الاحتياطية الأساسية
              final fallbackCubit = context.read<EventPlanningCubit>();
              services = fallbackCubit.filteredAndSortedServices;
            }

            if (services.isEmpty) {
              return const Center(
                child: Text(
                  'There are no services available for this type currently',
                ),
              );
            }

            // بناء الـ Grid الاحترافي والمتجاوب باستخدام السليفرز المطور
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverLayoutBuilder(
                  builder: (context, constraints) {
                    const crossAxisCount = 2;
                    const spacing = 14.0;
                    
                    // حساب المساحة المتاحة بدقة بناءً على أبعاد السليفر
                    final availableWidth = constraints.crossAxisExtent - spacing;
                    final cardWidth = availableWidth / crossAxisCount;

                    // الارتفاع المتناسق لبطاقات الخدمات مع التصميم السابق
                    const cardHeight = 230.0; 
                    final dynamicAspectRatio = cardWidth / cardHeight;

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: dynamicAspectRatio,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final service = services[index];
                          return ServiceCard(
                            service: service,
                            isSelectionMode: false, // تحكمي بها حسب منطق تطبيقك
                            isSelected: false,
                            onTap: () {
                              GoRouter.of(context).push(
                                AppRoutes.kServiceDetails,
                                extra: {'service': service},
                              );
                            },
                          );
                        },
                        childCount: services.length,
                      ),
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}