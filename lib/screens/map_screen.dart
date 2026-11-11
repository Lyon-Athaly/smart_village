import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../data/facility_data.dart';
import '../models/facility.dart';

class MapScreen extends StatefulWidget {
  final List<Facility> facilities;
  final LatLng? userLocation;
  final ValueChanged<Facility> onFacilityTap;
  final VoidCallback onLocationRequest;

  const MapScreen({
    super.key,
    required this.facilities,
    required this.userLocation,
    required this.onFacilityTap,
    required this.onLocationRequest,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta Fasilitas')),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: widget.userLocation ?? demoCenter,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.smartvillage',
          ),
          MarkerLayer(
            markers: [
              for (final facility in widget.facilities)
                Marker(
                  point: facility.point,
                  width: 48,
                  height: 48,
                  child: GestureDetector(
                    onTap: () => widget.onFacilityTap(facility),
                    child: Icon(
                      Icons.location_on,
                      color: facility.color,
                      size: 42,
                    ),
                  ),
                ),
              if (widget.userLocation != null)
                Marker(
                  point: widget.userLocation!,
                  width: 42,
                  height: 42,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
            ],
          ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Lokasi saya',
        onPressed: () {
          widget.onLocationRequest();

          final location = widget.userLocation;
          if (location != null) {
            mapController.move(location, 15);
          }
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
