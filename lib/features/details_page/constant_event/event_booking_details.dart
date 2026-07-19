import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/constant_event.dart';
import 'package:project1_collage/features/details_page/constant_event/views/widgets/event_booking_details_body.dart';

class ConstantEventDetails extends StatelessWidget {
  final ConstantEventModel constantEvent;
  
  const ConstantEventDetails({super.key, required this.constantEvent});

  @override
  Widget build(BuildContext context) {
    return ConstantEventDetailsBody(constantEvent: constantEvent);
  }
}