import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'add_expenditure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';
import 'calendar.dart';

void main()  async {
  sqfliteFfiInit(); // Initialize sqflite_common_ffi
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class Expense {
  final String item;
  final double amount;

  Expense(this.item, this.amount);
}

class MyApp extends StatelessWidget {
   // Initial value
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedValue = 'Jan';

  List<Map<String, dynamic>> myData = [];
  double dailyTotal = 0.0;
  double monthlyTotal = 0.0;
  DateTime now = DateTime.now();

  DateTime getTodaysDate() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }


  Future<void> fetchExpenseData() async {
    List<Map<String, dynamic>> data = await expenseList('${now.year}-${now.month}-${now.day}');
    //var d = totalAmount = (await totalDayAmount('2023-12-17')) as Double;
    setState(() {
      myData = data;
    });
  }


  void getTodayTotal(){
      totalDayAmount('${now.year}-${now.month}-${now.day}').then((value){
        setState(() {
          dailyTotal = value as double;
        });
      });
  }

  void getMonthlyTotal(){
    totalMonthlyExpenditure(12).then((value){
      setState(() {
        monthlyTotal = value;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    fetchExpenseData();
    getTodayTotal();
    getMonthlyTotal();
    categorySum();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.menu),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('This Month Expenditure',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold

                      ),),
                      Text('KSh. $monthlyTotal',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CupertinoSegmentedControl<int>(
                  children: const {
                    0: Text('Expenses'),
                    1: Text('Income'),
                  },
                  onValueChanged: (int value) {
                    setState(() {
                      Navigator.push(context,
                         MaterialPageRoute(builder: (context) => const CalendarPage()),);
                    });
                  },
                  //groupValue: segmentedValue,
                ),
                DropdownButton<String>(
                  value: selectedValue,
                  onChanged: (newValue){
                    // setState(() {
                    //   selectedValue = 'newValue';
                    // });
                  },
                  items: <String>['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(height: 5,),
            Center(child: ExpenseBarChart()),
              Card(
              child: ListTile(
                leading: const Text('Todays Expenditure:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                trailing: Text('Ksh. ${dailyTotal}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),),
              ),
                          ),

             Expanded(
                child: myData.isEmpty ?
                Container(
                  child: Center(
                    // Show GIF when the list is empty
                    child: Image.asset(
                      'assets/images/empty_list.gif',
                      width: 300, // Adjust width as needed
                      height: 300, // Adjust height as needed
                    ),
                  ),
                )
                :ListView.builder(
                    itemCount: myData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return ListTile(
                        leading: Image.asset('assets/images/spending.png'),
                        title: Text('${myData[index]['category']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                        trailing: Text(
                            'Ksh. ${myData[index]['expense_amount']}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                 return AlertDialog(
                                   title: Text('${myData[index]['category']}.',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal
                                                ),),
                                   content: Container(
                                     child: Column(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         ListTile(
                                           leading: Icon(Icons.description),
                                           title: Text(myData[index]['description']),
                                           subtitle:Text('${myData[index]['expense_date']}'),
                                           trailing: Text('Ksh. ${myData[index]['expense_amount']}'),
                                         )
                                       ],
                                     ),
                                   ),
                                 );
                              }
                          );
                        },
                      );
                    }
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const addExpensesPage()),);
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    ) ;
  }
}

class ExpenseBarChart extends StatefulWidget {
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
    charts.MaterialPalette.yellow.shadeDefault
  ];
  Future<void> fetchDataAndSetState() async {
    List data = await categorySum();
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

  // Color _getColor(int index) {
  //   List<Color> colors = [
  //     Colors.blue,
  //     Colors.green,
  //     Colors.orange,
  //     Colors.red,
  //     // Add more colors if needed
  //   ];
  //   return colors[index % colors.length];
  // }

