import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  const FAB({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FABState();
}

class FABState extends State<FAB> with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  late AnimationController _animationController;
  late Animation<double> _translateButton;
  final double _fabHeight = 56.0;
  final Curve _curve = Curves.easeOut;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!_isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    _isOpened = !_isOpened;
  }

  Widget task() {
    return FloatingActionButton(
      onPressed: () {
        animate();
        Navigator.of(context).pushNamed('/addtask');
      },
      tooltip: 'Adicionar tarefa',
      heroTag: "task",
      child: const Icon(Icons.add_task),
    );
  }

  Widget spending() {
    return FloatingActionButton(
      onPressed: () {
        animate();
        Navigator.of(context).pushNamed('/addspending');
      },
      tooltip: 'Adicionar despesa',
      heroTag: "spending",
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  Widget fabAnimated() {
    return FloatingActionButton(
      onPressed: animate,
      tooltip: "Adicionar evento",
      heroTag: "event",
      child: Icon(_isOpened ? Icons.close : Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Transform(
          transform:
              Matrix4.translationValues(0, _translateButton.value * 2, 0),
          child: task()),
      Transform(
          transform: Matrix4.translationValues(0, _translateButton.value, 0),
          child: spending()),
      fabAnimated()
    ], mainAxisAlignment: MainAxisAlignment.end);
  }
}
