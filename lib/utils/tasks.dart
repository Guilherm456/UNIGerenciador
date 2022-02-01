class Task {
  String name;
  String description;
  DateTime date;
  bool? isDone;

  Task(
      {required this.name,
      this.description = '',
      required this.date,
      this.isDone = false});
}
