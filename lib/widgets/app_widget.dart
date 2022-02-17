import 'package:flutter/material.dart';
import 'package:uni_gerenciador/pages/add_spending.dart';
import 'package:uni_gerenciador/pages/tasks.dart';

import '../pages/add_task.dart';
import '../pages/home_page.dart';

class Paleta {
  static const MaterialColor colorDefault =
      MaterialColor(0xFFB74065, <int, Color>{
    50: Color(0xFFa53a5b), //10%
    100: Color(0xFF923351), //20%
    200: Color(0xFF802d47), //30%
    300: Color(0xFF6e263d), //40%
    400: Color(0xFF5c2033), //50%
    500: Color(0xFF491a28), //60%
    600: Color(0xFF37131e), //70%
    700: Color(0xFF250d14), //80%
    800: Color(0xFF12060a), //90%
    900: Color(0xFF000000), //100%
  });
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Paleta.colorDefault,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.system,
            title: 'Uni Gerenciador',
            initialRoute: '/',
            routes: {
              '/': (context) => const HomePage(),
              '/addtask': (context) => const AddTaskPage(),
              '/addspending': (context) => const AddSpendingPage(),
              '/tasks': (context) => const TaskPage(),
            },
            locale: const Locale('pt', 'BR'),
          );
        });
  }
}

class AppController extends ChangeNotifier {
  static AppController instance = AppController();
}
