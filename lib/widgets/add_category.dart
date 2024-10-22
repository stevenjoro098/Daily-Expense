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
                // Save data to SQLite
                await insertCategory(data);
                Navigator.of(context).pop('alert reply');
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
  }