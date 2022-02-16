import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, this.initialValue}) : super(key: key);
  final DateTime? initialValue;

  @override
  State<StatefulWidget> createState() {
    return DatePickerState();
  }
}

class DatePickerState extends State<DatePicker> {
  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: widget.initialValue ?? selectedDate,
        firstDate: widget.initialValue ?? DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 50));

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
        _dateController.text = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectedDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: const InputDecoration(
            labelText: 'Data para conclusão',
            icon: Icon(Icons.calendar_today),
          ),
          controller: _dateController,
          keyboardType: TextInputType.datetime,
          validator: (val) {
            if (val != null && val.isEmpty) {
              return 'Digite a data de conclusão';
            }
            return null;
          },
        ),
      ),
    );
  }
}
