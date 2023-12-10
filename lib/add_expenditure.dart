import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'add_category.dart';

class addExpensesPage extends StatefulWidget {
  const addExpensesPage({super.key});


  @override
  State<addExpensesPage> createState() => _addExpensesPageState();
}

class _addExpensesPageState extends State<addExpensesPage> {
 TextEditingController expensesController = TextEditingController();
  @override
  void initState(){
    super.initState();
    expensesController;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text('Add Expenses'),
              ],
            ),
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
                    onPressed: (){},
                    label: const Text('Category'),
                    icon: const Icon(Icons.category),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent)
                    ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Center(
                  child: TextField(
                    controller: expensesController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Amount',
                      labelText: 'Expense Amount',
                      border: OutlineInputBorder()
                    ),
                  )
              ),
            ),
             ElevatedButton(
                  onPressed: (){},
                  child: const Text('Submit'),
              ),
            TextButton(
                onPressed:(){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return addCategoryDialog();
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
