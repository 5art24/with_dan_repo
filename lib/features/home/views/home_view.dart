import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/app_routes.dart';
import 'package:project1_collage/core/view_model/task/task_cubit.dart';
import 'package:project1_collage/core/widgets/drawer_menu.dart';
import 'package:project1_collage/features/home/views/widgets/day_filters_list.dart';
import 'package:project1_collage/features/home/views/widgets/displaying_task_cards.dart';
import 'package:project1_collage/features/home/views/widgets/upcoming_events_cards.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: DrawerMenu(
        userName: 'أحمد الزعبي',
        userEmail: 'ahmed@example.com',
        isServiceProvider: false,
        onServiceProviderToggle: (value) {},
        onLogout: () {
          GoRouter.of(context).go(AppRoutes.kLogin);
        },
      ),
      appBar: AppBar(
        backgroundColor: Styles.background,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Text(
                "eva",
                style: Styles.largeTitle.copyWith(
                  color: Styles.primary,
                  fontSize: 40,
                ),
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Styles.primary,
              size: 24,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Upcoming Events", style: Styles.largeTitle),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).push(AppRoutes.kSeeAllEvents);
                    },
                    child: Text(
                      "see all",
                      style: Styles.body.copyWith(color: Styles.primary),
                    ),
                  ),
                ],
              ),
            ),
            //===========================Upcoming Events=================================
            const SliverToBoxAdapter(child: UpcomingEventsCards()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            //=========================date choosen===================================
            SliverToBoxAdapter(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  DateTime displayDate = context.read<TaskCubit>().selectedDate;
                  if (state is TaskLoaded) {
                    displayDate = state.selectedDate;
                  }
                  return Row(
                    children: [
                      Text(
                        DateFormat('dd MMMM yyyy').format(displayDate),
                        style: Styles.mediumTitle,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.expand_more),
                      ),
                    ],
                  );
                },
              ),
            ),
            //=======================tasks number===================
            SliverToBoxAdapter(
              child: BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is TaskLoaded) {
                    count = state.totalTodayTasksCount;
                  }
                  return Text(
                    "you have total $count tasks",
                    style: Styles.labels,
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            // ========================days filters=======================
            SliverToBoxAdapter(
              child: DayFiltersList(
                onDateSelected: (date) {
                  context.read<TaskCubit>().selectDay(date);
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            //======================tasks cards=====================
            const SliverToBoxAdapter(child: DisplayingTaskCards()),
          ],
        ),
      ),
    );
  }
}
