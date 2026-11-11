import 'package:latlong2/latlong.dart' hide Path;

import '../models/facility.dart';

// Demonstration coordinates, not verified healthcare locations.

const demoCenter = LatLng(-6.2000, 106.8167);

const facilities = <Facility>[
  Facility(
    id: 'rs1',
    name: 'RSUD Kabupaten X',
    category: 'Rumah Sakit',
    address: 'Lokasi demonstrasi Jakarta Pusat',
    point: LatLng(-6.2000, 106.8167),
    services: ['IGD', 'Poliklinik', 'Rawat Inap', 'Laboratorium'],
  ),
  Facility(
    id: 'pk1',
    name: 'Puskesmas Sukamaju',
    category: 'Puskesmas',
    address: 'Lokasi demonstrasi Menteng',
    point: LatLng(-6.1930, 106.8250),
    services: ['Poli Umum', 'KIA', 'Imunisasi'],
  ),
  Facility(
    id: 'kl1',
    name: 'Klinik Sehat Mandiri',
    category: 'Klinik',
    address: 'Lokasi demonstrasi Tanah Abang',
    point: LatLng(-6.1900, 106.8050),
    services: ['Poli Umum', 'Laboratorium'],
  ),
  Facility(
    id: 'rs2',
    name: 'RS Harapan Bunda',
    category: 'Rumah Sakit',
    address: 'Lokasi demonstrasi Jakarta',
    point: LatLng(-6.2150, 106.8300),
    services: ['IGD', 'Rawat Inap', 'Radiologi'],
  ),
];
