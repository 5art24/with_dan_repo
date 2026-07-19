import 'package:flutter/material.dart';
import 'package:project1_collage/core/models/service.dart';

class ServiceItem {
  ServiceItem({required this.service, required this.icon});

  final ServiceModel service;
  final String icon; // أو يمكن استخدام صورة AssetImage/NetworkImage
}
