import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/database.dart';
import 'package:uni_gerenciador/utils/tasks.dart';

class NotificationService {
  init() async {
    try {
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
    } catch (e) {
      // print(e);
    }
  }

  Future<void> scheduleNotifications(Task task) async {
    try {
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
    } catch (e) {
      // print(e);
    }
  }

  Future<void> addAllTasks() async {
    List<Task> tasks = [];

    try {
      await DataBase().getTasks().then((value) => tasks = value!);
      for (Task task in tasks) {
        await scheduleNotifications(task);
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> cancelNotifications(String id) async {
    try {
      await AwesomeNotifications().cancelSchedule(id.hashCode);
    } catch (e) {
      // print(e);
    }
  }

  Future<void> changeANotification(Task task) async {
    try {
      await cancelNotifications(task.id!);
      await scheduleNotifications(task);
    } catch (e) {
      // print(e);
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
    } catch (e) {
      // print(e);
    }
  }

  Future<int> getNotifications() async {
    try {
      var list = await AwesomeNotifications().listScheduledNotifications();
      return list.length;
    } catch (e) {
      // print(e);
      return 0;
    }
  }
}
