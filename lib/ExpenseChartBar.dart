import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'db.dart';

class ExpenseBarChart extends StatefulWidget {
  final int month; // Parameter to pass
  final int year;    // Another parameter

  const ExpenseBarChart({Key? key, required this.month, required this.year}) : super(key: key);

  @override
  _ExpenseBarChartState createState() => _ExpenseBarChartState();
}

class _ExpenseBarChartState extends State<ExpenseBarChart> {
  late List<charts.Series<dynamic, String>> _seriesList=[];

  @override
  void initState() {
    super.initState();
    fetchDataAndSetState();
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
    List data = await categorySum(widget.month, widget.year);
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
    return SizedBox(
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
    );
  }
}
