import 'package:flutter/material.dart';

import '../utils/db.dart';
import '../widgets/add_category.dart';

class listCategory extends StatefulWidget {
  const listCategory({super.key});

  @override
  State<listCategory> createState() => _listCategoryState();
}

class _listCategoryState extends State<listCategory> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  List<Map<String, dynamic>> myData = [];

// ****************************************************************************
  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = await categoryList();
    setState(() {
      myData = data;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Optionally refresh the widget state here
    setState(() {
      // Update your widget state here
      fetchData();
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
              onPressed: () async {
                final result = showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return addCategoryDialog();
                  },
                );
                result.then((value) => fetchData()); // update the category list page.

            },
              icon: const Icon(Icons.add)
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
                                           onPressed: () async {
                                             //print(myData[index]['id']);
                                             deleteCategory(myData[index]['id']);
                                             Navigator.pop(context);
                                             setState(() {
                                               fetchData();
                                             });
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