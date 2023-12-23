import 'package:flutter/cupertino.dart';
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
     String path = join(documentsDirectory.path, 'expenses.db');
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
            print('table created');
         },
     );
  }
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
        print('Fetch Category Method Called');
        // return List.generate(maps.length, (i){
        //   return Category(id: maps[i]['id'] as int,
        //       category_name: maps[i]['category_name'] as String
        //   );
        // });
        return db.query('category');
   }
   //*************************** LIST DATE EXPENSES *********************************

  Future<List<Map<String, dynamic>>> expenseList(String date) async{
  final db = await initDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT *
        FROM expense
        WHERE DATE(expense_date) = '${date}';

  ''');
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

  Future<double> totalMonthlyExpenditure(int month) async{
      final db = await initDatabase();
      final List<Map<String, dynamic>> result = await db.rawQuery(
        '''
        SELECT strftime('%m',expense_date) AS month_number,
            SUM(expense_amount) AS total_amount
        FROM expense
        WHERE strftime('%m',expense_date) = '12'  -- Replace '12' with your desired month number
        GROUP BY strftime('%m', expense_date);
        ''');
      print(result.first['total_amount']);
      double totalAmount = (result.first['total_amount'] ?? 0 ) as double;
      return totalAmount;
  }
  // ************************ Category and Its total Sum ************************

Future<List> categorySum() async {
  final db = await initDatabase();
  final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT category, SUM(expense_amount) AS total_amount
    FROM expense
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

