import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'add_expenditure.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';

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

  @override
  void initState(){
    super.initState();
    fetchExpenseData();
    getTodayTotal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu),
                  Text('Ksh. 3000.00',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                  ),
                  Icon(Icons.notifications)
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
                    // setState(() {
                    //   segmentedValue = value;
                    // });
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
            ExpenseBarChart(),
              Card(
              child: Column(
                children: [
                  ListTile(
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
                  )
                ],
              ),
            ),
             Expanded(
                child: ListView.builder(
                    itemCount: myData.length,
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
                                         Text('Amount. Ksh ${myData[index]['expense_amount']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 15
                                          ),),
                                         Text('${myData[index]['expense_date']}'),
                                         Text('${myData[index]['description']}'),

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
  late List<charts.Series<Expense, String>> seriesList;

  @override
  void initState() {
    super.initState();
    seriesList = _createSampleData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180, // Adjust height as needed
      child: charts.BarChart(
        seriesList,
        animate: true,
        //vertical: false,
        barRendererDecorator: charts.BarLabelDecorator<String>(),
        domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
        ),
      ),
    );
  }

  List<charts.Series<Expense, String>> _createSampleData() {
    final data = [
      Expense('Food', 500),
      Expense('Transportation', 300),
      Expense('Utilities', 450),
      Expense('Entertainment', 200),
      // Add more items with their respective expenditures
    ];

    return [
      charts.Series<Expense, String>(
        id: 'Expenses',
        domainFn: (Expense expense, _) => expense.item,
        measureFn: (Expense expense, _) => expense.amount,
        data: data,
        colorFn: (_, index) => charts.ColorUtil.fromDartColor(
          _getColor(index!),
        ),
        labelAccessorFn: (Expense expense, _) => 'Ksh.${expense.amount.toString()}',
      ),
    ];
  }

  Color _getColor(int index) {
    List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      // Add more colors if needed
    ];
    return colors[index % colors.length];
  }
}
