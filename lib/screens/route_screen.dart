import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';
import '../services/location_service.dart';

class RouteScreen extends StatelessWidget {
  final Facility facility;
  final LatLng? userLocation;

  const RouteScreen({
    super.key,
    required this.facility,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final origin = userLocation;
    final destination = facility.point;

    final distance = origin == null
        ? null
        : LocationService.distanceKm(origin, destination);

    return Scaffold(
      appBar: AppBar(title: const Text('Rute Fasilitas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  distance == null
                      ? 'Aktifkan GPS untuk melihat rute.'
                      : 'Jarak garis lurus: '
                            '${distance.toStringAsFixed(2)} km',
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: origin == null
                    ? destination
                    : LatLng(
                        (origin.latitude + destination.latitude) / 2,
                        (origin.longitude + destination.longitude) / 2,
                      ),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/'
                      '{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smartvillage',
                ),
                if (origin != null)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [origin, destination],
                        color: Colors.blue,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    if (origin != null)
                      Marker(
                        point: origin,
                        width: 45,
                        height: 45,
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 42,
                        ),
                      ),
                    Marker(
                      point: destination,
                      width: 45,
                      height: 45,
                      child: Icon(
                        Icons.location_on,
                        color: facility.color,
                        size: 42,
                      ),
                    ),
                  ],
                ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
