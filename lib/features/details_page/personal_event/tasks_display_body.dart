import 'package:flutter/material.dart';
import 'package:project1_collage/core/styles.dart';

class TasksDisplayBody extends StatelessWidget {
  const TasksDisplayBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TASKS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Icon(Icons.check, color: Styles.mainColor),
            ],
          ),
          const SizedBox(height: 20),

          // قائمة المهام
          Expanded(
            child: ListView(
              children: [
                _buildTaskCard("1", "Today 7:37 PM", "Medium", Colors.red.shade100),
                const SizedBox(height: 12),
                _buildTaskCard("1", "Aug 22 7:38 PM", "Normal", Colors.purple.shade100),
              ],
            ),
          ),

          // زر إضافة مهمة جديدة
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.mainColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {},
              child: const Text("Create a new task", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String time, String priority, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(priority, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.check_box_outline_blank, color: Colors.black54),
        ],
      ),
    );
  }
}