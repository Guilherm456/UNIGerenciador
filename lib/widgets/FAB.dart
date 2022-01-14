import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  const FAB({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FABState();
}

class FABState extends State<FAB> {
  bool _isOpened = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _isOpened = !_isOpened;
        Navigator.of(context).pushNamed('/addtask');
      },
      child: const Icon(Icons.add),
    );
  }
}
