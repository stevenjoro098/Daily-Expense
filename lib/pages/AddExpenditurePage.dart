import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../widgets/add_category.dart';
import 'CategoriesPage.dart';
import '../utils/db.dart';
import 'CategoriesPage.dart';

class addExpensesPage extends StatefulWidget {
  const addExpensesPage({super.key});


  @override
  State<addExpensesPage> createState() => _addExpensesPageState();
}

class _addExpensesPageState extends State<addExpensesPage> {
  String expenseCategory = "";
  DateTime now = DateTime.now();
  final _formKey = GlobalKey<FormState>();
 TextEditingController expensesController = TextEditingController();
 TextEditingController expenseDescription = TextEditingController();

  Future<void> insertExpense(String expense, String description, String expense_date, String category) async {
    final db = await initDatabase();
    if(_formKey.currentState!.validate()){
      if(expenseCategory == ""){
        const snackBar = SnackBar(
          content: Text('Please Select a Category'),
        );
        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
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
        clear_textfields();
        expenseCategory = "";
        const snackBar = SnackBar(
          content: Text('Expense Added Successfully'),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

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
        backgroundColor: Colors.blueAccent,
        title: const Text('Expense',
          style: TextStyle(
              fontWeight: FontWeight.bold,
            fontFamily: 'Tillium'
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: TextFormField(
                                controller: expensesController,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.money),
                                    hintText: 'Enter Amount',
                                    labelText: 'Expense Amount',
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20), // Circular corners with a 30px radius
                                      borderSide: BorderSide.none, // Removes the border line
                                    ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.grey), // Border when the field is not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.blue), // Border when the field is focused
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Amount';
                                  }
                                  return null;
                                },
                              ),
                            )
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Image.asset('assets/images/app.png', width: 40,),
                          title: Text('Select Category: $expenseCategory'),
                          onTap: (){
                            _navigateAndDisplaySelection(context);
                          },

                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: TextFormField(
                            controller: expenseDescription,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.add_comment_outlined, color: Colors.blueAccent),
                                hintText: 'Description',
                                labelText: 'Expense Description',
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30), // Circular corners with a 30px radius
                                  borderSide: BorderSide.none, // Removes the border line
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.grey), // Border when the field is not focused
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.blue), // Border when the field is focused
                                ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter a Description';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                    ],
                  )

              ),

               const SizedBox(height: 20,),

               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   ElevatedButton(
                        onPressed: (){
                          insertExpense(
                            expensesController.text,
                            expenseDescription.text,
                            "${now.year}-${now.month}-${now.day}",
                            expenseCategory,
                          );
                          // if(expensesController.text.isEmpty && expenseDescription.text.isEmpty && expenseCategory.isEmpty){
                          //
                          // } else{
                          //
                          // }
                          //clear_textfields();


                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.

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

            ],
          ),
        ),
      ),
    );
  }
}
