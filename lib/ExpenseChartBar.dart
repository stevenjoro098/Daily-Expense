import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'db.dart';

class ExpenseBarChart extends StatefulWidget {
  final int MonthIndex; // Parameter to pass
  final int year;    // Another parameter

  const  ExpenseBarChart({Key? key, required this.MonthIndex, required this.year}) : super(key: key);

  @override
  _ExpenseBarChartState createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  late List<charts.Series<dynamic, String>> _seriesList=[];

  Object _getMonthNumber(int monthName) {
    const monthMap = {
       1: "JANUARY",
       2:'FEBRUARY',
       3:'MARCH',
       4:'APRIL',
       5:'MAY',
       6:'JUNE',
       7:'JULY',
       8:'AUGUST',
       9:'SEPTEMBER',
      10:'OCTOBER',
      11:'NOVEMBER',
      12:'DECEMBER',
    };
    return monthMap[monthName] ?? DateTime.now().month; // Default to current month
  }

  @override
  void initState() {
    super.initState();
    fetchDataAndSetState();
  }

  @override
  void didUpdateWidget(covariant ExpenseBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if month or year has changed
    if (oldWidget.MonthIndex != widget.MonthIndex || oldWidget.year != widget.year) {
      fetchDataAndSetState();
    }
  }
  List<charts.Color> colorsList = [
    charts.MaterialPalette.blue.shadeDefault,
    charts.MaterialPalette.red.shadeDefault,
    charts.MaterialPalette.green.shadeDefault,
    charts.MaterialPalette.pink.shadeDefault,
    charts.MaterialPalette.yellow.shadeDefault,
    charts.MaterialPalette.teal.shadeDefault,
    charts.MaterialPalette.purple.shadeDefault
  ];
  Future<void> fetchDataAndSetState() async {
    List data = await categorySum(widget.MonthIndex, widget.year);
    List<charts.Series<dynamic, String>> series = [
      charts.Series(
        id: 'Category Total',
        data: data,
        domainFn: (dynamic datum, _) => datum['category'] as String,
        measureFn: (dynamic datum, _) => datum['total_amount'] as num,
        colorFn: (dynamic datum, _){
          int categoryIndex = data.indexWhere((element) => element['category'] == datum['category']);
          return colorsList[categoryIndex % colorsList.length];
        },
        labelAccessorFn: (dynamic datum, _) => '${datum['total_amount']}',
      ),
    ];
    setState(() {
      _seriesList = series;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('${ _getMonthNumber(widget.MonthIndex)} Expense Chart Bar',
              style: TextStyle(
                letterSpacing: 2.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              height: 200, // Adjust height as needed
              child: charts.BarChart(
                _seriesList,
                animate: true,
                vertical: true,
                barRendererDecorator: charts.BarLabelDecorator<String>(),
                // domainAxis: const charts.OrdinalAxisSpec(
                //   renderSpec: charts.NoneRenderSpec(),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
