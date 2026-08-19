import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1_collage/core/models/task.dart';
import 'package:project1_collage/core/styles.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // 🆕

class AddTaskBottomSheet extends StatefulWidget {
  final Function(TaskModel) onTaskSaved;
  final String eventId;
  final TaskModel? existingTask;

  const AddTaskBottomSheet({
    super.key,
    required this.onTaskSaved,
    required this.eventId,
    this.existingTask,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  bool get _isEditMode => widget.existingTask != null;

  // 🆕 كل الحقول تُهيَّأ من existingTask إن وُجد (late تؤجل التقييم حتى يصبح widget جاهزًا)
  late final _titleController = TextEditingController(
    text: widget.existingTask?.title ?? '',
  );

  late bool _isDone = widget.existingTask?.isDone ?? false;

  late DateTime _selectedDate =
      widget.existingTask?.startDateTime ?? DateTime.now();

  late TimeOfDay _startTime = widget.existingTask != null
      ? TimeOfDay.fromDateTime(widget.existingTask!.startDateTime)
      : TimeOfDay.now();

  late TimeOfDay _endTime = widget.existingTask != null
      ? TimeOfDay.fromDateTime(widget.existingTask!.endDateTime)
      : TimeOfDay(
          hour: (TimeOfDay.now().hour + 1) % 24,
          minute: TimeOfDay.now().minute,
        );

  late int _selectedPriority = widget.existingTask?.priority ?? 3;


  // 🗓️ اختيار التاريخ فقط
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // ⏰ اختيار وقت البداية
  Future<void> _pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
        // إذا أصبح وقت النهاية قبل وقت البداية، نزيد وقت النهاية تلقائياً بساعة
        final startMinutes = _startTime.hour * 60 + _startTime.minute;
        final endMinutes = _endTime.hour * 60 + _endTime.minute;
        if (endMinutes <= startMinutes) {
          _endTime = TimeOfDay(
            hour: (_startTime.hour + 1) % 24,
            minute: _startTime.minute,
          );
        }
      });
    }
  }

  // ⏰ اختيار وقت النهاية
  Future<void> _pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (picked != null) {
      final startMinutes = _startTime.hour * 60 + _startTime.minute;
      final pickedMinutes = picked.hour * 60 + picked.minute;

      if (pickedMinutes <= startMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() {
        _endTime = picked;
      });
    }
  }

  // دالة مساعدة لتنسيق عرض TimeOfDay
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Title',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title of the task',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Is Task Done?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Switch(
                  value: _isDone,
                  onChanged: (val) => setState(() => _isDone = val),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 📅 اختيار التاريخ
            const Text(
              'Date',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    const Icon(Icons.calendar_month, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ⏰ 2. واجهة اختيار مجال الوقت (Start Time & End Time)
            const Text(
              'Time Range',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                // زر وقت البداية
                Expanded(
                  child: InkWell(
                    onTap: _pickStartTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Time',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTimeOfDay(_startTime),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // زر وقت النهاية
                Expanded(
                  child: InkWell(
                    onTap: _pickEndTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End Time',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatTimeOfDay(_endTime),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.access_time_filled,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            // تحديد الأولوية (Priority)
            const Text(
              'Priority',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [1, 2, 3].map((priority) {
                final isSelected = _selectedPriority == priority;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Container(
                        alignment: Alignment.center,
                        child: Text(
                          priority == 1
                              ? 'High'
                              : priority == 2
                              ? 'Medium'
                              : 'Low',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.deepPurpleAccent,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedPriority = priority);
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Styles.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                onPressed: () {
                  // 1. التحقق من إدخال العنوان
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter task title')),
                    );
                    return;
                  }

                  // 2. تركيب تاريخ ووقت البداية
                  final startDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _startTime.hour,
                    _startTime.minute,
                  );

                  // 3. تركيب تاريخ ووقت النهاية
                  final endDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _endTime.hour,
                    _endTime.minute,
                  );

                  // 4. إنشاء كائن المهمة الجديدة
                  final newTask = TaskModel(
                    id: widget.existingTask?.id ??
                        DateTime.now().toString(), // 🆕 نفس id عند التعديل
                    title: _titleController.text.trim(),
                    isDone: _isDone,
                    dateTime: startDateTime,
                    endDateTime: endDateTime,
                    priority: _selectedPriority,
                    eventId: widget.eventId,
                    eventTitle: widget.existingTask?.eventTitle ?? '',
                  );

                  // 5. إرسال المهمة للواجهة الرئيسية إجباريّاً
                  widget.onTaskSaved(newTask);

                  // 6. إغلاق الـ BottomSheet
                  Navigator.pop(context);
                },
                child:  Text(
                    _isEditMode ? 'Save Changes' : 'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
