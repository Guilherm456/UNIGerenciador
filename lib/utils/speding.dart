class Spending {
  String? id;
  DateTime date;
  bool isIncome;
  String? name;
  double value;

  Spending({
    this.id,
    required this.date,
    required this.isIncome,
    this.name,
    required this.value,
  });

  factory Spending.fromJSON(dynamic data, String id) {
    return Spending(
      id: id,
      date: DateTime.parse(data['date']),
      isIncome: data['isIncome'],
      name: data['name'],
      value: double.parse(data['value']),
    );
  }

  Object toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'isIncome': isIncome,
      'name': name,
      'value': value.toString(),
    };
  }
}
