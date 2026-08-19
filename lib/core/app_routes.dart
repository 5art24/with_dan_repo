import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/models/service.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/core/view_model/event/event_cubit.dart';
import 'package:project1_collage/features/add_task/views/add_task.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/displaying_selected_services.dart';
import 'package:project1_collage/features/browsing_services/presentation/views/services_browser_page.dart';
import 'package:project1_collage/features/details_page/constant_event/event_booking_details.dart';
import 'package:project1_collage/features/details_page/personal_event/personal_event_details_view.dart';
import 'package:project1_collage/features/details_page/service/views/details_page.dart';
import 'package:project1_collage/features/explore_constant_events/views/explore_constant_events_page.dart';
import 'package:project1_collage/features/home/views/home_view.dart';
import 'package:project1_collage/core/widgets/custom_nav_bar.dart';
import 'package:project1_collage/features/home/views/see_all_events.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/planning_event_view.dart';
import 'package:project1_collage/features/profile/views/auth/login_screen.dart';
import 'package:project1_collage/features/profile/views/auth/register_screen.dart';
import 'package:project1_collage/features/profile/views/provider/service_profile_page.dart';
import 'package:project1_collage/features/profile/views/profile_page.dart';
import 'package:project1_collage/features/profile/views/provider/become_provider_page.dart';
import 'package:project1_collage/features/profile/views/wallet/wallet_page.dart';
import 'package:project1_collage/features/profile/views/settings/app_settings_page.dart';
import 'package:project1_collage/features/search_results/view_model/search_cubit.dart';
import 'package:project1_collage/features/search_results/views/search_results_page.dart';

abstract class AppRoutes {
  static String kHomeView = '/';
  static String kPlanEvent = '/planningEvent';
  static String kEditEvent = "/edit-event";
  static String kServicesBrowser =
      '/planningEvent/services-browser'; //full path
  static String kServiceDetails =
      '/planningEvent/services-browser/services-details';
  static String kAddTask = '/add-task';
  static String kDispalyingSelectedServices = "/display-selected-services";
  static String kProfile = "/profile";
  static String kPersonalEventDetails = "/personal-event-details";
  static String kExploreConstantEvents = "/explore-constant-events";
  static String kConstantEventDetails =
      "/explore-constant-events/constant-event-details";
  static String kSearchResults = "/explore-constant-events/search-results";
  static String kSeeAllEvents = "/see-all-events";
  static String kLogin = "/login";
  static String kServiceProfile = "/service-profile";
  static String kBecomeProvider = "/become-provider";
  static String kWallet = "/wallet";
  static String kAppSettings = "/app-settings";
  static String kRegister = "/register";
  static final router = GoRouter(
    initialLocation: kLogin,
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
            builder: (context, state) => BlocProvider<EventPlanningCubit>(
              create: (context) => EventPlanningCubit(),
              child: const PlanningEventView(),
            ),
          ),
          GoRoute(
            path: kExploreConstantEvents,
            builder: (context, state) => ExploreConstantEventsPage(),
          ),
          //Still need profile
        ],
      ),
      GoRoute(
        path: kEditEvent,
        builder: (context, state) {
          final cubit = state.extra as EventPlanningCubit;
          return BlocProvider.value(
            value: cubit,
            child: const PlanningEventView(),
          );
        },
      ),
      GoRoute(
        path: kAddTask,
        builder: (context, state) {
          final cubit = state.extra as EventPlanningCubit;

          return BlocProvider.value(
            value: cubit,
            child: const EventTasksScreen(needsAppBar: true),
          );
        },
      ),
      GoRoute(
        path: kServicesBrowser,
        builder: (context, state) {
          // استلام الـ Cubit الممرر من الصفحة السابقة
          final cubit = state.extra as EventPlanningCubit;

          return BlocProvider.value(
            value: cubit,
            child: const ServicesBrowserPage(),
          );
        },
      ),
      GoRoute(
        path: kServiceDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final service = extra['service'] as ServiceModel;
          final cubit =
              extra['cubit'] as EventPlanningCubit; // 👈 استلام الـ Cubit

          return BlocProvider.value(
            value: cubit,
            child: DetailsPage(serviceModel: service),
          );
        },
      ),
      GoRoute(
        path: kPersonalEventDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final event = extra['event'] as PersonalEvent;
          return BlocProvider(
            create: (context) {
              final cubit = EventPlanningCubit();

              cubit.setInitialEvent(event);

              return cubit;
            },
            child: PersonalEventDetailsView(event: event),
          );
        },
      ),
      GoRoute(
        path: kDispalyingSelectedServices,

        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final event = extra['event'] as PersonalEvent;
          final cubit = extra['cubit'] as EventPlanningCubit;
          return BlocProvider.value(
            value: cubit,
            child: DisplayingSelectedServices(event: event),
          );
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
        builder: (context, state) {
          // 🟢 استلام الـ Cubit الممرر
          final eventCubit = state.extra as EventCubit;

          // 🟢 توفيره لشاشة SeeAllEvents عبر value
          return BlocProvider.value(
            value: eventCubit,
            child: const SeeAllEvents(),
          );
        },
      ),
      GoRoute(path: kLogin, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: kServiceProfile,
        builder: (context, state) => const ServiceProfilePage(),
      ),
      GoRoute(path: kProfile, builder: (context, state) => const ProfilePage()),
      GoRoute(
        path: kBecomeProvider,
        builder: (context, state) => const BecomeProviderPage(),
      ),
      GoRoute(path: kWallet, builder: (context, state) => const WalletPage()),
      GoRoute(
        path: kAppSettings,
        builder: (context, state) => const AppSettingsPage(),
      ),
      GoRoute(
        path: kRegister,
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
}

class MainPageWithNavigationBar extends StatelessWidget {
  const MainPageWithNavigationBar({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    // TODO: Get isServiceProvider from auth state (SharedPreferences, Provider, etc.)
    // For now, default to false
    final isServiceProvider = false;

    return Scaffold(
      body: Stack(
        children: [
          body,
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: CustomNavBar(
              isServiceProvider: isServiceProvider,
              onModeSwitch: () {
                // TODO: Implement mode switch logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تبديل الوضع - قيد التطوير')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
