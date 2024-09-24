import 'package:flutter/material.dart';

import '../utils/db.dart';
import 'IncomeExpenditurePage.dart';
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<dynamic> MonthlyincomeExpeData = [];
  Future<void> getIncomeExpenditure() async {
      List results = await groupIncome();
      setState(() {
        MonthlyincomeExpeData = results;
      });

  }
  @override
  void initState(){
    super.initState();
    getIncomeExpenditure();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: MonthlyincomeExpeData.length,
                  itemBuilder: (context, index) {
                    var year = MonthlyincomeExpeData[index]['year'];
                    var month = MonthlyincomeExpeData[index]['month'];
                    var int_year = int.parse(year);
                    var int_month = int.parse(month);
                    return FutureBuilder(
                      future: totalMonthlyExpenditure(int_month, int_year),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Card(
                            child: ListTile(
                              title: Text('${MonthlyincomeExpeData[index]['month']}'),
                              subtitle: const Text('Loading...'),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Card(
                            child: ListTile(
                              title: Text('${MonthlyincomeExpeData[index]['month']}'),
                              subtitle: Text('Error: ${snapshot.error}'),
                            ),
                          );
                        } else {
                          var totalExp = snapshot.data.toString();
                          return Card(
                            elevation: 3,
                              color: Colors.blueAccent[100],
                            child: ListTile(
                              title: Text('${MonthlyincomeExpeData[index]['month']}, ${MonthlyincomeExpeData[index]['year']}'),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Income:${MonthlyincomeExpeData[index]['total_income']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: 'Tillium',
                                      color: Colors.greenAccent
                                    ),
                                  ),
                                  Text('Expenses: $totalExp',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        fontFamily: 'Tillium',
                                      color: Colors.redAccent
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => IncomeExpenditurePage(month:MonthlyincomeExpeData[index]['month'],year: MonthlyincomeExpeData[index]['year'],)),
                                  );
                                },
                                icon:const Icon(Icons.keyboard_double_arrow_right, color: Colors.red,),
                              )
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              )
            ],
          ),
      ),
    );
  }
}
