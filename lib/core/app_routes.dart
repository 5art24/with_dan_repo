import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/features/add_task/views/add_task.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/displaying_selected_services.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/services_browser_page.dart';
import 'package:project1_collage/features/details_page/constant_event/event_booking_details.dart';
import 'package:project1_collage/features/details_page/service/views/details_page.dart';
import 'package:project1_collage/features/explore_constant_events/views/explore_constant_events_body.dart';
import 'package:project1_collage/features/explore_constant_events/views/explore_constant_events_page.dart';
import 'package:project1_collage/features/home/views/home_view.dart';
import 'package:project1_collage/core/widgets/custom_nav_bar.dart';
import 'package:project1_collage/features/home/views/see_all_events.dart';
import 'package:project1_collage/features/planning_event/presentation/views/planning_event_view.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';
import 'package:project1_collage/features/search_results/views/search_results_page.dart';

abstract class AppRoutes {
  static String kHomeView = '/';
  static String kPlanEvent = '/planningEvent';
  static String kServicesBrowser =
      '/planningEvent/services-browser'; //full path
  static String kServiceDetails =
      '/planningEvent/services-browser/services-details';
  static String kAddTask = '/add-task';
  static String kDispalyingSelectedServices = "/display-selected-services";
  static String kExploreConstantEvents = "/explore-constant-events";
  static String kConstantEventDetails =
      "/explore-constant-events/constant-event-details";
  static String kSearchResults = "/explore-constant-events/search-results";
  static String kSeeAllEvents = "/see-all-events";
  static final router = GoRouter(
    initialLocation: kHomeView,
    routes: [
      // استخدام ShellRoute للصفحات الرئيسية فقط
      ShellRoute(
        builder: (context, state, child) {
          return MainPageWithNavigationBar(body: child);
        },
        routes: [
          // الصفحات الرئيسية التي تظهر فيها الـ NavBar
          GoRoute(
            path: kHomeView,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: kPlanEvent,
            builder: (context, state) => const PlanningEventView(),
          ),
          GoRoute(
            path: kExploreConstantEvents,
            builder: (context, state) => ExploreConstantEventsPage(),
          ),
          //Still need profile
        ],
      ),
      GoRoute(
        path: kAddTask,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final event = extra['event'] as PersonalEvent;
          return EventTasksScreen(
            event: event,
          );
        },
      ),
      GoRoute(
        path: kServicesBrowser,
        builder: (context, state) => const ServicesBrowserPage(),
      ),
      GoRoute(
        path: kServiceDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final service = extra['service'] as ServiceModel;
          return DetailsPage(serviceModel: service);
        },
      ),
      GoRoute(
        path: kDispalyingSelectedServices,

        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final event = extra['event'] as PersonalEvent;
          return DisplayingSelectedServices(event: event);
        },
      ),
      GoRoute(
        path: kConstantEventDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final event = extra['event'] as ConstantEventModel;
          return ConstantEventDetails(constantEvent: event);
        },
      ),
      GoRoute(
        path: kSearchResults,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final initialQuery = extra['initialQuery'] as String;
          final initialResults =
              extra['initialResults'] as List<ConstantEventModel>;
          final cubit = extra['cubit'] as SearchCubit;
          return BlocProvider.value(
            value: cubit,
            child: SearchResultsPage(
              initialQuery: initialQuery,
              initialResults: initialResults,
            ),
          );
        },
      ),
      GoRoute(
        path: kSeeAllEvents,
        builder: (context, state) => const SeeAllEvents(),
      ),
    ],
  );
}

class MainPageWithNavigationBar extends StatelessWidget {
  const MainPageWithNavigationBar({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    //  final cubit = context.watch<PlanningCubit>();
    return Scaffold(
      body: Stack(
        children: [
          // تمرير نفس الـ Cubit للصفحات الفرعية
          // BlocProvider.value(
          //   value: cubit,
          //   child: body,
          // ),
          body,
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: CustomNavBar(),
          ),
        ],
      ),
    );
  }
}
//Notes after planning event the next page is view the selected services after that add specific tasks to the event  
//after browsing constant events can search about evetn and had the results in anthor page and can get the displayed events depending omn the location the use determine it  