
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/models/normal_user.dart';
import 'package:project1_collage/core/models/personal_event.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/auth/auth_cubit.dart';
import 'package:project1_collage/features/add_task/views/add_task.dart';
import 'package:project1_collage/features/details_page/personal_event/event_info_display_body.dart';
import 'package:project1_collage/features/details_page/personal_event/selected_services_display_body.dart';
import 'package:project1_collage/features/details_page/personal_event/tasks_display_body.dart';
import 'package:project1_collage/features/details_page/personal_event/top_dots_indicator.dart';

class PersonalEventDetailsView extends StatefulWidget {
  final PersonalEvent event;
  const PersonalEventDetailsView({super.key, required this.event});

  @override
  State<PersonalEventDetailsView> createState() =>
      _PersonalEventDetailsViewState();
}

class _PersonalEventDetailsViewState extends State<PersonalEventDetailsView> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8FD),
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 الشريط الأعلى: زر العودة + مؤشر النقاط
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Styles.mainColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: TopDotsIndicator(
                      pageController: _pageController,
                      itemCount: 3,
                      primaryColor: Styles.mainColor,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // 🔹 محتوى الصفحات الثلاث عبر PageView
            Expanded(
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  // 🟢 جلب الفعالية المحدثة مرة واحدة للأب
                  final currentEvent = (authState is Authenticated)
                      ? (authState.user as NormalUser).personalEvents.firstWhere(
                          (e) => e.id == widget.event.id,
                          orElse: () => widget.event,
                        )
                      : widget.event;

                  return PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      // 🟢 تمرير currentEvent المحدثة لجميع الشاشات الفرعية
                      EventInfoDisplayBody(),
                      SelectedServicesDisplayBody(event: currentEvent),
                      EventTasksScreen(needsAppBar: false),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
