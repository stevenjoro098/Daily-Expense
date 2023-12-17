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
                  expense_name TEXT, 
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

