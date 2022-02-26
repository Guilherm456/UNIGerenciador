import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_gerenciador/pages/edit_task.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/widgets/drawer_widget.dart';
import 'package:uni_gerenciador/utils/database.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }
}

class TaskState extends State<TaskPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Task> tasks = [],
      tasks_aFazer = [],
      tasks_atrasadas = [],
      tasks_feitas = [];
  final teste = DateTime.now;
  DateFormat formatador = DateFormat('dd/MM/yyyy');
  Future<void> getData() async {
    try {
      await DataBase().getTasks().then((value) {
        if (value == null) return;
        tasks = value;
        tasks_aFazer = tasks
            .where((task) =>
                task.isDone == false && !task.date.isBefore(DateTime.now()))
            .toList();
        tasks_atrasadas = tasks
            .where((task) =>
                task.date.isBefore(DateTime.now()) && task.isDone == false)
            .toList();
        tasks_feitas = tasks.where((task) => task.isDone == true).toList();
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Unigerenciador'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    tasks = [];
                  });
                },
                icon: const Icon(Icons.refresh)),
          ],
        ),
        drawer: const DrawerMenu(),
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  return Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text('Tarefas',
                              style: Theme.of(context).textTheme.headline4)),
                      Text(
                        "A fazer",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.start,
                      ),
                      ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: tasks_aFazer
                              .map((task) => ListTile(
                                  title: Text(task.name),
                                  subtitle: Text(formatador.format(task.date)),
                                  trailing: const Icon(Icons.task_alt),
                                  iconColor: Colors.black38,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditTaskPage(task: task)));
                                  }))
                              .toList()),
                      Divider(),
                      Text(
                        "Com atraso",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.start,
                      ),
                      ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: tasks_atrasadas
                              .map((task) => ListTile(
                                    title: Text(task.name),
                                  ))
                              .toList()),
                      Divider(),
                      Text(
                        "Concluídas",
                        style: Theme.of(context).textTheme.subtitle1,
                        textAlign: TextAlign.start,
                      ),
                      ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: tasks_feitas
                              .map((task) => ListTile(
                                    title: Text(task.name),
                                  ))
                              .toList()),
                    ],
                  );
              }
            },
          ),
        )));
  }
}
