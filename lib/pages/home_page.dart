import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:uni_gerenciador/pages/edit_task.dart';
import 'package:uni_gerenciador/utils/speding.dart';

import 'package:uni_gerenciador/utils/tasks.dart';

import 'package:uni_gerenciador/widgets/fab_widget.dart';
import 'package:uni_gerenciador/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Task> tasks = [];
  List<Spending> spendings = [];

  Future<void> getTasks() async {
    try {
      if (tasks.isNotEmpty) return;
      DatabaseReference ref = FirebaseDatabase.instance.ref('tasks');
      DatabaseEvent snap = await ref.once();

      Map<String, dynamic> data = jsonDecode(jsonEncode(snap.snapshot.value));

      data.forEach((key, value) {
        tasks.add(Task.fromJSON(value, key));
      });
      tasks.sort((a, b) => a.date.compareTo(b.date));
      tasks.sort((a, b) {
        if (a.isDone == true && b.isDone == false) {
          return 1;
        } else if (a.isDone == true && b.isDone == true) {
          return 0;
        } else {
          return -1;
        }
      });
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Verifique sua internet!'),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> getSpending() async {
    try {
      if (spendings.isNotEmpty) return;
      DateTime today = DateTime.now();
      DatabaseReference ref = FirebaseDatabase.instance
          .ref('spending')
          .child('${today.year}')
          .child('${today.month}');
      DatabaseEvent snap = await ref.once();

      if (snap.snapshot.value == null) return;
      Map<String, dynamic> data = jsonDecode(jsonEncode(snap.snapshot.value));
      data.forEach((key, value) {
        spendings.add(Spending.fromJSON(value, key));
      });

      spendings.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      // print('Algum erro ocorreu');
    }
  }

  DateFormat formatador = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

    //Vai marcar a tarefa como feita no BD a partir da notificação
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification notification) {
      if (notification.payload == null) return;
      if (notification.payload!.containsKey('taskId')) {
        String? id = notification.payload!['taskId'];
        DatabaseReference ref =
            FirebaseDatabase.instance.ref('tasks').child(id!);
        ref.update({'isDone': true});
      }
    });

    //Permite permissão para exibir notificações
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Permita notificações para o aplicativo'),
                  content: const Text(
                      'Para que o aplicativo funcione corretamente, você precisa permitir notificações'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar',
                            style: TextStyle(color: Colors.grey))),
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        AwesomeNotifications()
                            .requestPermissionToSendNotifications();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Página inicial'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  tasks = [];
                  spendings = [];
                });
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      drawer: const DrawerMenu(),
      floatingActionButton: const FAB(),
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text("Olá, Guilherme!",
                  style: Theme.of(context).textTheme.headline4),
            ),

            //Exibe as principais tarefas
            Text(
              "Tarefas",
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.start,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 350),
              child: FutureBuilder(
                  future: getTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return listTask();
                    }
                  }),
            ),
            const Divider(),
            Text(
              "Gastos",
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.start,
            ),
            ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 350),
                child: FutureBuilder(
                  future: getSpending(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return spendingShow();
                    }
                  },
                ))
          ],
        ),
      )),
    );
  }

  Widget listTask() {
    if (tasks.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: tasks
            .map((task) => Dismissible(
                key: ValueKey<String>(task.id!),
                background: Container(
                  color: Colors.green,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.white),
                        Text('Marcar como concluída',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Deletar tarefa',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.delete, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  //da esquerda para direita
                  if (direction == DismissDirection.startToEnd) {
                  }
                  //da direita para esquerda
                  else {}
                },
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text(formatador.format(task.date)),
                  trailing: const Icon(Icons.task_alt),
                  iconColor: (() {
                    if (task.isDone!) {
                      return Colors.black38;
                    } else {
                      if (task.date.isBefore(DateTime.now())) {
                        return Colors.red;
                      }
                      return Colors.green;
                    }
                  }()),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditTaskPage(task: task)));
                  },
                )))
            .toList(growable: false),
      );
    } else {
      return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhuma tarefa cadastrada',
              style: TextStyle(color: Colors.grey)));
    }
  }

  Widget spendingShow() {
    spendings.sort((a, b) => b.date.compareTo(a.date));
    if (spendings.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: spendings
            .map((spending) => ListTile(
                  title: Text(spending.name ?? 'Sem nome'),
                  subtitle: Text(formatador.format(spending.date)),
                  trailing: Icon(
                    Icons.monetization_on,
                    color: spending.isIncome ? Colors.green : Colors.red,
                  ),
                ))
            .toList(),
      );
    } else {
      return const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Nenhum gasto cadastrado',
              style: TextStyle(color: Colors.grey)));
    }
  }
}
