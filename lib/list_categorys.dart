
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'db.dart';

class listCategory extends StatefulWidget {
  const listCategory({super.key});

  @override
  State<listCategory> createState() => _listCategoryState();
}

class _listCategoryState extends State<listCategory> {

  List<Map<String, dynamic>> myData = [];

// Database Methods. ==========================================================
//   Future<Database> initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, 'expenses.db');
//     return openDatabase(
//       path,
//       version: 1,
//       onCreate: (database, version) async{
//         await database.execute(
//           '''CREATE TABLE category(id INTEGER PRIMARY KEY, category_name TEXT)''',
//         );
//         await database.execute('''
//           CREATE TABLE expense(id INTEGER PRIMARY KEY, expense_name TEXT, description TEXT)
//         ''');
//         print('table created');
//       },
//     );
//
//   }

  // Future<List<Map<String, dynamic>>> categoryList() async {
  //   final db = await initDatabase();
  //   final List<Map<String, dynamic>> maps = await db.query('category');
  //   print('Fetch Category Method Called');
  //   return db.query('category');
  // }


// ****************************************************************************
  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = await categoryList();
    setState(() {
      myData = data;
    });
  }


  @override
  void initState() {
    super.initState();
    //initDatabase();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            itemCount: myData.length,
              shrinkWrap: true,
              itemBuilder:(context, index){
                return ListTile(
                  title: Text('${myData[index]['category_name']}'),
                  onTap: (){
                    Navigator.pop(context,'${myData[index]['category_name']}'); // return category name to parent widget.
                  },
                );
             }
          ),
          Divider(),
          ElevatedButton(
              onPressed: (){
                Navigator.of(context).pop(null);
              },
              child: Text('Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),)
          )
        ],
      ),
    );
  }
}
