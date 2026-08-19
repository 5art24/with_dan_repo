import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/features/planning_event/presentation/view_models/event_planning/event_planning_cubit.dart';

class DateChoosing extends StatelessWidget {
  const DateChoosing({super.key, required this.fieldWidth});

  final double fieldWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventPlanningCubit, EventPlanningState>(
      buildWhen: (previous, current) => current is EventWithDataState,
      builder: (context, state) {
        final cubit = context.read<EventPlanningCubit>();
        final currentEvent = cubit.currentEvent;

        final startDate = currentEvent?.startDate;
        final endDate = currentEvent?.endDate;

        // 🎨 صياغة النص المعروض بناءً على قيم التواريخ في الـ Cubit
        String displayText = "Choose Date Range";
        if (startDate != null && endDate != null) {
          if (startDate.isAtSameMomentAs(endDate)) {
            displayText = _formatDate(startDate);
          } else {
            displayText = "${_formatDate(startDate)}  ➔  ${_formatDate(endDate)}";
          }
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDateRange(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Styles.mainColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    displayText,
                    style: Styles.body.copyWith(
                      color: startDate != null ? Colors.black : Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: fieldWidth * 0.05),
            //==================== Date Range Picker Button ======================
            MaterialButton(
              onPressed: () => _pickDateRange(context),
              minWidth: 40,
              padding: EdgeInsets.zero,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Styles.mainColor.withOpacity(0.5),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.date_range,
                  color: Styles.mainColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final cubit = context.read<EventPlanningCubit>();
    final currentEvent = cubit.currentEvent;

    // إعداد المجال الأولي في حال كان محدداً سابقاً
    DateTimeRange? initialRange;
    if (currentEvent != null && currentEvent.startDate != null) {
      final start = currentEvent.startDate;
      final end = currentEvent.endDate ?? start;
      initialRange = DateTimeRange(
        start: start,
        end: end.isBefore(start) ? start : end,
      );
    }

    // 🎯 استدعاء أداة اختيار النطاق الزمني الرسمية من Flutter
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3 * 365)),
      initialDateRange: initialRange,
      helpText: 'SELECT EVENT DATES',
      saveText: 'DONE',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Styles.mainColor, // لون الأيام المحددة والنطاق
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      // 1️⃣ تحديث تاريخ البداية
      cubit.updateDate(pickedRange.start);
      // 2️⃣ تحديث تاريخ النهاية
      cubit.updateEndDate(pickedRange.end);
    }
  }

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d MMM yyyy');
    return formatter.format(dateTime);
  }
}