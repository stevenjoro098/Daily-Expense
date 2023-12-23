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

  Future<void> getDateExpenses(date) async{
    List<Map<String, dynamic>> data = await expenseList(date);
    print('$date - $data');

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
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2023, 12, 31),
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
              print(selectedDay);
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
          const Divider(),


        ],
      ),
    );
  }
}



