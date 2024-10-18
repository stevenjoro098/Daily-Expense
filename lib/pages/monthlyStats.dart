
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../utils/db.dart';
class monthlyStats extends StatefulWidget {
  final String month;
  final String year;
  const monthlyStats({super.key, required this.month, required this.year});

  @override
  State<monthlyStats> createState() => _monthLyStatsState();
}

class _monthLyStatsState extends State<monthlyStats> {
  Map<String, double> dataMap = {};
  List<dynamic> expenseData = [];
  Map<String, double> IncomedataMap = {};
  Map<String, double> mergedExpenseData = {};
  Map<String, double> mergedIncomeData = {};

  // Loop through the list and add each category as key and total_amount as value
  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];

  Future<void> getExpenseData () async {
    var Stringmonth = widget.month;
    var Stringyear = widget.year;
    int month = int.parse(Stringmonth);
    int year = int.parse(Stringyear);
    List data = await categorySum(month, year);
    //print(data);
    for (var item in data) {
      mergedExpenseData[item['category']] = item['total_amount'];
    }
    setState(() {
      dataMap = mergedExpenseData;
      expenseData = data;
    });
  }

  Future<List<Map<String, dynamic>>> getIncomeList() async{
    final results = await listMonthlyAllIncome(widget.month, widget.year);
    for (var item in results) {
      mergedIncomeData[item['income_description']] = item['income_amount'];
    }
    setState(() {
      IncomedataMap = mergedIncomeData;
    });
    //print(results);
    return results;
  }


  @override
  void initState(){
    super.initState();
    getExpenseData();
    getIncomeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Expenses:', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.grey),),
              dataMap.isNotEmpty
              ? Card(
                color: Colors.white,
                elevation: 4,
                shadowColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      PieChart(
                          dataMap: dataMap,
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.left,
                            legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: true,
                          decimalPlaces: 1,
                        ),
                        gradientList: gradientList,
                      ),
                      const SizedBox(height: 10,),
                      const Divider(
                        color: Colors.blueAccent,
                        thickness: 3,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                          itemCount: expenseData.length,
                          itemBuilder: (context, index){
                            return ListTile(
                              leading: Image.asset('assets/images/options.png', width: 30,),
                              title: Text('${ expenseData[index]['category'] }'),
                              trailing: Text('${ expenseData[index]['total_amount']}'),
                            );
                          }),
                    ],
                  ),
                ),
              )
              : const CircularProgressIndicator(),
              const Text('Income:', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Colors.grey),),
              IncomedataMap.isNotEmpty
              ? PieChart(
                dataMap: IncomedataMap,
                legendOptions: const LegendOptions(
                  legendPosition: LegendPosition.left,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
                gradientList: gradientList,
              )
              : const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
