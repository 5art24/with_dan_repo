
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/styles.dart';

class DayFiltersList extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const DayFiltersList({super.key, required this.onDateSelected});

  @override
  State<DayFiltersList> createState() => _DayFiltersListState();
}

class _DayFiltersListState extends State<DayFiltersList> {
  late List<DateTime> dates;
  int selectedButton = 3;

  @override
  void initState() {
    super.initState();
    dates = _getDates();
  }

  //===========================week days=========================
  List<DateTime> _getDates() {
    List<DateTime> items = [];
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 3));
    final end = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 3));

    DateTime item = start;
    while (item.isBefore(end) || item.isAtSameMomentAs(end)) {
      items.add(item);
      item = item.add(const Duration(days: 1));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 75, maxHeight: 95),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          List colors = Styles.colors.values.toList();
          Color color = colors[index % colors.length];
          final isSelected = index == selectedButton;
          final date = dates[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    selectedButton = index;
                  });
                  widget.onDateSelected(date);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: isSelected ? color : color.withAlpha(50),
                  elevation: isSelected ? 12 : 2,
                  shadowColor: isSelected
                      ? Colors.black26
                      : Colors.black.withAlpha(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  DateFormat('d\nEEE').format(date),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
