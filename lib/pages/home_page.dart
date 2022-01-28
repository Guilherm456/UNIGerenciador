import 'package:flutter/material.dart';
import 'package:uni_gerenciador/widgets/fab.dart';
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
              child: Scrollbar(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: const [
                    ListTile(
                      // leading: ExcludeSemantics(
                      //     child: CircleAvatar(
                      //   backgroundColor: Colors.grey,
                      // )),
                      title: Text('Tarefa 1'),
                      subtitle: Text(
                        '24/12/2021',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: Icon(Icons.task_alt),
                    ),
                  ],
                ),
              ),
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
