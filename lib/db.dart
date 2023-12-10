import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Category{
  final int id;
  final String category_name;

  const Category({
    required this.id,
    required this.category_name
  });
}

class DatabaseHelper{
   static final DatabaseHelper _instance = DatabaseHelper._internal();
   factory DatabaseHelper()=> _instance;
   DatabaseHelper._internal();
   static late Database _database;

   Future<Database> get database async{
     if (_database != null) return _database;
     _database = await initDatabase();
     return _database;
   }

  Future<Database> initDatabase() async {
     return await openDatabase(
         join(await getDatabasesPath(), 'expense.db'),
         onCreate: (db, version) async{
           return await db.execute(
             'CREATE TABLE category( id INTEGER PRIMARY KEY, category_name TEXT)',
           );
         },
       version: 1,
     );
  }
   Future<void> insertCategory(String category) async {
     final db = await database;
     await db.insert(
         'category',
         {'content': category},
         conflictAlgorithm: ConflictAlgorithm.replace
     );
   }
}
