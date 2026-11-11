import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;

class ProfileScreen extends StatelessWidget {
  final LatLng? userLocation;
  final String locationStatus;
  final bool geofencingEnabled;
  final VoidCallback onLocationRequest;
  final ValueChanged<bool> onGeofencingChanged;

  const ProfileScreen({
    super.key,
    required this.userLocation,
    required this.locationStatus,
    required this.geofencingEnabled,
    required this.onLocationRequest,
    required this.onGeofencingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(title: const Text('Profil & Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 42,
            backgroundColor: Color(0xFFDDEEFF),
            child: Icon(Icons.person, size: 48, color: Color(0xFF0875E1)),
          ),
          const SizedBox(height: 14),
          const Center(
            child: Text(
              'Pengguna Smart Village',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 28),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.gps_fixed),
                  title: const Text('Status GPS'),
                  subtitle: Text(locationStatus),
                  trailing: IconButton(
                    tooltip: 'Aktifkan GPS',
                    icon: const Icon(Icons.refresh),
                    onPressed: onLocationRequest,
                  ),
                ),
                if (userLocation != null)
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Koordinat Anda'),
                    subtitle: Text(
                      '${userLocation!.latitude.toStringAsFixed(5)}, '
                      '${userLocation!.longitude.toStringAsFixed(5)}',
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.notifications_active),
              title: const Text('Geofencing'),
              subtitle: const Text(
                'Peringatan ketika memasuki radius '
                '500 meter fasilitas kesehatan.',
              ),
              value: geofencingEnabled,
              onChanged: onGeofencingChanged,
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Tentang Aplikasi'),
              subtitle: Text(
                'Smart Village membantu menemukan '
                'fasilitas kesehatan melalui GPS, '
                'peta digital, dan geofencing.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
