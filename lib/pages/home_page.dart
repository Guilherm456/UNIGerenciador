import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:uni_gerenciador/pages/edit_task.dart';

import 'package:uni_gerenciador/utils/database.dart';
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
  String name = "Usuário";

  Future<void> getTasks() async {
    try {
      if (tasks.isNotEmpty) return;
      name = await DataBase().getName();
      tasks = (await DataBase().getTasks())!;
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
      // print(e);
    }
  }

  Future<void> getSpending() async {
    try {
      if (spendings.isNotEmpty) return;

      await DataBase().getExpenses(DateTime.now()).then((value) {
        if (value == null) return;
        spendings = value;
        spendings.sort((a, b) => a.date.compareTo(b.date));
      });
    } catch (e) {
      // print('Algum erro ocorreu');
    }
  }

  DateFormat formatador = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text("Olá, $name!",
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
                          return const Center(
                              child: CircularProgressIndicator());
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
                          return const Center(
                              child: CircularProgressIndicator());
                        default:
                          return spendingShow();
                      }
                    },
                  ))
            ],
          ),
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
                        Icon(Icons.done, color: Colors.white),
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
                confirmDismiss: (direction) async {
                  //da esquerda para direita
                  if (direction == DismissDirection.startToEnd) {
                    DataBase().editAttribute(task.id, "isDone", true);
                    setState(() {
                      tasks.firstWhere((element) => element == task).isDone =
                          true;
                    });
                    return false;
                  }
                  //da direita para esquerda
                  else {
                    bool deleted = false;
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Apagar tarefa'),
                              content: const Text(
                                  'Você tem certeza que deseja apagar esta tarefa?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      DataBase().deleteTask(task.id!);
                                      deleted = true;
                                      setState(() {
                                        tasks.remove(task);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Apagar',
                                        style: TextStyle(color: Colors.red)))
                              ],
                            ));
                    return deleted;
                  }
                },
                child: ListTile(
                  title: Text(task.name),
                  subtitle: Text(formatador.format(task.date)),
                  trailing: const Icon(Icons.task_alt),
                  iconColor: (() {
                    if (task.isDone!) {
                      return Colors.grey;
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
