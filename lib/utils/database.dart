import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:uni_gerenciador/utils/speding.dart';
import 'package:uni_gerenciador/utils/tasks.dart';

class DataBase {
  static final DatabaseReference ref = FirebaseDatabase.instance.ref();
  final Future<void> keep = ref.keepSynced(true);

  //Tarefas
  Future<List<Task>?> getTasks() async {
    List<Task> tasks = [];
    DatabaseReference refTask = ref.child('tasks');

    DatabaseEvent snap = await refTask.once();

    if (snap.snapshot.value == null) return null;
    Map<String, dynamic> data = jsonDecode(jsonEncode(snap.snapshot.value));

    data.forEach((key, value) {
      tasks.add(Task.fromJSON(value, key));
    });
    return tasks;
  }

  Future<void> addTask(Task task) async {
    DatabaseReference refTask = ref.child('tasks');
    return await refTask.push().set(task.toJSon());
  }

  Future<void> updateTask(Task task) async {
    DatabaseReference refTask = ref.child('tasks');
    return await refTask.child(task.id!).update({
      'name': task.name,
      'description': task.description,
      'date': task.date.toIso8601String(),
      'isDone': task.isDone,
    });
  }

  Future<void> editAttribute(
      String? id, String attribute, dynamic value) async {
    DatabaseReference refTask = ref.child('tasks');
    return await refTask.child(id!).update({
      attribute: value,
    });
  }

  Future<void> deleteTask(String id) async {
    DatabaseReference refTask = ref.child('tasks');
    return await refTask.child(id).remove();
  }

  //Gastos
  Future<List<Spending>?> getExpenses(DateTime date) async {
    List<Spending> expenses = [];
    DatabaseReference refSpending =
        ref.child('spending').child('${date.year}').child("${date.month}");
    DatabaseEvent snap = await refSpending.once();

    if (snap.snapshot.value == null) return null;
    Map<String, dynamic> data = jsonDecode(jsonEncode(snap.snapshot.value));

    data.forEach((key, value) {
      expenses.add(Spending.fromJSON(value, key));
    });
    return expenses;
  }

  Future<void> addExpense(Spending expense) async {
    DatabaseReference refSpending = ref
        .child('spending')
        .child('${expense.date.year}')
        .child('${expense.date.month}');
    return await refSpending.push().set(expense.toJson());
  }
}
