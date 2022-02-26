import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:uni_gerenciador/utils/database.dart';
import 'package:uni_gerenciador/utils/notification.dart';
import 'package:uni_gerenciador/widgets/app_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(100000);
    await NotificationService().init();
    //Vai marcar a tarefa como feita no BD a partir da notificação

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification notification) {
      if (notification.payload == null) return;
      if (notification.payload!.containsKey('taskId')) {
        String? id = notification.payload!['taskId'];
        if (id == null) return;
        DataBase().editAttribute(id, "isDone", true);
      }
    });
  } catch (e) {
    // print(e);
  }

  runApp(const AppWidget());
}
