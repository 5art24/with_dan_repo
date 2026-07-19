// // lib/core/models/event.dart
// import 'package:flutter/material.dart';
// import 'package:project1_collage/core/models/constant_event.dart';
// import 'package:project1_collage/core/models/personal_event.dart';

// abstract class DisplayableEvent {
//   String get id;
//   String get title;
//   DateTime get date;
//   IconData get icon;
//   Color get color;
//   double get progress;
//   String get type;
//   String get location;
//   String get cardType;
//   String get formattedDateTime;
//   List<String>? get imageUrl;
//   int get tasksCount;
//   int get completedTasksCount;
// }

// class ConstantEventAdapter implements DisplayableEvent {
//   final ConstantEventModel event;
//   ConstantEventAdapter(this.event);

//   @override String get id => event.id;
//   @override String get title => event.name;
//   @override DateTime get date => event.date;
//   @override String get location => event.location;
//   @override String get type => 'constant';
//   @override String get cardType => 'featured';
//   @override String get formattedDateTime => event.formattedDateTime;
//   @override List<String>? get imageUrl => event.imageUrl;
//   @override int get tasksCount => 0;
//   @override int get completedTasksCount => 0;

//   @override
//   IconData get icon {
//     switch (event.type) {
//       case EventType.artistic: return Icons.art_track;
//       case EventType.technical: return Icons.computer;
//       case EventType.music: return Icons.music_note;
//       case EventType.cultural: return Icons.museum;
//       case EventType.comedy: return Icons.theater_comedy;
//       case EventType.educational: return Icons.school;
//       case EventType.commercial: return Icons.storefront;
//       case EventType.workshop: return Icons.construction;
//       case EventType.fitness: return Icons.fitness_center;
//       default: return Icons.event;
//     }
//   }

//   @override
//   Color get color {
//     switch (event.type) {
//       case EventType.artistic: return Colors.purple.shade300;
//       case EventType.technical: return Colors.blue.shade300;
//       case EventType.music: return Colors.pink.shade300;
//       default: return Colors.grey.shade300;
//     }
//   }

//   @override
//   double get progress {
//     final totalDays = event.date.difference(DateTime.now()).inDays;
//     if (totalDays <= 0) return 1.0;
//     return (1 - (totalDays / 30)).clamp(0.0, 1.0);
//   }
// }

// class PersonalEventAdapter implements DisplayableEvent {
//   final PersonalEvent event;
//   PersonalEventAdapter(this.event);

//   @override String get id => event.id;
//   @override String get title => event.name;
//   @override DateTime get date => event.date;
//   @override String get location => event.location;
//   @override String get type => 'personal';
//   @override String get cardType => 'compact';
//   @override String get formattedDateTime => '';
//   @override List<String>? get imageUrl => null;

//   @override
//   IconData get icon {
//     switch (event.category) {
//       case 'wedding': return Icons.favorite;
//       case 'birthday': return Icons.cake;
//       case 'party': return Icons.celebration;
//       case 'meeting': return Icons.meeting_room;
//       default: return Icons.event_note;
//     }
//   }

//   @override
//   Color get color {
//     switch (event.category) {
//       case 'wedding': return Colors.pink.shade300;
//       case 'birthday': return Colors.orange.shade300;
//       case 'party': return Colors.purple.shade300;
//       default: return Colors.green.shade300;
//     }
//   }

//   @override
//   double get progress {
//     if (event.tasks.isEmpty) return 0.0;
//     final completed = event.tasks.where((t) => t.isDone).length;
//     return completed / event.tasks.length;
//   }

//   @override
//   int get tasksCount => event.tasks.length;
//   @override
//   int get completedTasksCount => event.tasks.where((t) => t.isDone).length;
// }