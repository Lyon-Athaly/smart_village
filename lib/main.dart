import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:shared_preferences/shared_preferences.dart';

import 'data/facility_data.dart' as facility_data;
import 'models/facility.dart';

import 'screens/detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/route_screen.dart';
import 'screens/welcome_screen.dart';

import 'services/background_location_service.dart';
import 'services/location_service.dart';

import 'theme/app_theme.dart';
import 'widgets/app_bottom_nav.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await BackgroundLocationService.initialize();
  } catch (error) {
    debugPrint('Could not initialize background service: $error');
  }

  runApp(const SmartVillageApp());
}

class SmartVillageApp extends StatelessWidget {
  const SmartVillageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Village',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SmartVillageRoot(),
    );
  }
}

class SmartVillageRoot extends StatefulWidget {
  const SmartVillageRoot({super.key});

  @override
  State<SmartVillageRoot> createState() => _SmartVillageRootState();
}

class _SmartVillageRootState extends State<SmartVillageRoot>
    with WidgetsBindingObserver {
  static const String _favoritesKey = 'smart_village_favorites';

  final Set<String> _favoriteIds = <String>{};

  StreamSubscription<LatLng>? _locationSubscription;

  LatLng? _userLocation;

  String _locationStatus = 'GPS belum aktif';

  bool _geofencingEnabled = false;
  bool _geofencingLoading = false;
  bool _locationLoading = false;
  bool _showWelcome = true;

  int _currentIndex = 0;

  List<Facility> get _facilities => facility_data.facilities;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _loadFavorites();
    _syncGeofencingStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncGeofencingStatus();
    }
  }

  Future<void> _syncGeofencingStatus() async {
    try {
      final running = await BackgroundLocationService.isRunning();

      if (!mounted) return;

      setState(() {
        _geofencingEnabled = running;
      });
    } catch (error) {
      debugPrint('Could not read background service status: $error');
    }
  }

  Future<void> _loadFavorites() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final saved = preferences.getStringList(_favoritesKey) ?? <String>[];

      if (!mounted) return;

      setState(() {
        _favoriteIds
          ..clear()
          ..addAll(saved);
      });
    } catch (error) {
      debugPrint('Could not load favorites: $error');
    }
  }

  Future<void> _toggleFavorite(Facility facility) async {
    setState(() {
      if (!_favoriteIds.add(facility.id)) {
        _favoriteIds.remove(facility.id);
      }
    });

    try {
      final preferences = await SharedPreferences.getInstance();

      await preferences.setStringList(_favoritesKey, _favoriteIds.toList());
    } catch (error) {
      debugPrint('Could not save favorites: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan favorit.')));
    }
  }

  Future<void> _activateLocation() async {
    if (_locationLoading) return;

    setState(() {
      _locationLoading = true;
      _locationStatus = 'Mencari lokasi...';
    });

    try {
      final position = await LocationService.getCurrentLocation();

      if (!mounted) return;

      _updatePosition(position);

      await _locationSubscription?.cancel();

      if (!mounted) return;

      _locationSubscription = LocationService.watchLocation().listen(
        _updatePosition,
        onError: (Object error) {
          if (!mounted) return;

          setState(() {
            _locationStatus = 'GPS: $error';
          });
        },
      );

      setState(() {
        _locationStatus = 'GPS aktif';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _locationStatus = error.toString().replaceFirst('Exception: ', '');
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_locationStatus)));
    } finally {
      if (mounted) {
        setState(() {
          _locationLoading = false;
        });
      }
    }
  }

  void _updatePosition(LatLng position) {
    if (!mounted) return;

    setState(() {
      _userLocation = position;
    });

    // Geofencing is handled by the background service.
    // Do not run duplicate geofence checks here.
  }

  Future<void> _setGeofencing(bool enabled) async {
    if (_geofencingLoading) return;

    setState(() {
      _geofencingLoading = true;
    });

    try {
      if (enabled) {
        await BackgroundLocationService.start();
      } else {
        await BackgroundLocationService.stop();
      }

      if (!mounted) return;

      final running = await BackgroundLocationService.isRunning();

      setState(() {
        _geofencingEnabled = enabled && running;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Pemantauan geofencing background aktif'
                : 'Pemantauan geofencing dinonaktifkan',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal mengubah geofencing: '
            '${error.toString().replaceFirst("Exception: ", "")}',
          ),
        ),
      );

      await _syncGeofencingStatus();
    } finally {
      if (mounted) {
        setState(() {
          _geofencingLoading = false;
        });
      }
    }
  }

  void _openFacility(Facility facility) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (detailContext) => StatefulBuilder(
          builder: (detailContext, refreshDetail) => DetailScreen(
            facility: facility,
            userLocation: _userLocation,
            isFavorite: _favoriteIds.contains(facility.id),
            onFavoriteTap: () async {
              await _toggleFavorite(facility);

              if (detailContext.mounted) {
                refreshDetail(() {});
              }
            },
            onRouteTap: () {
              Navigator.of(detailContext).push(
                MaterialPageRoute<void>(
                  builder: (_) => RouteScreen(
                    facility: facility,
                    userLocation: _userLocation,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _selectedScreen() {
    switch (_currentIndex) {
      case 0:
        return HomeScreen(
          facilities: _facilities,
          userLocation: _userLocation,
          favoriteIds: _favoriteIds,
          onFacilityTap: _openFacility,
          onFavoriteTap: _toggleFavorite,
          onLocationRequest: _activateLocation,
        );

      case 1:
        return MapScreen(
          facilities: _facilities,
          userLocation: _userLocation,
          onFacilityTap: _openFacility,
          onLocationRequest: _activateLocation,
        );

      case 2:
        return FavoritesScreen(
          facilities: _facilities,
          favoriteIds: _favoriteIds,
          userLocation: _userLocation,
          onFacilityTap: _openFacility,
          onFavoriteTap: _toggleFavorite,
        );

      default:
        return ProfileScreen(
          userLocation: _userLocation,
          locationStatus: _locationStatus,
          geofencingEnabled: _geofencingEnabled,
          onLocationRequest: _activateLocation,
          onGeofencingChanged: _setGeofencing,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return WelcomeScreen(
        onGetStarted: () {
          setState(() {
            _showWelcome = false;
          });
        },
      );
    }

    return Scaffold(
      body: _selectedScreen(),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _locationSubscription?.cancel();

    // Do not stop the background service here.
    // It must continue when the app is minimized.

    super.dispose();
  }
}
