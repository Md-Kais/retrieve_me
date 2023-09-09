import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrieve_me/Components/my_textfield.dart';
import '../firebase_options.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  // TextEditingController registrationController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  XFile? selectedImage;

  void _submitRegistration() {
    if (_areAllFieldsFilled()) {
      //route to new page
      //   confirm registration and insert to database
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ConfirmedRegistration()),
      //   );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content:
              Text('Please fill all the required fields before submitting!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  void _insertImage() async {
    final selector = ImagePicker();
    final selectedFile = await selector.pickImage(source: ImageSource.gallery);

    if (selectedFile != null) {
      setState(() {
        selectedImage = selectedFile;
      });
    }
  }

  bool _areAllFieldsFilled() {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        contactNumberController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectedImage != null;
  }

  void _resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        // appBar: AppBar(
        //   title: const Text('Registration'),
        //
        // ),

        body: FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        return Container(
          // padding: EdgeInsets.all(10.0), // Padding for the box
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 45, 44, 46),
                Color.fromARGB(255, 5, 63, 111)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),

            // Box shape
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DrawerHeader(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'REGISTRATION',
                            style: GoogleFonts.oswald(
                              // Google font
                              textStyle: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const Text('Registration', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold  )),
                    // const Divider(color: Colors.white, thickness: 1, indent:12, endIndent: 12 ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: firstNameController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(179, 223, 206, 206)),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 156, 178, 197)), // Border color
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)), // Border radius
                          ),
                          hintText: 'John',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z. ]'))
                        ], // Allow letters and periods
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(179, 223, 206, 206)),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 156, 178, 197)), // Border color
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)), // Border radius
                          ),
                          hintText: 'Doe',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z. ]'))
                        ], // Allow letters and periods
                      ),
                    ),
                    SizedBox(height: 16),
                    MyTextField(
                      controller: contactNumberController,
                      hintText: '', // You can provide a hint text here
                      obscureText: false, // Set to true for password fields
                      prefixIcon: Icons.phone,
                      labelText: 'Contact Number',
                      keyboardType: TextInputType
                          .phone, // Set keyboardType to allow numeric input
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Allow digits only
                    ),

                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: emailController,
                        enableSuggestions: false,
                        autocorrect: false,
                        // autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(179, 223, 206, 206)),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 156, 178, 197)), // Border color
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)), // Border radius
                          ),
                          hintText: 'johnKais@email.com',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(179, 223, 206, 206)),
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(
                                    255, 156, 178, 197)), // Border color
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)), // Border radius
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextButton(
                        onPressed: _insertImage,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            shadowColor: Colors.green),
                        child: const Text('Insert Profile Image'),
                      ),
                    ),
                    SizedBox(height: 56),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _resetFields,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey,
                              textStyle: TextStyle(color: Colors.blueAccent)),
                          child: const Text('Reset'),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final firstName = firstNameController.text;
                            final lastName = lastNameController.text;
                            final contactNumber = contactNumberController.text;
                            final email = emailController.text;
                            final password = passwordController.text;
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ));
  }
}
