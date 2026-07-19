import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/booking_range.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:table_calendar/table_calendar.dart';

class ServiceCalendarWidget extends StatefulWidget {
  final List<BookingRange>? bookings; // جعلها اختيارية تحسباً لعدم وجود حجوزات
  final DateTime? eventDate; // ✅ تاريخ الفعالية (يوم واحد)
  final int preparationDays;
  const ServiceCalendarWidget({
    super.key,
    required this.bookings,
    this.eventDate,
    this.preparationDays = 0,
  });

  @override
  State<ServiceCalendarWidget> createState() => _ServiceCalendarWidgetState();
}

class _ServiceCalendarWidgetState extends State<ServiceCalendarWidget> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  final Color primaryColor = Styles.mainColor;

  //// To know if the day is booked
  bool _isDayBooked(DateTime day) {
    if (widget.bookings == null) return false;

    for (var booking in widget.bookings!) {
      if (booking.contains(day)) {
        return true;
      }
    }
    return false;
  }

  // return booking range
  BookingRange? _getBookingForDay(DateTime day) {
    if (widget.bookings == null) return null;

    for (var booking in widget.bookings!) {
      if (booking.contains(day)) {
        return booking;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // إضافة وسيلة إيضاح (Legend) للمستخدم
          _buildLegend(),
          const SizedBox(height: 16),
          TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            availableGestures: AvailableGestures.horizontalSwipe,

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });

              // عرض تفاصيل اليوم المحدد
              _showDayDetails(selectedDay);
            },

            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },

            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.grey[400],
                size: 24,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 24,
              ),
            ),

            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              weekendStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isBooked = _isDayBooked(day);
                final booking = _getBookingForDay(day);

                if (isBooked && booking != null) {
                  // Determining the shape of the reservation based on its location
                  final isStart = _isSameDay(day, booking.startDate);
                  final isEnd = _isSameDay(day, booking.endDate);
                  final isSingleDay = isStart && isEnd;

                  return _buildBookedDayCell(day, isStart, isEnd, isSingleDay);
                }

                // available day
                return _buildAvailableDayCell(day);
              },

              todayBuilder: (context, day, focusedDay) {
                return _buildTodayCell(day);
              },

              outsideBuilder: (context, day, focusedDay) {
                return _buildOutsideCell(day);
              },
            ),
          ),

          const SizedBox(height: 16),

          // إضافة معلومات إضافية عن التوفر
          _buildAvailabilityInfo(),
        ],
      ),
    );
  }

  // explain colors
  Widget _buildLegend() {
  return Wrap(
    spacing: 16,
    runSpacing: 8,
    alignment: WrapAlignment.center,
    children: [
      // محجوز
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          const Text('Reserved', style: TextStyle(fontSize: 11)),
        ],
      ),
      // متاح
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          const Text('Available', style: TextStyle(fontSize: 11)),
        ],
      ),
      // اليوم
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Today', style: TextStyle(fontSize: 11)),
        ],
      ),
      // ✅ أيام التجهيز
      if (widget.preparationDays > 0)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text('Preparation (${widget.preparationDays} days)', 
                style: const TextStyle(fontSize: 11)),
          ],
        ),
      // ✅ يوم الفعالية متاح
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Event Day (Available)', 
              style: TextStyle(fontSize: 11)),
        ],
      ),
      // ✅ يوم الفعالية غير متاح
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text('Event Day (Unavailable)', 
              style: TextStyle(fontSize: 11)),
        ],
      ),
    ],
  );
}

  //Building day's booked cell
  Widget _buildBookedDayCell(
    DateTime day,
    bool isStart,
    bool isEnd,
    bool isSingleDay,
  ) {
    BorderRadius borderRadius = BorderRadius.zero;

    if (isSingleDay) {
      borderRadius = BorderRadius.circular(12);
    } else if (isStart) {
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    } else if (isEnd) {
      borderRadius = const BorderRadius.only(
        topRight: Radius.circular(12),
        bottomRight: Radius.circular(12),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 3,
        horizontal: isSingleDay ? 4 : 0,
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Building day's available cell
  // Building day's available cell
Widget _buildAvailableDayCell(DateTime day) {
  final status = _getDayStatus(day);
  
  switch (status) {
    case DayStatus.eventAvailable:
      // ✅ يوم الفعالية والخدمة متاحة -> أخضر
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
      
    case DayStatus.eventUnavailable:
      // ✅ يوم الفعالية والخدمة غير متاحة -> أحمر
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      );
      
    case DayStatus.preparation:
      // ✅ أيام التجهيز -> برتقالي
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      );
      
    case DayStatus.normal:
    default:
      // الأيام العادية
      return Center(
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
  }
}

  //Building today's current cell
  Widget _buildTodayCell(DateTime day) {
    return Center(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: primaryColor, width: 1.5),
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  // Building the day cell outside the current month
  Widget _buildOutsideCell(DateTime day) {
    return Center(
      child: Text(
        '${day.day}',
        style: TextStyle(color: Colors.grey.shade300, fontSize: 13),
      ),
    );
  }

  // Information about general availability
  Widget _buildAvailabilityInfo() {
    if (widget.bookings == null || widget.bookings!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Styles.colors["lightBlue"],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'This service is available all year round, there are no bookings currently.',
                style: TextStyle(
                  color: Styles.colors["lightBlue"],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Counting the reserved days (for display only)
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.bookings!.length} Reserved period(s)• \n The colorful days are not available',
              style: TextStyle(color: primaryColor, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // عرض تفاصيل اليوم المحدد
  void _showDayDetails(DateTime day) {
    final isBooked = _isDayBooked(day);
    final booking = _getBookingForDay(day);

    String message;
    if (isBooked && booking != null) {
      final isStart = _isSameDay(day, booking.startDate);
      final isEnd = _isSameDay(day, booking.endDate);

      if (isStart && isEnd) {
        message = 'هذا اليوم محجوز بالكامل';
      } else if (isStart) {
        message =
            'بداية فترة الحجز: ${_formatDate(booking.startDate)} إلى ${_formatDate(booking.endDate)}';
      } else if (isEnd) {
        message =
            'نهاية فترة الحجز: ${_formatDate(booking.startDate)} إلى ${_formatDate(booking.endDate)}';
      } else {
        message =
            'ضمن فترة حجز: ${_formatDate(booking.startDate)} إلى ${_formatDate(booking.endDate)}';
      }
    } else {
      message = 'هذا اليوم متاح للحجز';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: isBooked ? Colors.red : Colors.green,
      ),
    );
  }

  // ✅ التحقق مما إذا كان اليوم هو يوم الفعالية
  bool _isEventDay(DateTime day) {
    if (widget.eventDate == null) return false;
    return _isSameDay(day, widget.eventDate!);
  }

  // ✅ التحقق مما إذا كان اليوم ضمن أيام التجهيز المطلوبة
  bool _isPreparationDay(DateTime day) {
    if (widget.eventDate == null || widget.preparationDays == 0) return false;

    final preparationStartDate = widget.eventDate!.subtract(
      Duration(days: widget.preparationDays),
    );
    final preparationEndDate = widget.eventDate!.subtract(
      const Duration(days: 1),
    );

    return day.isAfter(
          preparationStartDate.subtract(const Duration(days: 1)),
        ) &&
        day.isBefore(preparationEndDate.add(const Duration(days: 1)));
  }

  // ✅ التحقق مما إذا كانت الخدمة متاحة للفعالية (مع مراعاة أيام التجهيز)
  bool _isServiceAvailableForEvent() {
    if (widget.eventDate == null) return true; // لم يتم اختيار تاريخ بعد

    // قائمة كل الأيام التي نحتاج التحقق منها
    final daysToCheck = <DateTime>[];

    // أيام التجهيز
    for (int i = 1; i <= widget.preparationDays; i++) {
      daysToCheck.add(widget.eventDate!.subtract(Duration(days: i)));
    }

    // يوم الفعالية نفسه
    daysToCheck.add(widget.eventDate!);

    // التحقق من كل يوم
    for (var day in daysToCheck) {
      if (_isDayBooked(day)) {
        return false; // يوجد يوم محجوز ضمن الفترة المطلوبة
      }
    }

    return true; // كل الأيام المطلوبة متاحة
  }

  DayStatus _getDayStatus(DateTime day) {
    final isEventDay = _isEventDay(day);
    final isPreparationDay = _isPreparationDay(day);
    final isBooked = _isDayBooked(day);

    if (isEventDay) {
      return isBooked ? DayStatus.eventUnavailable : DayStatus.eventAvailable;
    }

    if (isPreparationDay) {
      return DayStatus.preparation;
    }

    return DayStatus.normal;
  }

  // comparing days
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // تنسيق التاريخ
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ✅ الحصول على حالة اليوم (للتلوين)
enum DayStatus { normal, eventAvailable, eventUnavailable, preparation }
