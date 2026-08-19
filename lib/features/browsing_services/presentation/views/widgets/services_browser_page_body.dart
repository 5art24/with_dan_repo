
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
    final cubit = context.read<EventPlanningCubit>();
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
                                extra: {'service': service, 'cubit': cubit}, // تمرير الـ Cubit مع الخدمة
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