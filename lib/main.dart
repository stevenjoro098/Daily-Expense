import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'add_expenditure.dart';

void main() {
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
      home: HomePage(),
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
                  children: {
                    0: const Text('Expenses'),
                    1: const Text('Income'),
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
            const Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Text('Todays Expenditure:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      ),),
                    trailing: Text('Ksh. 500',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),),
                  )
                ],
              ),
            ),
            const Expanded(
                child:Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.local_pizza),
                      title: Text('Pizza'),
                      trailing: Text('Ksh. 200'),
                      subtitle: Text('cash'),
                    ),
                    ListTile(
                      leading: Icon(Icons.local_pizza),
                      title: Text('Pizza'),
                      trailing: Text('Ksh. 200'),
                      subtitle: Text('cash'),
                    ),
                    ListTile(
                      leading: Icon(Icons.local_pizza),
                      title: Text('Pizza'),
                      trailing: Text('Ksh. 200'),
                      subtitle: Text('cash'),
                    ),

                  ],
                )
            ),
            ElevatedButton(
                onPressed:(){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const addExpensesPage(),));
                },
                child: const Text('data')
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const addExpensesPage()),);
          print('key pressed');
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
      height: 200, // Adjust height as needed
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
        labelAccessorFn: (Expense expense, _) => '\$${expense.amount.toString()}',
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
