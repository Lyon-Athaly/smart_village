
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String geofenceChannelId =
      'smart_village_geofence_v1';

  static const String trackingChannelId =
      'smart_village_tracking_v1';

  static Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );

    await _plugin.initialize(settings);

    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        geofenceChannelId,
        'Peringatan Fasilitas Kesehatan',
        description:
        'Notifikasi ketika memasuki radius 500 meter',
        importance: Importance.high,
      ),
    );

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        trackingChannelId,
        'Pemantauan Lokasi Smart Village',
        description:
        'Notifikasi layanan pemantauan lokasi',
        importance: Importance.low,
      ),
    );
  }

  static Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    return await android
        ?.requestNotificationsPermission() ??
        true;
  }

  static Future<void> showGeofenceAlert({
    required int id,
    required String facilityName,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        geofenceChannelId,
        'Peringatan Fasilitas Kesehatan',
        channelDescription:
        'Notifikasi ketika memasuki radius 500 meter',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
    );

    await _plugin.show(
      id,
      'Fasilitas Kesehatan Terdekat',
      'Anda memasuki radius 500 meter dari $facilityName.',
      details,
    );
  }
}
