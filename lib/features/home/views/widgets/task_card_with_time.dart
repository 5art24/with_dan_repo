import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:project1_collage/core/view_model/task/task_cubit.dart';

class TaskCardWithTime extends StatelessWidget {
  final TaskModel task;
  final String eventName;
  final Color cardColor;
  final ValueChanged<bool?> onStatusChanged;

  const TaskCardWithTime({
    super.key,
    required this.task,
    required this.eventName,
    required this.cardColor,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final String startTimeStr = DateFormat('h:mm').format(task.startDateTime);
    final String endTimeStr = DateFormat('h:mm').format(
      task.endDateTime ?? task.startDateTime.add(const Duration(hours: 1)),
    );
    final String dayStr =
        DateFormat('yyyy-MM-dd').format(task.startDateTime) ==
            DateFormat('yyyy-MM-dd').format(DateTime.now())
        ? "Today"
        : DateFormat('MMM d').format(task.startDateTime);
    final String exactTimeStr = DateFormat('h:mm a').format(task.startDateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //==================time bar=========================
            SizedBox(
              width: 55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    startTimeStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: DashedVerticalLine(
                        color: Colors.black.withOpacity(0.2),
                        width: 1.5,
                        dashHeight: 6,
                        dashSpace: 4,
                      ),
                    ),
                  ),
                  Text(
                    endTimeStr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            //========================task card========================
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================event name============================
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        eventName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // task name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: Styles.smallTitle.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: task.isDone
                                  ? Colors.black45
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: task.isDone,
                            //
                            onChanged: onStatusChanged,
                            activeColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Divider(color: Colors.black.withOpacity(0.1), height: 20),
                    //priority and time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.watch_later_rounded,
                              size: 18,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "$dayStr  $exactTimeStr",
                              style: Styles.labels.copyWith(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.priorityString,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: task.priority == 1
                                  ? Colors.redAccent
                                  : task.priority == 2
                                  ? Colors.green
                                  : Colors.blueGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashedVerticalLine extends StatelessWidget {
  final Color color;
  final double width;
  final double dashHeight;
  final double dashSpace;

  const DashedVerticalLine({
    super.key,
    this.color = Colors.black,
    this.width = 1.2,
    this.dashHeight = 8,
    this.dashSpace = 6,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedVerticalLinePainter(
        color: color,
        strokeWidth: width,
        dashHeight: dashHeight,
        dashSpace: dashSpace,
      ),
      child: SizedBox(width: width, height: double.infinity),
    );
  }
}

class _DashedVerticalLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashHeight;
  final double dashSpace;

  _DashedVerticalLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashHeight,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startY = 0;
    final centerX = size.width / 2;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(centerX, startY),
        Offset(centerX, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
