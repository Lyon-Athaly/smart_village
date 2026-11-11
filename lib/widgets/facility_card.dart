import 'package:flutter/material.dart';

import '../models/facility.dart';
import 'hospital_painter.dart';

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final double? distanceKm;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const FacilityCard({
    super.key,
    required this.facility,
    required this.distanceKm,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF17345A);
    const muted = Color(0xFF75869C);
    const pink = Color(0xFFE94C69);

    return Card(
      color: Colors.white,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: CustomPaint(
                    painter: HospitalPainter(accent: facility.color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      facility.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: navy,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${distanceKm?.toStringAsFixed(1) ?? '—'} km'
                      ' · ${facility.category}',
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      facility.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: pink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
