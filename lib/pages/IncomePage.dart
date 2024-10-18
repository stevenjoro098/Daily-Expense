import 'package:flutter/material.dart';

import '../widgets/AddIncomeDialog.dart';
import '../pages/IncomeMonthlyList.dart';
import '../utils/db.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key});

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  List<Map<String, dynamic>> incomeData = [];

  Future<void> getIncome() async {
    List<Map<String, dynamic>> result = await groupIncome();
    setState(() {
      incomeData = result;
    });

  }
  Object _getMonthNumber(monthName) {
    const monthMap = {
      '01': "January",
      '02':'February',
      '03':'March',
      '04':'April',
      '05':'May',
      '06':'June',
      '07':'July',
      '08':'August',
      '09':'September',
      '10':'October',
      '11':'November',
      '12':'December',
    };
    return monthMap[monthName] ?? DateTime.now().month; // Default to current month
  }

  @override
  void initState(){
    super.initState();
    getIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income Page'),
        centerTitle: true,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.builder(
                itemCount: incomeData.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Image.asset('assets/images/schedule.png', width: 30,),
                      trailing: Text("${ incomeData[index]['total_income']}"),
                      title: Text("${_getMonthNumber(incomeData[index]['month'])}"),
                      subtitle: Text("${incomeData[index]['year']}"),
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MonthlyIncomeList(
                              month: incomeData[index]['month'],
                              year: incomeData[index]['year'])));

                      },
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
         onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context){
              return AddIncomeDialog();
              });
         },
         backgroundColor: Colors.teal,
         label: const Text('Add Income'),
          icon: const Icon(Icons.add),
      ),
    );
  }
}
