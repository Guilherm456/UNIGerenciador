import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uni_gerenciador/pages/edit_task.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/widgets/fab_widget.dart';
import 'package:uni_gerenciador/widgets/drawer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  // List<Task> tasks = <Task>[];
  List<Task> tasks = [];

  Future<void> getData() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref('tasks');
      // Query query = ref.orderByChild('date').orderByValue();
      DatabaseEvent snap = await ref.once();
      Map<String, dynamic> data = snap.snapshot.value as Map<String, dynamic>;
      data.forEach((key, value) {
        tasks.add(Task.fromJSON(value, key));
      });
      tasks.sort((a, b) => a.date.compareTo(b.date));
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Página inicial'),
        // actions: [],
      ),
      drawer: const DrawerMenu(),
      floatingActionButton: const FAB(),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
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
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: tasks
                              .map((task) => ListTile(
                                    title: Text(task.name),
                                    subtitle: Text(task.date.toString()),
                                    trailing: const Icon(Icons.task_alt),
                                    iconColor: (() {
                                      if (task.isDone!) {
                                        return Colors.black38;
                                      } else {
                                        if (task.date
                                            .isBefore(DateTime.now())) {
                                          return Colors.red;
                                        }
                                        return Colors.green;
                                      }
                                    }()),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTaskPage(task: task)));
                                    },
                                  ))
                              .toList(growable: false),
                        );
                    }
                  }),
            ),
            const Divider(),
            Text(
              "Gastos",
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.start,
            ),
            const Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 1,
            ),
          ],
        ),
      )),
    );
  }
}
