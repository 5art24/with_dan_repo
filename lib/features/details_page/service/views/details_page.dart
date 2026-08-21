import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/features/details_page/service/views/widgets/details_page_body.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.serviceModel, this.cubit});

  final ServiceModel serviceModel;
  final EventPlanningCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final body = DetailsPageBody(serviceModel: serviceModel, cubit: cubit);

    // لا يوجد Cubit (قادمون من البروفايل) → لا داعي لأي BlocProvider
    if (cubit == null) {
      return Scaffold(body: body);
    }

    return Scaffold(
      body: BlocProvider.value(
        value: cubit!,
        child: body,
      ),
    );
  }
}