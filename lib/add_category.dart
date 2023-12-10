import 'package:flutter/material.dart';
import 'db.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class addCategoryDialog extends StatefulWidget {
  const addCategoryDialog({super.key});

  @override
  State<addCategoryDialog> createState() => _addCategoryDialogState();
}

class _addCategoryDialogState extends State<addCategoryDialog> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final TextEditingController _categoryController = TextEditingController();
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
              await _databaseHelper.insertCategory(data);
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
}
