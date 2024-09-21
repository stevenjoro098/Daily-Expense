
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/ExpenseChartBar.dart';
import '../utils/db.dart';
import '../widgets/calendar.dart';
import 'AddExpenditurePage.dart';
import '../utils/_helperFn.dart';
import 'IncomePage.dart';
import 'Profile.dart';
import 'package:daily_expenses/widgets/HomeAppBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String firstName = "";
  String selectedValue = '';
  int selectedMonth = 0;
  String month = "";
  String monthlyIncomeTotal = "";
  String monthlyBalance = "";
  String currency = "";
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
    setState(() {
      month = currentMonthName;
    });
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
  void getIncomeTotal(int month, int year){
    double bal = 0.0;
    totalMonthIncome(month.toString(),year.toString()).then((value){
      bal = value - monthlyTotal;
      setState(() {
        monthlyIncomeTotal = value.toString();
        monthlyBalance = bal.toString();
      });
    });
  }
  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'John';
      currency = prefs.getString('currency') ?? 'Usd';
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
    getIncomeTotal(now.month, now.year);
    loadProfileData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/statistics.png', width: 40,),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon:Icon(Icons.account_circle_outlined)
          ),
          IconButton(onPressed: (){},
              icon:Icon(Icons.notifications)
          )
        ],
      ),
      drawer: Drawer(
          child: ListView(
            children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    ),
                  child: Image.asset('assets/images/pie-chart.png', width: 200,)
                ),
              ListTile(
                title: const Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Profile()),);

                },
              ),
              ListTile(
                title: const Text('Statistics'),
                leading: Icon(Icons.bar_chart),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: () {
                },
              ),
              ListTile(
                title: const Text('Sign Out'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                },
              ),
            ],
          )// Populate the Drawer in the last step.
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               Row(
                children: [
                  Text('Hello, $firstName.',
                    style: const TextStyle(
                      fontFamily: 'DancingScript',
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text("Date: ${now.day}-${now.month}-${now.year}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,

                  ),
                  ),
                ],
              ),
              //Divider(),
              Card(
                color: Colors.blue[100],
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      const Text('Balance',
                        style: TextStyle(
                            fontFamily: 'Tillium',
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                        ),
                      ),
                      Text('$currency.$monthlyBalance ',
                        style: const TextStyle(
                          fontFamily: 'Tillium',
                          fontSize: 27
                         ),
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.expand_circle_down_rounded, color: Colors.green,),
                              const SizedBox(width: 5,),
                              Text('$currency. $monthlyIncomeTotal',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Tillium',
                                      fontSize: 17
                                  ),
                                ),
                            ],
                          ),
                            //leading: Icon(Icons.arrow_drop_down),
                          Row(
                            children: [
                              const Icon(Icons.upload, color: Colors.redAccent),
                              const SizedBox(width: 5,),
                              Text('$currency. $monthlyTotal',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Tillium',
                                    fontSize: 17
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                    ]

                  ),
                ),
              ),
              SizedBox(height: 4,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoSegmentedControl<int>(
                    padding: const EdgeInsets.all(8),  // Add padding for better appearance
                    borderColor: Colors.black54,    // Customize the border color
                    pressedColor: Colors.blue.shade100, // Color when a segment is pressed
                    selectedColor: Colors.black,  // Color for the selected segment
                    unselectedColor: Colors.teal[100], // Background color for unselected segments
                    children: const {
                      0: Padding(
                          padding: const EdgeInsets.all(8),
                        child:Text(
                            'Expenses',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent
                          ),
                        ) ,
                      ),
                      1: Text(
                          'Income',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                      ),
                    },
                    onValueChanged: (int value) {
                      if(value == 0){
                        setState(() {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const CalendarPage()),);
                        });
                      } else {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const IncomePage()),);
                      }
        
                    },
                    //groupValue: segmentedValue,
                  ),
                  SizedBox(
                    height: 40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1), // Background color
                        borderRadius: BorderRadius.circular(10),   // Rounded corners
                        border: Border.all(color: Colors.blueAccent, width: 2), // Border styling
                      ),
                      child:DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedValue,
                          focusColor: Colors.transparent,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.blueAccent, size: 24), // Custom arrow icon
                          dropdownColor: Colors.blue[50], // Dropdown background color
                          style: TextStyle(
                            color: Colors.blueAccent, // Text color in the dropdown
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          onChanged: (newValue){
                            setState(() {
                              selectedValue = newValue!;
                              selectedMonth = _getMonthNumber(selectedValue);
                            });
                            //print("Month Code:${ selectedMonth}");
                            categorySum(selectedMonth, now.year);
                            getIncomeTotal(selectedMonth, now.year);
                            getMonthlyTotal(selectedMonth);

                          },
                          items: <String>['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5,),
              Center(
                  child:ExpenseBarChart(MonthIndex: selectedMonth, year: now.year)
                  ),
              const Divider(),
              Card(
                elevation: 3,
                child: ListTile(
                  leading: const Text("Today's Expenditure:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                    ),
                  ),
                  trailing: Text('$currency. $dailyTotal',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              myData.isEmpty ?
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Image.asset('assets/images/spend.png', width: 120,),
        
                      const Text(
                          'No Spending Today!!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      // Image.asset(
                      //   'assets/images/empty_list.gif',
                      //   width: 250, // Adjust width as needed
                      //   height: 250, // Adjust height as needed
                      // ),
                    ]
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
                        '$currency. ${myData[index]['expense_amount']}',
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
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      //leading: Icon(Icons.description),
                                      title: Text(myData[index]['description']),
                                      subtitle:Text('${myData[index]['expense_date']}'),
                                      trailing: Text('Ksh. ${myData[index]['expense_amount']}'),
                                    )
                                  ],
                                ),
                              );
                            }
                        );
                      },
                    );
                  }
              ),
            ],
          ),
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