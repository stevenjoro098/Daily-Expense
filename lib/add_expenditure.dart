import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'add_category.dart';
import 'list_categorys.dart';
import 'db.dart';
import 'categories_page.dart';

class addExpensesPage extends StatefulWidget {
  const addExpensesPage({super.key});


  @override
  State<addExpensesPage> createState() => _addExpensesPageState();
}

class _addExpensesPageState extends State<addExpensesPage> {
  String expenseCategory = "";
  DateTime now = DateTime.now();
 TextEditingController expensesController = TextEditingController();
 TextEditingController expenseDescription = TextEditingController();

  Future<void> insertExpense(String expense, String description, String expense_date, String category) async {
    final db = await initDatabase();
    print('Expense insert Method Called');
    await db.insert(
      'expense',
      {'expense_amount': expense,
        'description': description,
        'expense_date': expense_date,
        'category': category
      },
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const listCategory()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    setState(() {
      expenseCategory = result;
    });
    //print('$expenseCategory after setstate');
    if (!mounted) return;
    //print(result);
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('${ result } Selected')));
  }

  void clear_textfields (){
    expenseCategory = "";
    expenseDescription.text = "";
    expensesController.text = "";
  }

@override
  void initState(){
    super.initState();
    expensesController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Expense Form',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: (){},
                      label: const Text('Payment Method'),
                    icon: const Icon(Icons.payment),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)
                    ),
                  ),
                  ElevatedButton.icon(
                      onPressed: (){
                       // push the alert widget and receive data from it.
                        _navigateAndDisplaySelection(context);
                      },
                      label: const Text('Category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black
                          )

                        ),
                      icon: const Icon(Icons.category,color: Colors.black,),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)
                      ),
                  ),

                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Center(
                    child: TextField(
                      controller: expensesController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.money_outlined),
                        hintText: 'Enter Amount',
                        labelText: 'Expense Amount',
                        filled: true,
                        border: OutlineInputBorder()
                      ),
                    )
                ),
              ),
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Center(
                   child: TextField(
                     controller: expenseDescription,
                     decoration: const InputDecoration(
                       prefixIcon: Icon(Icons.comment),
                       hintText: 'Description',
                       filled: true
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 20,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   ElevatedButton(
                        onPressed: (){
                          if(expensesController.text.isEmpty && expenseDescription.text.isEmpty && expenseCategory.isEmpty){
                              print('Nothing');
                          } else{
                            insertExpense(
                              expensesController.text,
                              expenseDescription.text,
                              "${now.year}-${now.month}-${now.day}",
                              expenseCategory,
                            );
                          }
                          clear_textfields();
                          final snackBar = SnackBar(
                            content: const Text('Expense Added Successfully'),
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
                        },
                        child: const Text('Submit',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    ),
                  ElevatedButton(
                        onPressed: (){
                          clear_textfields();
                        },
                        child: const Text('Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                 ],
               ),
              const SizedBox(height: 15,),

              ElevatedButton(
                  onPressed:(){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return const addCategoryDialog();
                                                 },
                    );
                  },
                  child:const Text('Add Category',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                  ),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const categoryPage()),);

                  },
                style: const ButtonStyle(
              //backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrangeAccent)
                 ),
                  child: const Text('Manage Category List',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                    ),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
