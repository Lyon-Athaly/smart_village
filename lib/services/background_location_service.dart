import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' hide Path;

import '../data/facility_data.dart';
import 'geofencing_service.dart';
import 'notification_service.dart';

class BackgroundLocationService {
  BackgroundLocationService._();

  static final FlutterBackgroundService _service = FlutterBackgroundService();

  static Future<void> initialize() async {
    await NotificationService.initialize();

    await _service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: backgroundLocationEntryPoint,
        autoStart: false,
        autoStartOnBoot: false,
        isForegroundMode: true,
        notificationChannelId: NotificationService.trackingChannelId,
        initialNotificationTitle: 'Smart Village',
        initialNotificationContent: 'Pemantauan geofencing aktif',
        foregroundServiceNotificationId: 9000,
        foregroundServiceTypes: [AndroidForegroundType.location],
      ),
      iosConfiguration: IosConfiguration(autoStart: false),
    );
  }

  static Future<void> start() async {
    final gpsEnabled = await Geolocator.isLocationServiceEnabled();

    if (!gpsEnabled) {
      throw Exception('GPS belum aktif. Aktifkan lokasi perangkat.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi belum diberikan.');
    }

    final notificationAllowed = await NotificationService.requestPermission();

    if (!notificationAllowed) {
      throw Exception('Izinkan notifikasi untuk menggunakan fitur ini.');
    }

    if (!await _service.isRunning()) {
      final started = await _service.startService();

      if (!started) {
        throw Exception('Layanan pemantauan gagal dimulai.');
      }
    }
  }

  static Future<void> stop() async {
    if (await _service.isRunning()) {
      _service.invoke('stopService');
    }
  }

  static Future<bool> isRunning() async {
    return _service.isRunning();
  }
}

@pragma('vm:entry-point')
void backgroundLocationEntryPoint(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  await NotificationService.initialize();

  final geofencing = GeofencingService();

  final lastAlert = <String, DateTime>{};

  const cooldown = Duration(minutes: 10);

  StreamSubscription<Position>? locationSubscription;

  bool stopping = false;
  bool processing = false;

  service.on('stopService').listen((event) async {
    if (stopping) return;

    stopping = true;

    await locationSubscription?.cancel();

    service.stopSelf();
  });

  Future<void> checkLocation(Position position) async {
    if (stopping || processing) return;

    processing = true;

    try {
      final currentLocation = LatLng(position.latitude, position.longitude);

      final events = geofencing.checkPosition(currentLocation, facilities);

      for (final event in events) {
        if (stopping || !event.entered) continue;

        final facility = event.facility;
        final now = DateTime.now();
        final previous = lastAlert[facility.id];

        if (previous != null && now.difference(previous) < cooldown) {
          continue;
        }

        lastAlert[facility.id] = now;

        final notificationId = 10000 + facilities.indexOf(facility);

        await NotificationService.showGeofenceAlert(
          id: notificationId,
          facilityName: facility.name,
        );
      }
    } catch (error) {
      debugPrint('Geofencing error: $error');
    } finally {
      processing = false;
    }
  }

  try {
    final initialPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );

    await checkLocation(initialPosition);
  } catch (error) {
    debugPrint('Initial location unavailable: $error');
  }

  if (stopping) return;

  locationSubscription =
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 30,
        ),
      ).listen(
        (position) {
          checkLocation(position);
        },
        onError: (Object error) {
          debugPrint('Location stream error: $error');
        },
      );
}
