// import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/my_textfield.dart';
import 'package:retrieve_me/auth/auth_services.dart';
import 'package:retrieve_me/db/db_helper.dart';
import 'package:retrieve_me/pages/login.dart';
import 'package:retrieve_me/pages/postLostItem.dart';
import 'package:retrieve_me/provider/user_provider.dart';
import '../firebase_options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/UserModel.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  // TextEditingController registrationController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
 final TextEditingController lastNameController = TextEditingController();
 final TextEditingController contactNumberController = TextEditingController();
 final TextEditingController addressController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();

  XFile? selectedImage;


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
        addressController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    //  && selectedImage != null;
  }

  void _resetFields() {
    firstNameController.clear();
    lastNameController.clear();
    contactNumberController.clear();
    addressController.clear();
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DrawerHeader(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'REGISTRATION',
                            style: GoogleFonts.oswald(
                              // Google font
                              textStyle: const TextStyle(
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
                      hintText:
                          '01765432109', // You can provide a hint text here
                      obscureText: false, // Set to true for password fields
                      prefixIcon: Icons.phone,
                      labelText: 'Contact Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ], // Allow digits only
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: addressController,
                      hintText:
                          'Zero Point, Chittagong University Road, New Mooring Chittagong',
                      obscureText: false,
                      prefixIcon: Icons.location_city,
                      labelText: 'Address',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: emailController,
                      hintText: 'johnKais@email.com',
                      obscureText: false,
                      prefixIcon: Icons.email,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: passwordController,
                      hintText: '',
                      obscureText: true,
                      prefixIcon: Icons.lock,
                      labelText: 'Password',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: TextButton(
                        onPressed: _insertImage,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shadowColor: Colors.green,
                        ),
                        child: const Text('Insert Profile Image',
                            style: TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.250,
                          child: ElevatedButton(
                            onPressed: _resetFields,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            child: const Text('Reset',
                                style: TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Checkbox.width * 0.90,
                                )),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.250,
                          child: ElevatedButton(
                            onPressed: _submitRegistration,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              // splashFactory: InkRipple.splashFactory,
                            ),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: Checkbox.width * 0.90,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
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
  void _submitRegistration() async {
    if (_areAllFieldsFilled()) {
      EasyLoading.show(status: 'File is uploading', dismissOnTap: false);
      final firstName = firstNameController.text;
      final lastName = lastNameController.text;
      final contactNumber = contactNumberController.text;
      final address = addressController.text;
      final email = emailController.text;
      final password = passwordController.text;
      try {
        User user;

        user = await AuthService.registerUser(email, password,contactNumber);
        // String uid = user.uid;
        // UserModel? userModel;
        Future<void> addUser(User user) async{
          try {
            final userModel = UserModel(
              userId: user.uid,
              email: user.email!,
              firstName : firstName,
              userCreationTime: Timestamp.fromDate(DateTime.now()),
              address: address,
              profession: 'Student',
              contactNo: contactNumber,

            );
            await db_helper.addUser(userModel);

          }
          catch(error){
            print('Error adding user to Firestore: $error');
            // Handle error accordingly
          }
        }
        addUser(user);
        //
        // await Provider.of<UserProvider>(
        //
        //
        //     context, listen: false).addUser(user);

        EasyLoading.dismiss();
        Navigator.pushReplacement(


            context,
            MaterialPageRoute(
              builder: (context) => const PostLostItemPage(),
            ));
        // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      } on FirebaseAuthException catch (error) {}
      //   email: email,
      //   password: password,
      // );
      showDialog(


        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registered Sucessfully!'),
          content: const Text('You have created a new account now!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
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
          title: const Text('Error'),
          content: const Text(
              'Please fill all the required fields before submitting!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

}
