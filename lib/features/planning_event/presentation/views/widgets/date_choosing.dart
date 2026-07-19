import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/styles.dart';

class DateChoosing extends StatefulWidget {
  const DateChoosing({super.key, required this.fieldWidth});

  final double fieldWidth;

  @override
  State<DateChoosing> createState() => _DateChoosingState();
}

class _DateChoosingState extends State<DateChoosing> {
  DateTime? _selectedEventDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _pickDate,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Styles.mainColor, // نفس لون خط TextFormField
                    width: 1.5, // نفس السماكة
                  ),
                ),
              ),
              child: Text(
                _selectedEventDate == null
                    ? "choose date"
                    : _formatDateBeautifullyEn(_selectedEventDate!),
                style: Styles.body.copyWith(
                  color: _selectedEventDate != null
                      ? Colors.black
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: widget.fieldWidth * 0.1),
        //====================Date Picker======================
        MaterialButton(
          onPressed: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: Styles.mainColor.withOpacity(0.5), width: 2.0),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.calendar_month),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: _selectedEventDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3 * 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedEventDate = pickedDate;
      });
    }
  }

  String _formatDateBeautifully(DateTime dateTime) {
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy', 'ar');
    final String formattedDate = dateFormatter.format(dateTime);

    return "$formattedDate";
  }

  // ✅ نسخة أخرى للتنسيق بالإنجليزية
  String _formatDateBeautifullyEn(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d, MMMM , yyyy');
    return formatter.format(dateTime);
  }
}
