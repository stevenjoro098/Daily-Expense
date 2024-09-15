import 'package:flutter/material.dart';
import 'db.dart';

class categoryPage extends StatefulWidget {
  const categoryPage({super.key});

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  List<Map<String, dynamic>> categoryData = [];

  Future<void> getCategory() async {
    List<Map<String, dynamic>> result = await categoryList();
    setState(() {
      categoryData = result;
    });
    print(categoryData);
  }

  @override
  void initState(){
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: categoryData.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      leading: Image.asset('assets/images/app.png'),
                      title: Text('${categoryData[index]['category_name']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing:  Row(
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
                                          content: Text('Delete ${categoryData[index]['category_name']} Category??'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: (){
                                                print(categoryData[index]['id']);
                                                deleteCategory(categoryData[index]['id']);
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
                    );
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}
