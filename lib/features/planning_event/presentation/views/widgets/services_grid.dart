import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/models/service_item.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key, required this.services});

  final List<ServiceItem> services;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: MediaQuery.of(context).size.width < 600
          ? 3
          : MediaQuery.of(context).size.width < 900
          ? 4
          : 2,
      childAspectRatio: 0.8,
      crossAxisSpacing: 10,
      mainAxisSpacing: 0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(services.length, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              final cubit = context.read<EventPlanningCubit>();
              final serviceType = services[index].service.type;

              // ✅ تغيير نوع الخدمة أولاً
              cubit.changeServiceType(serviceType);

              // ✅ الانتقال إلى صفحة تصفح الخدمات (وليس صفحة التفاصيل)
              GoRouter.of(
                context,
              ).push(AppRoutes.kServicesBrowser, extra: context.read<EventPlanningCubit>());//, extra: cubit
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Styles.colors.values
                        .toList()[index % Styles.colors.length],
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          75,
                          74,
                          74,
                        ).withOpacity(0.2), // لون الظل مع شفافية
                        spreadRadius: 1, // انتشار الظل
                        blurRadius: 12, // ✅ درجة التمويه (الظل) = 12
                        offset: const Offset(0, 5), //
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      services[index].icon,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  services[index].service.type.name.toString().toUpperCase(),
                  style: Styles.body.copyWith(
                    fontSize: MediaQuery.of(context).size.width < 600 ? 12 : 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
