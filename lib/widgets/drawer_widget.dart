import 'package:flutter/material.dart';

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
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
              // color: Theme.of(context).colorScheme.onPrimary,
              ),
          child: Text('Menu'),
        ),
        ListTile(
          title: const Text('Tarefas'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Gastos'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }
}