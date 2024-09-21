import 'package:flutter/material.dart';

void main() => runApp(const categoryForm());

class categoryForm extends StatefulWidget {
  const categoryForm({super.key});

  @override
  State<categoryForm> createState() => _categoryFormState();
}

class _categoryFormState extends State<categoryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter Category Name'
            ),
            validator: (String? value){
              if(value == null || value.isEmpty){
                return 'Please Enter Name';
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
