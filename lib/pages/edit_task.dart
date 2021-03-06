import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/database.dart';
import 'package:uni_gerenciador/utils/notification.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/widgets/datepicker_widget.dart';

class EditTaskPage extends StatefulWidget {
  const EditTaskPage({Key? key, required this.task}) : super(key: key);
  final Task task;

  @override
  State<StatefulWidget> createState() => EditTaskPageState();
}

class EditTaskPageState extends State<EditTaskPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Task task = widget.task;

    final _form = GlobalKey<FormState>();

    Future<void> deleteData() async {
      try {
        await DataBase().deleteTask(task.id!);
      } catch (e) {
        // print(e);
      }
      Navigator.of(context).pop();
    }

    Future<void> updateData() async {
      try {
        await DataBase().updateTask(task);
        NotificationService().changeANotification(task);
      } catch (e) {
        // print(e);
      }
      Navigator.of(context).pop();
    }

    Future<void> markDone() async {
      if (task.isDone == true) {
        const snackBar = SnackBar(content: Text('Tarefa já está concluída!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      try {
        await DataBase().editAttribute(task.id, 'isDone', true);
      } catch (e) {
        // print(e);
      }
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarefa ${task.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Excluir Tarefa'),
                    content: const Text('Deseja realmente excluir a tarefa?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Excluir'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteData();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // color: Theme.of(context).primaryColor,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            TextButton.icon(
              onPressed: markDone,
              icon: const Icon(Icons.done),
              label: const Text('Marcar como concluído'),
            ),
          ]),
        ),
      ),
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
                  autocorrect: true,
                  enableSuggestions: true,
                  initialValue: task.name,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: "Descreva a tarefa",
                  ),
                  onSaved: (val) => task.description = val!,
                  initialValue: task.description,
                  maxLines: 6,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.next,
                  autocorrect: true,
                  enableSuggestions: true,
                ),
                DatePicker(
                    initialValue: task.date, onSaved: (val) => task.date = val),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_form.currentState!.validate()) {
                      _form.currentState!.save();
                      updateData();
                    }
                  },
                  child: const Text('Editar tarefa'),
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
