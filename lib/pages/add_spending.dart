import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_gerenciador/widgets/datepicker_widget.dart';

class AddSpendingPage extends StatefulWidget {
  const AddSpendingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddSpendingState();
  }
}

enum TypeSpending { gasto, ganho }

class AddSpendingState extends State<AddSpendingPage> {
  final _form = GlobalKey<FormState>();
  TypeSpending _type = TypeSpending.gasto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controlar gastos')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: Column(
              children: [
                const Text(
                  'Seria gasto ou ganho?',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    RadioListTile(
                        title: const Text('Gasto'),
                        value: TypeSpending.gasto,
                        groupValue: _type,
                        onChanged: (TypeSpending? value) {
                          if (value != null) {
                            setState(() {
                              _type = value;
                            });
                          }
                        }),
                    RadioListTile(
                        title: const Text('Ganho'),
                        value: TypeSpending.ganho,
                        groupValue: _type,
                        onChanged: (TypeSpending? value) {
                          if (value != null) {
                            setState(() {
                              _type = value;
                            });
                          }
                        }),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome do ${_type.name}',
                    icon: const Icon(Icons.sticky_note_2),
                  ),
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Valor do ${_type.name}',
                    icon: const Icon(Icons.monetization_on),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (String? value) {
                    if (value != null && value.isEmpty) {
                      return 'Valor é obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                DatePicker(
                  initialDay: DateTime.now().subtract(const Duration(days: 30)),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                    onPressed: () {
                      if (_form.currentState!.validate()) {
                        _form.currentState!.save();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Salvar')),
              ],
            )),
      )),
    );
  }
}
