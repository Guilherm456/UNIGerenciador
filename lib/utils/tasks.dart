class Task {
  String name;
  String? description;
  DateTime date;
  bool? isDone;
  String? id;

  Task(
      {required this.name,
      this.description = '',
      required this.date,
      this.isDone = false,
      this.id});

  factory Task.fromJSON(dynamic data, String id) {
    return Task(
      name: data['name'],
      description: data['description'],
      date: DateTime.parse(data['date']),
      isDone: data['isDone'],
      id: id,
    );
  }

  Object toJSon() {
    return {
      'name': name,
      'description': description,
      'date': date.toIso8601String(),
      'isDone': isDone
    };
  }
}
