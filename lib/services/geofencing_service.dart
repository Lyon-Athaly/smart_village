import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';
import 'location_service.dart';

class GeofenceEvent {
  final Facility facility;
  final bool entered;

  const GeofenceEvent({required this.facility, required this.entered});
}

class GeofencingService {
  static const double radiusKm = 0.5;

  final Set<String> _insideZones = {};

  List<GeofenceEvent> checkPosition(
    LatLng position,
    List<Facility> facilities,
  ) {
    final events = <GeofenceEvent>[];

    for (final facility in facilities) {
      final distance = LocationService.distanceKm(position, facility.point);

      final inside = distance <= radiusKm;
      final wasInside = _insideZones.contains(facility.id);

      if (inside && !wasInside) {
        _insideZones.add(facility.id);

        events.add(GeofenceEvent(facility: facility, entered: true));
      } else if (!inside && wasInside) {
        _insideZones.remove(facility.id);

        events.add(GeofenceEvent(facility: facility, entered: false));
      }
    }

    return events;
  }

  bool isInside(String facilityId) {
    return _insideZones.contains(facilityId);
  }

  void reset() {
    _insideZones.clear();
  }
}
