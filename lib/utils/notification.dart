import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/tasks.dart';

class NotificationService {
  Future<void> init() async {
    AwesomeNotifications().initialize('resource://drawable/app_icon', [
      NotificationChannel(
        channelKey: 'tasks',
        channelName: 'Lembretes de tarefas',
        channelDescription: 'Aviso de tarefas agendadas',
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        enableVibration: true,
        defaultRingtoneType: DefaultRingtoneType.Notification,
        playSound: true,
        channelShowBadge: true,
        locked: true,
      )
    ]);
  }

  Future<void> scheduleNotifications(Task task) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: task.id.hashCode,
          channelKey: 'tasks',
          title: task.name,
          body: task.description,
          payload: {"taskId": task.id!},
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'FEITO',
              label: 'Marcar como concluída',
              buttonType: ActionButtonType.Default,
              autoDismissible: true)
        ],
        schedule: NotificationCalendar(
          year: task.date.year,
          month: task.date.month,
          day: task.date.day,
          hour: task.date.hour,
          minute: 1,
          second: 0,
          weekday: task.date.weekday,
        ));
  }

  Future<void> cancelNotifications(String id) async {
    await AwesomeNotifications().cancelSchedule(id.hashCode);
  }

  Future<void> changeANotification(Task task) async {
    await cancelNotifications(task.id!);
    await scheduleNotifications(task);
  }
}
