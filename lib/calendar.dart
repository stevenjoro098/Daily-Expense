import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'db.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> dayExpenses = [];
  DateTime now = DateTime.now();

  Future<List<Map<String, dynamic>>> getDateExpenses(date) async{
    List<Map<String, dynamic>> data = await expenseList(date);
    //print('$date - $data');
    setState(() {
      dayExpenses = data; // constantly update list when data is fetched.
    });
    print(dayExpenses);
    return data;
  }

  String extractDate(String dateTimeString){
      DateTime dateTime = DateTime.parse(dateTimeString);
      String dateOnly = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      print("Extracted Date: $dateOnly");
      return dateOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day){
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay){
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
               // print(selectedDay);
               String date = extractDate("$selectedDay");

               getDateExpenses(date);

              },
              onFormatChanged: (format){
                setState(() {
                  _calendarFormat = format;
                });
            },
              onPageChanged: (focusedDay){

              },
            ),
          ),
          const Divider(),
          const Text('Expenses: ', style: TextStyle(
            fontWeight: FontWeight.bold,
          ),),
          Expanded(
            child: dayExpenses.isEmpty ?
                Center(
                  child: Image.asset('assets/images/rascal-nothing-to-see-here.gif', height: 300, width: 300,),

                )
            :ListView.builder(
                itemCount: dayExpenses.length,
                itemBuilder: (context, index){
                  return ListTile(
                    leading: Image.asset('assets/images/cost.png'),
                    title: Text('${dayExpenses[index]['category']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    subtitle: Text('Ksh. ${dayExpenses[index]['expense_amount']}'),
                    trailing: IconButton(
                      onPressed: (){
                       deleteExpense(dayExpenses[index]['id']);
                      },
                      icon: const Icon(Icons.clear, color: Colors.indigo,),
                    ),
                    onTap: (){

                    },
                  );
                }
            ),
          )

        ],
      ),
    );
  }
}



