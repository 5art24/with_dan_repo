import 'package:project1_collage/core/models/personal_event.dart';

class User {
  final String username;
  final String urlImage;
  List<PersonalEvent> _personalEvents = [];

  List<PersonalEvent> get personalEvents => List.unmodifiable(_personalEvents);

  User({required this.urlImage, required this.username});

   void addPersonalEvent(PersonalEvent event) {
    _personalEvents.add(event);
  }
  void removePersonalEvent(PersonalEvent event) {
    _personalEvents.remove(event);
  }
  //clear all
   void clearPersonalEvents() {
    _personalEvents.clear();
  }
}
