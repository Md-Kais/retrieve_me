import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    if(_areAllFieldsFilled()){ //route to new page
    //   confirm registration and insert to database
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => ConfirmedRegistration()),
      //   );
    }else{
      showDialog(
          context: context, builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all the required fields before submitting!'),
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

    if(selectedFile != null){
      setState(() {
        selectedImage = selectedFile;
      });
    }
  }

  bool _areAllFieldsFilled(){
    return firstNameController.text.isNotEmpty
    && lastNameController.text.isNotEmpty
    && contactNumberController.text.isNotEmpty
    && emailController.text.isNotEmpty
    && passwordController.text.isNotEmpty
    && selectedImage != null;
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
    return Scaffold( //
      // appBar: AppBar(
      //   title: const Text('Registration'),
      //
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blue],
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
                        alignment: Alignment.center,
                        child: Text('Registration', style: GoogleFonts.raleway( // Google font
                            textStyle: TextStyle(fontSize: 35, fontWeight: FontWeight.bold ),),),
                      ),
                    ),
                  ),
                  // const Text('Registration', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold  )),
                  // const Divider(color: Colors.white, thickness: 1, indent:12, endIndent: 12 ),
                  const SizedBox(height:30),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))], // Allow letters and periods
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z. ]'))], // Allow letters and periods
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: contactNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone, // set keyboardType
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow digits only
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: _insertImage,
                      style: TextButton.styleFrom(backgroundColor: Colors.cyan, shadowColor: Colors.green),
                      child: const Text('Insert Profile Image'),
                    ),
                  ),
                  SizedBox(height: 56),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _resetFields,
                        style: ElevatedButton.styleFrom(primary: Colors.blueGrey, textStyle: TextStyle(color: Colors.blueAccent)),
                        child: const Text('Reset'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _submitRegistration,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}