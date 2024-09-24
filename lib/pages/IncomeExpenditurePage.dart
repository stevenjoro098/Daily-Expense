import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../utils/db.dart';
class IncomeExpenditurePage extends StatefulWidget {
  final String month;
  final String year;
  IncomeExpenditurePage({super.key, required this.month, required this.year});

  @override
  State<IncomeExpenditurePage> createState() => _IncomeExpenditurePageState();
}

class _IncomeExpenditurePageState extends State<IncomeExpenditurePage> {
  List<dynamic> incomeList = [];
  List<dynamic> ExpenseList = [];

  Future<void> getIncome() async {
    var results = await listMonthlyAllIncome(widget.month, widget.year);
    setState(() {
        incomeList = results;
    });

  }

  Future<void> getExpenses() async {
      var results = await AllExpenseList(widget.month, widget.year);
      setState(() {
        ExpenseList = results;
      });
  }

  @override
  void initState(){
      super.initState();
      getIncome();
      getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.bar_chart)
              ),
              IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.print)
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.arrow_downward_rounded,), text:'Income',),
                Tab(icon: Icon(Icons.upload_rounded), text:'Expenses'),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('${widget.month}-${ widget.year }'),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: incomeList.length,
                          itemBuilder: (context, index){
                          return Card(
                            elevation: 3,
                            color: Colors.grey[200],
                            child: ListTile(
                              leading: Image.asset('assets/images/money.png'),
                              title: Text('${ incomeList[index]['income_amount']}',
                                style: const TextStyle(
                                  fontFamily: 'Tillium',
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text("Description: ${ incomeList[index]['income_description']}"),
                              trailing: Text("${ incomeList[index]['income_date']}"),
                            )
                          );
                      })
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: ExpenseList.length,
                          itemBuilder: (context, index){
                            return Card(
                                elevation: 3,
                                color: Colors.orangeAccent[100],
                                child: ListTile(
                                  leading: Image.asset('assets/images/spending.png'),
                                  title: Text('${ ExpenseList[index]['expense_amount']}',
                                    style: const TextStyle(
                                        fontFamily: 'Tillium',
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  subtitle: Text("Description: ${ ExpenseList[index]['description']}"),
                                  trailing: Text("${ ExpenseList[index]['expense_date']}"),
                                )
                            );
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
