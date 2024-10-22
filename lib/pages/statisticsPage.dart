import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        title: const Text('...'),
        elevation: 3,
        backgroundColor: Colors.white60,
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
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
                              title: Text('${MonthlyincomeExpeData[index]['month']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              subtitle: Text('Error: ${snapshot.error}'),
                            ),
                          );
                        } else {
                          var totalExp = snapshot.data.toString();
                          return Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Month: ${MonthlyincomeExpeData[index]['month']}, ${MonthlyincomeExpeData[index]['year']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 4
                                  ),
                                ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),
                                  Chip(
                                    avatar: const FaIcon(FontAwesomeIcons.circleArrowDown,color: Colors.green),
                                    label: Text(
                                      'Income: ${MonthlyincomeExpeData[index]['total_income']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Tillium',
                                          color: Colors.blueGrey
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Chip(
                                    avatar: const FaIcon(FontAwesomeIcons.circleArrowUp,color: Colors.red),
                                    label: Text('Expenses: $totalExp',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Tillium',
                                          color: Colors.pink
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),

                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => IncomeExpenditurePage(month:MonthlyincomeExpeData[index]['month'],year: MonthlyincomeExpeData[index]['year'],)),
                                  );
                                }, child: const Text('View'),
                              ),
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
