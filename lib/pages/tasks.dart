import 'package:flutter/material.dart';
import 'package:uni_gerenciador/widgets/drawer_widget.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }
}

class TaskState extends State<TaskPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tarefas'),
        ),
        drawer: const DrawerMenu(),
        body: SafeArea(
            child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tarefas próximas',
                  style: Theme.of(context).textTheme.subtitle1)),
        )));
  }
}
