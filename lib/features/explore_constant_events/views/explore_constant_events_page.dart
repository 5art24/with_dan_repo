import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/features/explore_constant_events/view_model/explore_constant_events_cubit.dart';
import 'package:project1_collage/features/explore_constant_events/views/explore_constant_events_body.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';

class ExploreConstantEventsPage extends StatelessWidget {
  const ExploreConstantEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => ExploreConstantEventsCubit())
      ],
      child: Scaffold(body: ExploreConstantEventsBody()),
    );
  }
}
