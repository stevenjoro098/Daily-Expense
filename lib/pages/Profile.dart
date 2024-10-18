import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEditing = false; // Toggle between view and edit mode
  final _formKey = GlobalKey<FormState>();

  // User information (initially empty, will load from SharedPreferences)
  String firstName = "";
  String lastName = "";
  String email = "";
  String phoneNumber = "";
  String currency = "";

  // Controllers for editing text fields
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData(); // Load data from SharedPreferences when the page initializes
  }

  // Function to load profile data from SharedPreferences
  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'John';
      lastName = prefs.getString('lastName') ?? 'Doe';
      email = prefs.getString('email') ?? 'johndoe@example.com';
      phoneNumber = prefs.getString('phoneNumber') ?? '123-456-7890';
      currency = prefs.getString('currency') ?? 'USD';

      // Update the controllers with the loaded data
      firstnameController.text = firstName;
      lastnameController.text = lastName;
      emailController.text = email;
      phoneController.text = phoneNumber;
      currencyController.text = currency;
    });
  }

  // Function to save profile data to SharedPreferences
  Future<void> saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstnameController.text);
    await prefs.setString('lastName', lastnameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phoneNumber', phoneController.text);
    await prefs.setString('currency', currencyController.text);

    // Update the local state to reflect saved data
    setState(() {
      firstName = firstnameController.text;
      lastName = lastnameController.text;
      email = emailController.text;
      phoneNumber = phoneController.text;
      currency = currencyController.text;
    });
  }

  // Toggle editing mode
  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  // Save profile changes
  void saveChanges() {
    if (_formKey.currentState!.validate()) {
      saveProfileData(); // Save to SharedPreferences
      setState(() {
        isEditing = false; // Exit edit mode after saving
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: isEditing ? saveChanges : toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset('assets/images/user.png', height: 100),
                ),
                // Name Field
                SizedBox(height: 20,),
                TextFormField(
                  controller: firstnameController,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your First name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: lastnameController,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Email Field
                TextFormField(
                  controller: emailController,
                  enabled: isEditing,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Phone Number Field
                TextFormField(
                  controller: phoneController,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Phone Number Field
                TextFormField(
                  controller: currencyController,
                  enabled: isEditing,
                  decoration: const InputDecoration(
                    labelText: "Currency",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Currency of Choice';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Save Button (only shown in editing mode)
                if (isEditing)
                  ElevatedButton(
                    onPressed: saveChanges,
                    child: Text("Save Changes"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
