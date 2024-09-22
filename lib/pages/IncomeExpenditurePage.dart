import 'package:flutter/material.dart';

class IncomeExpenditurePage extends StatefulWidget {
  String month;
  String year;
  IncomeExpenditurePage({super.key, required this.month, required this.year});

  @override
  State<IncomeExpenditurePage> createState() => _IncomeExpenditurePageState();
}

class _IncomeExpenditurePageState extends State<IncomeExpenditurePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.arrow_downward_rounded,), text:'Income',),
                Tab(icon: Icon(Icons.upload_rounded), text:'Expenses'),
                //Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: Text('${widget.month}-${ widget.year }'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      );
  }
}
