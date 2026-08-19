import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/widgets/services_browser_page_body.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class ServicesBrowserPage extends StatelessWidget {
  const ServicesBrowserPage({super.key});

  @override
  Widget build(BuildContext context) {
     final cubit = context.watch<EventPlanningCubit>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.mounted) {
              Navigator.of(
                context,
              ).pop(); // استخدم Navigator بدلاً من GoRouter للعودة
            }
          },
        ),
        centerTitle: true, 
        title: Text(
          cubit.selectedServiceType.name.toTitleCase(),
          style: Styles.smallTitle.copyWith(color: Styles.mainColor),
        ),
      ),
      body:
        const ServicesBrowserPageBody(),
    );
  }
}
