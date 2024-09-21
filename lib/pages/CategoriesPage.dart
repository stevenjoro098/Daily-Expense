import 'package:flutter/material.dart';

import '../utils/db.dart';
import '../widgets/add_category.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category.'),
        actions: [
          IconButton(
              onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context){
                return const addCategoryDialog();
              },
            );
          },
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
           children:[
             ListView.builder(
                shrinkWrap: true,
                itemCount: myData.length,
                itemBuilder:(context, index){
                   return Card(
                     elevation: 2,
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ListTile(
                         leading: Image.asset('assets/images/app.png'),
                          title: Text('${myData[index]['category_name']}',
                              style: const TextStyle(
                                 fontWeight: FontWeight.bold
                                ),
                              ),
                          trailing:Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           IconButton(
                             onPressed: (){},
                             icon: Image.asset('assets/images/edit.png',height: 20, width: 20),
                           ),
                           IconButton(
                             onPressed: (){
                               showDialog(
                                   context: context,
                                   builder: (BuildContext context){
                                     return AlertDialog(
                                       title: const Text('Delete'),
                                       content: Text('Delete ${myData[index]['category_name']} Category??'),
                                       actions: <Widget>[
                                         TextButton(
                                           onPressed: () => Navigator.pop(context, 'Cancel'),
                                           child: const Text('Cancel'),
                                         ),
                                         TextButton(
                                           onPressed: (){
                                             //print(myData[index]['id']);
                                             deleteCategory(myData[index]['id']);
                                             Navigator.pop(context);
                                           },
                                           child: const Text('OK'),
                                         ),
                                       ],
                                     );
                                   }

                               );
                             },
                             icon: Image.asset('assets/images/delete.png',height: 20, width: 20),
                           ),
                         ],
                       ),
                          onTap: (){
                            Navigator.pop(context,'${myData[index]['category_name']}'); // return category name to parent widget.
                           },
                          ),
                     ),
                   );
              }
           ),
        ]
        ),
      ),
    );
  }
}