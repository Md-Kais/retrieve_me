import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrieve_me/Components/my_textfield.dart';
import 'package:retrieve_me/pages/login.dart';
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
        body: FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 45, 44, 46),
                Color.fromARGB(255, 5, 63, 111)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
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
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: firstNameController,
                      hintText: 'John',
                      obscureText: false,
                      prefixIcon: Icons.person,
                      labelText: 'First Name',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))
                      ],
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: lastNameController,
                      hintText: 'Doe',
                      obscureText: false,
                      prefixIcon: Icons.person,
                      labelText: 'Last Name',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))
                      ],
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: contactNumberController,
                      hintText: '', // You can provide a hint text here
                      obscureText: false, // Set to true for password fields
                      prefixIcon: Icons.phone,
                      labelText: 'Contact Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Allow digits only
                    ),
                    SizedBox(height: 16),
                    MyTextField(
                      controller: emailController,
                      hintText: 'johnKais@email.com',
                      obscureText: false,
                      prefixIcon: Icons.email,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    MyTextField(
                      controller: passwordController,
                      hintText: '',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      labelText: 'Password',
                      keyboardType: TextInputType.text,
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
                    SizedBox(height: 36),
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
                    SizedBox(height: 30), //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            ' Log In ',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
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
