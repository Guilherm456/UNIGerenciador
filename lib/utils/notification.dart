import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:uni_gerenciador/utils/tasks.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterNotification =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('icon_app');
    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidSettings, iOS: iosInitializationSettings);
    tz.initializeTimeZones();

    await flutterNotification.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {});
  }

  Future<void> scheduleNotifications(Task task) async {
    const AndroidNotificationDetails _androidNotificationDetails =
        AndroidNotificationDetails(
      'channel ID',
      'channel name',
      channelDescription: 'channel description',
      playSound: true,
      priority: Priority.defaultPriority,
      importance: Importance.defaultImportance,
    );
    const IOSNotificationDetails _iosNotificationDetails =
        IOSNotificationDetails();
    // const NotificationDetails platformChannelSpecifics = NotificationDetails(
    //     android: _androidNotificationDetails, iOS: _iosNotificationDetails);
    await flutterNotification.zonedSchedule(
        task.id.hashCode,
        task.name,
        task.description,
        tz.TZDateTime.local(task.date.year, task.date.month, task.date.day,
            task.date.hour, task.date.minute, task.date.second),
        const NotificationDetails(
            iOS: _iosNotificationDetails, android: _androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(String id) async {
    await flutterNotification.cancel(id.hashCode);
  }

  Future<void> changeANotification(Task task) async {
    await cancelNotifications(task.id!);
    await scheduleNotifications(task);
  }
}
