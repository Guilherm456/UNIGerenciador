import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:uni_gerenciador/utils/database.dart';
import 'package:uni_gerenciador/utils/speding.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  ExpensesPageState createState() => ExpensesPageState();
}

class ExpensesPageState extends State<ExpensesPage> {
  List<Spending> spendings = [];
  DateFormat formatador = DateFormat('dd/MM/yyyy');
  NumberFormat formatMoney = NumberFormat('#,##0.00', 'pt_BR');

  Future<void> getExpenses() async {
    if (spendings.isNotEmpty) return;
    try {
      DataBase().getExpenses(DateTime.now()).then((list) {
        if (list == null) return;
        spendings = list;
        spendings.sort((a, b) => b.date.compareTo(a.date));
      });
    } catch (e) {
      // print(e);
    }
  }

  Widget chart() {
    List<SpendingCharts> transform(List<Spending> spendings) {
      List<SpendingCharts> spendingCharts = [];
      for (var spending in spendings) {
        for (int i = 0; i < spendingCharts.length; i++) {
          if (spendingCharts[i].day == spending.date.day) {
            spendingCharts[i].value += spending.value.toInt();
            break;
          }
        }
        spendingCharts
            .add(SpendingCharts(spending.date.day, spending.value.toInt()));
        continue;
      }

      return spendingCharts;
    }

    List<SpendingCharts> spendingCharts = transform(
        spendings.where((spending) => spending.isIncome == false).toList());
    List<SpendingCharts> incomeCharts = transform(
        spendings.where((spending) => spending.isIncome == true).toList());

    var series = [
      charts.Series(
        id: "Spendings",
        data: spendingCharts,
        domainFn: (SpendingCharts spending, _) => spending.day,
        measureFn: (SpendingCharts spending, _) => spending.value,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
      charts.Series(
        id: "Income",
        data: incomeCharts,
        domainFn: (SpendingCharts spending, _) => spending.day,
        measureFn: (SpendingCharts spending, _) => spending.value,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      ),
    ];
    return charts.LineChart(
      List.from(series),
      animate: true,
      defaultRenderer:
          charts.LineRendererConfig(includePoints: true, includeLine: true),
    );
  }

  Widget spendingList() {
    return ListView(
      shrinkWrap: true,
      children: spendings
          .map((spending) => ListTile(
                title: Text(spending.name ?? "Sem nome"),
                subtitle: Text(formatador.format(spending.date) +
                    "\nR\$ ${formatMoney.format(spending.value)}"),
                trailing: Icon(
                  Icons.monetization_on,
                  color: spending.isIncome ? Colors.green : Colors.red,
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                spendings.clear();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
              future: getExpenses(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }

                return Column(
                  children: [
                    Text('Gastos do mês',
                        style: Theme.of(context).textTheme.subtitle1),
                    SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: spendings.isNotEmpty
                            ? chart()
                            : Center(
                                child: Text('Nenhuma atividade',
                                    style:
                                        Theme.of(context).textTheme.labelLarge),
                              )),
                    const Divider(),
                    Text('Despesas em lista',
                        style: Theme.of(context).textTheme.subtitle1),
                    Expanded(child: spendingList()),
                  ],
                );
              }),
        ),
      )),
    );
  }
}

class SpendingCharts {
  int day;
  int value;

  SpendingCharts(this.day, this.value);
}
