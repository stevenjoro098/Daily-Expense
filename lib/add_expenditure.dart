import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'add_category.dart';
import 'list_categorys.dart';
import 'db.dart';

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
          style: const TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
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
                      _navigateAndDisplaySelection(context); // push the alert widget and receive data from it.
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return listCategory();
                      //   });
                      },
                    label: const Text('Category'),
                    icon: const Icon(Icons.category),
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
               padding: EdgeInsets.all(8.0),
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
                        insertExpense(
                            expensesController.text,
                            expenseDescription.text,
                            "${now.year}-${now.month}-${now.day}",
                            expenseCategory,
                        );
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
                      child: const Text('Submit'),
                  ),
                ElevatedButton(
                      onPressed: (){
                        clear_textfields();
                      },
                      child: Text('Cancel')
                    ),
               ],
             ),
            SizedBox(height: 15,),
            TextButton(
                onPressed:(){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return const addCategoryDialog();
                      },
                  );
                },
                child: const Text('Add Category'))
          ],
        ),
      ),
    );
  }
}
