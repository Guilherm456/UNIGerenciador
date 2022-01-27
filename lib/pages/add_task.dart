import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/widgets/datepicker_widget.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddTaskPageState();
  }
}

class AddTaskPageState extends State<AddTaskPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Task task = Task(date: DateTime.now(), name: '', description: '');
    final _form = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar tarefa')),
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Tarefa',
                        hintText: "Digite o nome da tarefa",
                        icon: Icon(Icons.add_task)),
                    onSaved: (val) => task.name = val!,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Digite o nome da tarefa';
                      }
                      return null;
                    },
                    // onSaved: (val) => task.name= val,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: "Descreva a tarefa",
                    ),
                    onSaved: (val) => task.description = val!,
                    maxLines: 6,
                    maxLength: 250,
                    keyboardType: TextInputType.multiline,
                  ),
                  const DatePicker(),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        _form.currentState!.save();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Adicionar tarefa'),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        ]),
      )),
    );
  }
}
