import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../utils/db.dart';
import '../pages/AddExpenditurePage.dart';


class addCategoryDialog extends StatefulWidget {
  const addCategoryDialog({super.key});

  @override
  State<addCategoryDialog> createState() => _addCategoryDialogState();
}

class _addCategoryDialogState extends State<addCategoryDialog> {

  final TextEditingController _categoryController = TextEditingController();

  
  @override
  void initState(){
    super.initState();


    //this._databaseHelper.initDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text('Add Category'),
      content: TextField(
        controller: _categoryController,
        decoration: const InputDecoration(hintText: 'Enter New Category'),
      ),
      actions: [
        ElevatedButton(
            onPressed: () async {
              String data = _categoryController.text;
              setState(() {

              });
              // Save data to SQLite
              await insertCategory(data);
              Navigator.of(context).pop();
            },
            child: Text('ADD')

        ),
        ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Cancel')
        )
      ],
    );
  }
  // Future<Database> _getDatabase() async {
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = join(directory.path, 'expenses.db');
  //   print('Get database method called: $path');
  //   return openDatabase(
  //       path,
  //       version: 1,
  //       onCreate: (Database db, int version) async {
  //         await db.execute('''
  //         CREATE TABLE category(
  //           id INTEGER PRIMARY KEY,
  //           content TEXT
  //         )
  //       ''');
  //       });
  // }
  //
  // Future<void> insertData(String data) async {
  //   final Database db = await _getDatabase();
  //   print('iNsert data method called');
  //   await db.insert(
  //     'category',
  //     {'content': data},
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
}
