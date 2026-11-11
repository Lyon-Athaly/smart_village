import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';
import '../services/location_service.dart';
import '../widgets/facility_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Facility> facilities;
  final Set<String> favoriteIds;
  final LatLng? userLocation;
  final ValueChanged<Facility> onFacilityTap;
  final ValueChanged<Facility> onFavoriteTap;

  const FavoritesScreen({
    super.key,
    required this.facilities,
    required this.favoriteIds,
    required this.userLocation,
    required this.onFacilityTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final favorites = facilities
        .where((facility) => favoriteIds.contains(facility.id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(title: const Text('Fasilitas Favorit')),
      body: favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Belum ada fasilitas favorit.'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final facility = favorites[index];

                return FacilityCard(
                  facility: facility,
                  distanceKm: userLocation == null
                      ? null
                      : LocationService.distanceKm(
                          userLocation!,
                          facility.point,
                        ),
                  isFavorite: true,
                  onTap: () => onFacilityTap(facility),
                  onFavorite: () => onFavoriteTap(facility),
                );
              },
            ),
    );
  }
}
