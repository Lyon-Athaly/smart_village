import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';
import '../services/location_service.dart';
import '../services/cost_service.dart';
import '../widgets/hospital_painter.dart';

class DetailScreen extends StatelessWidget {
  final Facility facility;
  final LatLng? userLocation;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onRouteTap;

  const DetailScreen({
    super.key,
    required this.facility,
    required this.userLocation,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onRouteTap,
  });

  @override
  Widget build(BuildContext context) {
    final distance = userLocation == null
        ? null
        : LocationService.distanceKm(userLocation!, facility.point);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Fasilitas'),
        actions: [
          IconButton(
            onPressed: onFavoriteTap,
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.pink,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CustomPaint(
                painter: HospitalPainter(accent: facility.color),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            facility.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Chip(label: Text(facility.category)),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(facility.address),
          ),
          ListTile(
            leading: const Icon(Icons.route),
            title: Text(
              distance == null
                  ? 'Jarak belum tersedia'
                  : '${distance.toStringAsFixed(2)} km',
            ),
            subtitle: const Text('Jarak garis lurus'),
          ),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: Text(
              distance == null
                  ? 'Aktifkan GPS untuk estimasi'
                  : CostService.formatRupiah(
                      CostService.estimatedCost(distance),
                    ),
            ),
            subtitle: const Text('Estimasi biaya transportasi'),
          ),
          const SizedBox(height: 18),
          const Text(
            'Layanan Tersedia',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final service in facility.services)
            ListTile(
              dense: true,
              leading: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
              title: Text(service),
            ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRouteTap,
            icon: const Icon(Icons.directions),
            label: const Text('Lihat Rute'),
          ),
        ],
      ),
    );
  }
}
