import 'package:flutter/material.dart';

import '../utils/db.dart';

class MonthlyIncomeList extends StatefulWidget {
  final String month;
  final String year;
  const MonthlyIncomeList({super.key, required this.month, required this.year});

  @override
  State<MonthlyIncomeList> createState() => _MonthlyIncomeListState();
}

class _MonthlyIncomeListState extends State<MonthlyIncomeList> {
  List <dynamic> incomeList = [];
  Future<List<Map<String, dynamic>>> getIncomeList() async{
    final results = await listMonthlyAllIncome(widget.month, widget.year);
    setState(() {
      incomeList = results;
    });
    return results;
  }
  @override
  void initState(){
    super.initState();
    getIncomeList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income - ${widget.month}, ${widget.year}', style: const TextStyle(fontFamily: 'Tillium'),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              incomeList.isEmpty
                ? const Center(
                child: Text('No Income Recorded'),
                )
              :ListView.builder(
                  itemCount: incomeList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        leading: Image.asset('assets/images/money.png'),
                        title: Text('${ incomeList[index]['income_amount']}', style: TextStyle(fontFamily:'Tillium'),),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Source: ${ incomeList[index]['income_description']}', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('${ incomeList[index]['income_date']}')
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: const Text('Delete'),
                                    content: Text('Delete ${incomeList[index]['income_amount']} from Income ??'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: (){
                                          //print(myData[index]['id']);
                                          deleteIncome(context, incomeList[index]['id']);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                }

                            );
                          },
                            icon:const Icon(Icons.close)
                        ),
                        //trailing: Text('${ incomeList[index]['income_date']}'),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
