import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'ExpenseChartBar.dart';
import 'db.dart';
import 'calendar.dart';
import 'add_expenditure.dart';
import '_helperFn.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedValue = '';
  int selectedMonth = 0;

  List<Map<String, dynamic>> myData = [];
  double dailyTotal = 0.0;
  double monthlyTotal = 0.0;
  DateTime now = DateTime.now();

  DateTime getTodaysDate() {
    DateTime now = DateTime.now();
    setState(() {
      selectedMonth = now.month;
    });
    return DateTime(now.year, now.month, now.day);
  }

  void getCurrentMonth(){
    // get the current month and update the dropdown menu.
    DateTime now = DateTime.now();
    int currentMonth = now.month; // This returns the current month as an integer (1 = January, 12 = December)

    List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    String currentMonthName = months[now.month - 1]; // Subtract 1 because the index starts from 0
    selectedValue = currentMonthName;
  }

  Future<void> fetchExpenseData() async {
    // fetch a list of dates expenses.
    List<Map<String, dynamic>> data = await expenseList('${now.year}-${now.month}-${now.day}');
    //var d = totalAmount = (await totalDayAmount('2023-12-17')) as Double;
    //print('Todays Data $data');
    setState(() {
      myData = data; // put data into myData.
    });
  }

  int _getMonthNumber(String monthName) {
    const monthMap = {
      'Jan': 1,
      'Feb': 2,
      'Mar': 3,
      'Apr': 4,
      'May': 5,
      'Jun': 6,
      'Jul': 7,
      'Aug': 8,
      'Sep': 9,
      'Oct': 10,
      'Nov': 11,
      'Dec': 12,
    };
    return monthMap[monthName] ?? DateTime.now().month; // Default to current month
  }

  void getTodayTotal(){
    // get sum of days expenses.
    totalDayAmount('${now.year}-${now.month}-${now.day}').then((value){
      setState(() {
        dailyTotal = value;
      });
    });
  }

  void getMonthlyTotal(int month){
    // get total for month
    totalMonthlyExpenditure(month, now.year).then((value){
      setState(() {
        monthlyTotal = value;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    getTodaysDate();
    getCurrentMonth();
    fetchExpenseData();
    getTodayTotal();
    getMonthlyTotal(now.month);
    //categorySum(now.month, now.year);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
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
                      const Text('This Month Expenditure',
                        style: TextStyle(
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
                    setState(() {
                      selectedValue = newValue!;
                      selectedMonth = _getMonthNumber(selectedValue);
                    });
                    //print("Month Code:${ selectedMonth}");
                    categorySum(selectedMonth, now.year);

                    getMonthlyTotal(selectedMonth);

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
            const SizedBox(height: 5,),
            Center(
                child:ExpenseBarChart(month: selectedMonth, year: now.year)
                ),
            Card(
              child: ListTile(
                leading: const Text("Today's Expenditure:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),),
                trailing: Text('Ksh. ${dailyTotal}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
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