import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:uni_gerenciador/utils/notification.dart';
import 'package:uni_gerenciador/utils/speding.dart';
import 'package:uni_gerenciador/utils/tasks.dart';
import 'package:uni_gerenciador/utils/user_connect.dart';

class DataBase {
  FirebaseDatabase database = FirebaseDatabase.instance;
  DataBase() {
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }

  Future<DatabaseReference> getRef() async {
    String? user = await UserConnect().actualUser();
    DatabaseReference ref = database.ref(user);

    ref.keepSynced(true);
    return ref;
  }

  //Tarefas
  Future<List<Task>?> getTasks() async {
    List<Task> tasks = [];

    DatabaseReference ref = await getRef();
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
    try {
      DatabaseReference ref = await getRef();

      DatabaseReference refTask = ref.child('tasks');
      return await refTask.push().set(task.toJSon());
    } catch (e) {
      return;
    }
  }

  Future<void> updateTask(Task task) async {
    DatabaseReference ref = await getRef();

    NotificationService().changeANotification(task);

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
    try {
      DatabaseReference ref = await getRef();

      DatabaseReference refTask = ref.child('tasks');
      return await refTask.child(id!).update({
        attribute: value,
      });
    } catch (e) {
      return;
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      DatabaseReference ref = await getRef();
      DatabaseReference refTask = ref.child('tasks');

      NotificationService().cancelNotifications(id);

      return await refTask.child(id).remove();
    } catch (e) {
      return;
    }
  }

  //Gastos
  Future<List<Spending>?> getExpenses(DateTime date) async {
    List<Spending> expenses = [];

    DatabaseReference ref = await getRef();
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
    try {
      DatabaseReference ref = await getRef();

      DatabaseReference refSpending = ref
          .child('spending')
          .child('${expense.date.year}')
          .child('${expense.date.month}');
      return await refSpending.push().set(expense.toJson());
    } catch (e) {
      return;
    }
  }

  Future<String> getName() async {
    try {
      DatabaseReference ref = await getRef();
      DatabaseReference refName = ref.child('name');
      DatabaseEvent snap = await refName.once();
      String name = (snap.snapshot.value as String);
      name = name.split(' ')[0];
      return name;
    } catch (e) {
      return "Usuário";
    }
  }
}
