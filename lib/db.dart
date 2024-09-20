import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Category{
  final int id;
  final String category_name;
  Category({required this.id, required this.category_name});
   Category.fromMap(Map<String, dynamic> item):
      id=item['id'], category_name=item['category_name'];
   Map<String, Object> toMap(){
     return {'id':id, 'category_name': category_name};
   }

}
   // static final DatabaseHelper _instance = DatabaseHelper._internal();
   //
   // factory DatabaseHelper() => _instance;
   //
   // DatabaseHelper._internal();
   //
   // late Database _database;
   //
   // Future<Database> get database async{
   //   if (_database != null) return _database;
   //
   //   _database = await initDatabase();
   //   return _database;
   // }

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
     String path = join(documentsDirectory.path, 'expensesIncome.db');
     return openDatabase(
         path,
         version: 1,
         onCreate: (database, version) async{
            await database.execute(
             '''CREATE TABLE category(
                  id INTEGER PRIMARY KEY, 
                  category_name TEXT
                  )''',
              );
            await database.execute('''
            CREATE TABLE expense(
                  id INTEGER PRIMARY KEY,
                  category TEXT, 
                  expense_amount DOUBLE, 
                  description TEXT, 
                  expense_date DATE )
              ''');
            await database.execute('''
            CREATE TABLE IF NOT EXISTS income(
                  id INTEGER PRIMARY KEY,
                  income_amount DOUBLE, 
                  income_description TEXT, 
                  income_date DATE )
              ''');
            print('table created');
         },
     );
  }
  //**********************************Income Insert ********************************
  Future<void> insertIncome(BuildContext context, String IncomeAmount, String IncomeDescription, String IncomeDate) async {
  final db = await initDatabase();
  print('Income insert method called');
  await db.insert(
      'income',
      {
        'income_amount': IncomeAmount,
        'income_description': IncomeDescription,
        'income_date': IncomeDate
      },
      conflictAlgorithm: ConflictAlgorithm.replace
  );
  final snackBar = SnackBar(
    content: const Text('Income Added Successfully'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  //****************************************************************************
    Future<List<Map<String, dynamic>>> groupIncome() async {
       final db = await initDatabase();
       final List<Map<String, dynamic>> result = await db.rawQuery('''
            SELECT 
                strftime('%m', income_date) AS month, 
                strftime('%Y', income_date) AS year, 
                SUM(income_amount) AS total_income
            FROM 
                income
            GROUP BY 
                strftime('%Y-%m', income_date)
            ORDER BY 
                year, month
      ''');
       print("Income${ result }");
       return result;
    }
  //****************************************************************************
   Future<void> insertCategory(String category) async {
     final db = await initDatabase();
     print('insert method called');
     await db.insert(
         'category',
          {'category_name': category},
         conflictAlgorithm: ConflictAlgorithm.replace
     );
   }

   //************************* LIST ALL CATEGORY *******************************

   Future<List<Map<String, dynamic>>> categoryList() async {
        final db = await initDatabase();
        final List<Map<String, dynamic>> maps = await db.query('category');
        return db.query('category');
   }
   //*************************** LIST DATE EXPENSES *********************************

  Future<List<Map<String, dynamic>>> expenseList(String date) async{
  final db = await initDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT *
        FROM expense
        WHERE expense_date = '$date';

  ''');
  return result;
  }
  // ***************************** List All Expenses ***************************

Future<List<Map<String, dynamic>>> AllExpenseList() async {
  final db = await initDatabase();
  // Ensure the month is two digits
  int formattedMonth = 9;
  int year = 2024;
  final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT *
    FROM expense
    WHERE expense_date LIKE '${year}-${formattedMonth}%'
    ''',

  );

 // print(result);  // Debug: print the result
  return result;
}


  // *************************** Total Daily Expenditure Amount ****************

  Future<double> totalDayAmount(String date) async {
    final db = await initDatabase();
    print('Date: $date');
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
        SELECT SUM(expense_amount) AS total_amount 
        FROM expense 
        WHERE expense_date='${date}'
      ''',
    );
    double totalAmount = (result.first['total_amount'] ?? 0.0) as double;
    print('Todays total: $totalAmount');

    return totalAmount;
  }
  // ********************* Total Month Expense Amount *****************************

Future<double> totalMonthlyExpenditure(int month, int year) async {
  final db = await initDatabase();
  //print("${ month}-${year}");
  // Execute the query using db.query() method
  final List<Map<String, dynamic>> result = await db.query(
    'expense', // The table name
    columns: ['SUM(expense_amount) AS total_amount'], // Columns to fetch
    where: "expense_date LIKE '${ year }-${ month }%'"
  );

  // Get the total amount or return 0 if null
  double totalAmount = (result.first['total_amount'] ?? 0).toDouble();

  print('DB Monthly total: $totalAmount');
  AllExpenseList();
  return totalAmount;
}

// ************************ Category and Its total Sum ************************

Future<List> categorySum(int month, int year) async {
  final db = await initDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT category, SUM(expense_amount) AS total_amount
    FROM expense
    WHERE expense_date LIKE '${year}-${month}%'
    GROUP BY category;
    
  ''');
  // Create a set of all unique categories from the result
  Set<String> allCategories = Set.from(result.map((item) => item['category'] as String));

  // Create a map with default values of zero for all categories
  Map<String, dynamic> categoryMap = {};
  allCategories.forEach((category) {
    categoryMap[category] = {'category': category, 'total_amount': 0};
  });

  // Update the map with values from the result
  result.forEach((item) {
    final category = item['category'] as String;
    categoryMap[category] = item;
  });

  // Return the values as a list
  return categoryMap.values.toList();
}

// ***************************** DELETE CATEGORY ********************************

Future<void> deleteCategory(int id) async {
  final db = await initDatabase();
  await db.rawQuery('DELETE FROM category WHERE id =?', [id]); // Replace 123 with the ID
  //print('Deleted Object');
}

// **************************** DELETE EXPENSE *********************************

Future<void> deleteExpense(int id) async {
  final db = await initDatabase();
  await db.rawQuery(
    'DELETE FROM expense WHERE id =?',[id]
  );
  print('Expense Deleted');
}