import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retrieve_me/Components/my_button.dart';
import 'package:retrieve_me/Components/my_textfield.dart';
import 'package:retrieve_me/Components/square_tile.dart';
import 'package:retrieve_me/firebase_options.dart';
import 'package:retrieve_me/pages/postLostItem.dart';
import 'package:retrieve_me/pages/registration.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  // text editing controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // sign user in method
  Future<void> signUserIn(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostLostItemPage(),
      ),
    );
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
                              'LOG IN',
                              style: GoogleFonts.oswald(
                                textStyle: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50), // Removed 'const'

                      // welcome back, you've been missed!
                      Text(
                        'Welcome back you\'ve been missed!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      SizedBox(height: 25), // Removed 'const'

                      // username textfield

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

                      SizedBox(height: 10), // Removed 'const'

                      // forgot password?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // sign in button
                      MyButton(
                        onTap: (){
                              signUserIn(context);
                              }
                          ),

                          SizedBox(height: 50), // Removed 'const'

                          // or continue with
                          Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                          children: [
                          Expanded(
                          child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                          ),
                          ),
                          Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                          ),
                          ),
                          Expanded(
                          child: Divider
                        (
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 50), // Removed 'const'

                      // google + apple sign in buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button
                          SquareTile(imagePath: 'lib/images/google.png'),

                          SizedBox(width: 25),

                          // apple button
                          SquareTile(imagePath: 'lib/images/github.png')
                        ],
                      ),

                      SizedBox(height: 50), // Removed 'const'

                      // not a member? register now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => RegistrationPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Register now',
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
      ),
    );
  }
}
