import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/database.dart';
import 'package:uni_gerenciador/utils/notification.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/widgets/datepicker_widget.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddTaskPageState();
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
        child: Padding(
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
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  enableSuggestions: true,
                  autofocus: true,
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
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                DatePicker(onSaved: (val) => task.date = val),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      _form.currentState!.save();
                      DataBase().addTask(task).then((val) {
                        NotificationService().scheduleNotifications(task);
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        const snackBar = SnackBar(
                          content: Text('Erro ao adicionar tarefa'),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    }
                  },
                  child: const Text('Adicionar tarefa'),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
