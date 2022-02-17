import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, this.initialValue, this.initialDay})
      : super(key: key);
  final DateTime? initialValue;
  final DateTime? initialDay;

  @override
  State<StatefulWidget> createState() {
    return DatePickerState();
  }
}

class DatePickerState extends State<DatePicker> {
  DateFormat formatador = DateFormat('dd/MM/yyyy');
  final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

  _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: widget.initialDay ?? selectedDate,
      lastDate: DateTime(DateTime.now().year + 50),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        _dateController.text = formatador.format(selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      selectedDate = widget.initialValue!;
      _dateController.text = formatador.format(selectedDate);
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
