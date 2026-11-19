import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await notificationPlugin.initialize(initSettings);

    final androidPlatform =
        notificationPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlatform?.requestNotificationsPermission();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fav_spell_channel',
      'Favorite Spell Notifications',
      description: 'Notifikasi penghapusan spell favorit',
      importance: Importance.high,
    );

    await androidPlatform?.createNotificationChannel(channel);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'fav_spell_channel',
      'Favorite Spell Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notifDetails =
        NotificationDetails(android: androidDetails);

    await notificationPlugin.show(0, title, body, notifDetails);
  }
}