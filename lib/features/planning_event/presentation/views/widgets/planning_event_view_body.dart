import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/widgets/custom_progress_indicator.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/date_choosing.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/displaying_categories_list.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/displaying_location.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/location_dropdown_choices.dart';
import 'package:project1_collage/features/planning_event/presentation/views/widgets/services_grid.dart';

class PlanningEventViewBody extends StatefulWidget {
  const PlanningEventViewBody({super.key});

  @override
  State<PlanningEventViewBody> createState() => _PlanningEventViewBodyState();
}

class _PlanningEventViewBodyState extends State<PlanningEventViewBody>
    with AutomaticKeepAliveClientMixin {
  // ✅ تعريف الـ Controllers كـ late لتهيئتهم في الـ initState
  late final TextEditingController _eventNameController;
  late final TextEditingController _descriptionController;

  final padding = const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0);
  final categories = ["BirthDay", "Wedding", "Party", "Concert", "Conference"];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // ✅ جلب البيانات المخزنة في الـ Cubit فور فتح الصفحة (تمنع ضياع النص عند العودة)
    final cubit = context.read<EventPlanningCubit>();
    _eventNameController = TextEditingController(
      text: cubit.currentEvent?.name ?? '',
    );

    // تأكد من وجود حقل description في الـ PersonalEvent والـ Cubit الخاص بك
    // إذا لم يكن موجوداً بعد، يمكنك ترك النص فارغاً حالياً '' لحين إضافته للموديل
    _descriptionController = TextEditingController(
      text: cubit.currentEvent?.description ?? '',
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose(); // ✅ تنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fieldWidth = constraints.maxWidth;
          final fieldHeight = 60.0;
          return Form(
            child: BlocBuilder<EventPlanningCubit, EventPlanningState>(
              builder: (context, state) {
                if (state is EventLoaded || state is EventUpdated) {
                  final cubit = context.read<EventPlanningCubit>();
                  final services = cubit.getServiceTypes();

                  return ListView(
                    children: [
                      Text("Plan Your Event", style: Styles.largeTitle),
                      const SizedBox(height: 20),
                      Text(
                        "Category",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      DisplayingCategoriesList(
                        fieldWidth: fieldWidth,
                        fieldHeight: fieldHeight,
                        categories: categories,
                        cubit: cubit,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Event Title",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: TextFormField(
                          controller:
                              _eventNameController, // ✅ ربط الـ Controller مباشرة
                          onChanged: cubit
                              .updateEventName, // ✅ حفظ الاسم في الـ Cubit حرفاً بحرف
                          style: Styles.body,
                          decoration: textFormFieldDecoration(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Date",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: DateChoosing(fieldWidth: fieldWidth),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Location",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: padding,
                            child: const LocationDropdownChoices(),
                          ),
                          Padding(
                            padding: padding,
                            child: DisplayingLocation(
                              location: cubit.getDisplayLocation(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      Padding(
                        padding: padding,
                        child: TextFormField(
                          controller:
                              _descriptionController, // ✅ ربط الـ Controller بالوصف
                          onChanged: (value) {
                            // ✅ استدعاء دالة التحديث للوصف بالـ Cubit (قم بإضافتها للـ Cubit لو لم تكن موجودة)
                            cubit.updateDescription(value);
                          },
                          style: Styles.body,
                          maxLines: 4,
                          minLines: 1,
                          expands: false,
                          decoration: textFormFieldDecoration(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Services",
                        style: Styles.smallTitle.copyWith(
                          color: Styles.mainColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ServicesGrid(services: services),
                      const SizedBox(height: 20),
                    ],
                  );
                } else if (state is EventLoading) {
                  return const CustomProgressIndicator();
                } else if (state is PersonalEventError) {
                  return Center(child: Text(state.error));
                } else {
                  print("🤡 we are here again 🤡 $state");
                  return const SizedBox();
                }
              },
            ),
          );
        },
      ),
    );
  }

  InputDecoration textFormFieldDecoration() {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Styles.mainColor, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Styles.mainColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      fillColor: Styles.mainColor,
    );
  }
}
