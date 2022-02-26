import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/user_connect.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrawerMenuState();
  }
}

class DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // const DrawerHeader(
          //   decoration: BoxDecoration(
          //       // color: Theme.of(context).colorScheme.onPrimary,
          //       ),
          //   child: Text('Menu'),
          // ),
          ListTile(
            title: const Text("Página inicial"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popAndPushNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Tarefas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popAndPushNamed('/tasks');
            },
          ),
          ListTile(
            title: const Text('Gastos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).popAndPushNamed('/expenses');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Sair da conta',
                style: TextStyle(color: Colors.black54)),
            trailing: const Icon(Icons.logout),
            onTap: () {
              Navigator.pop(context);
              UserConnect().disconnect();
              Navigator.of(context).popAndPushNamed('/login');
            },
          ),
        ],
      )),
    );
  }
}
