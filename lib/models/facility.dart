import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

class Facility {
  final String id;
  final String name;
  final String category;
  final String address;
  final LatLng point;
  final List<String> services;

  const Facility({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.point,
    required this.services,
  });

  Color get color {
    if (category == 'Rumah Sakit') {
      return const Color(0xFFE94C69);
    }

    if (category == 'Puskesmas') {
      return const Color(0xFF20A66A);
    }

    return const Color(0xFF0875E1);
  }
}
