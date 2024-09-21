import 'package:flutter/material.dart';

import '../utils/db.dart';

class AddIncomeDialog extends StatefulWidget {
  const AddIncomeDialog({super.key});

  @override
  State<AddIncomeDialog> createState() => _AddIncomeDialogState();
}

class _AddIncomeDialogState extends State<AddIncomeDialog> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Income Form'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: amountController,
            decoration: InputDecoration(
              hintText: ' Amount',
              prefixIcon: Image.asset('assets/images/money.png', width: 18,)
            ),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: ' Description',
              prefixIcon: Image.asset('assets/images/edit.png',width: 18,)
            ),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: (){
                    var IncomeDate = "${DateTime.now()}";
                    var amount= amountController.text;
                    insertIncome(
                        context,
                        amount,
                        descriptionController.text,
                        IncomeDate
                      );
                    Navigator.pop(context);
                  },
                  child: Text('Ok')
              ),
              ElevatedButton(
                  onPressed: (){},
                  child: Text('Cancel')
              )
            ],
          )
        ],
      ),
    );
  }
}
