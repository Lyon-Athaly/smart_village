import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';
import '../services/location_service.dart';
import '../widgets/category_filter.dart';
import '../widgets/facility_card.dart';

class HomeScreen extends StatefulWidget {
  final List<Facility> facilities;
  final LatLng? userLocation;
  final Set<String> favoriteIds;
  final ValueChanged<Facility> onFacilityTap;
  final ValueChanged<Facility> onFavoriteTap;
  final VoidCallback onLocationRequest;

  const HomeScreen({
    super.key,
    required this.facilities,
    required this.userLocation,
    required this.favoriteIds,
    required this.onFacilityTap,
    required this.onFavoriteTap,
    required this.onLocationRequest,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Semua';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.facilities.where((facility) {
      final matchesCategory =
          selectedCategory == 'Semua' || facility.category == selectedCategory;

      final query = searchQuery.toLowerCase();

      final matchesSearch =
          facility.name.toLowerCase().contains(query) ||
          facility.address.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();

    if (widget.userLocation != null) {
      filtered.sort((a, b) {
        final distanceA = LocationService.distanceKm(
          widget.userLocation!,
          a.point,
        );
        final distanceB = LocationService.distanceKm(
          widget.userLocation!,
          b.point,
        );
        return distanceA.compareTo(distanceB);
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(
        title: const Text('Smart Village'),
        actions: [
          IconButton(
            onPressed: widget.onLocationRequest,
            icon: const Icon(Icons.my_location),
            tooltip: 'Aktifkan GPS',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Temukan Fasilitas Kesehatan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.userLocation == null
                ? 'Aktifkan GPS untuk melihat jarak.'
                : 'Fasilitas diurutkan berdasarkan jarak.',
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (value) {
              setState(() => searchQuery = value);
            },
            decoration: InputDecoration(
              hintText: 'Cari rumah sakit atau klinik...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CategoryShortcuts(
            onSelected: (category) {
              setState(() => selectedCategory = category);
            },
          ),
          const SizedBox(height: 20),
          CategoryFilter(
            selectedCategory: selectedCategory,
            onChanged: (category) {
              setState(() => selectedCategory = category);
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Fasilitas Kesehatan (${filtered.length})',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Tidak ada fasilitas ditemukan.')),
            ),
          for (final facility in filtered)
            FacilityCard(
              facility: facility,
              distanceKm: widget.userLocation == null
                  ? null
                  : LocationService.distanceKm(
                      widget.userLocation!,
                      facility.point,
                    ),
              isFavorite: widget.favoriteIds.contains(facility.id),
              onTap: () => widget.onFacilityTap(facility),
              onFavorite: () => widget.onFavoriteTap(facility),
            ),
        ],
      ),
    );
  }
}
