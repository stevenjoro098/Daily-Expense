import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import 'add_expenditure.dart';
import 'db.dart';
import 'home.dart';
import 'calendar.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main()  async {
  sqfliteFfiInit(); // Initialize sqflite_common_ffi
  databaseFactory = databaseFactoryFfi;
  // Initialization settings for Android
  var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
  runApp(MyApp());
}
Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  // Handle the receipt of a notification on iOS
}

Future selectNotification(String payload) async {
  // Handle what happens when the user taps on the notification
}
class Expense {
  final String item;
  final double amount;

  Expense(this.item, this.amount);
}

class MyApp extends StatelessWidget {
   // Initial value
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins'
      ),
      home: const HomePage(),
    );
  }
}



  // Color _getColor(int index) {
  //   List<Color> colors = [
  //     Colors.blue,
  //     Colors.green,
  //     Colors.orange,
  //     Colors.red,
  //     // Add more colors if needed
  //   ];
  //   return colors[index % colors.length];
  // }

