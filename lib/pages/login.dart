// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/my_button.dart';
import 'package:retrieve_me/Components/my_textfield.dart';
import 'package:retrieve_me/Components/square_tile.dart';
import 'package:retrieve_me/firebase_options.dart';
import 'package:retrieve_me/pages/postLostItem.dart';
import 'package:retrieve_me/pages/registration.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';

import '../auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String _errMsg = '';

  // sign user in method
  Future<void> signUserIn(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PostLostItemPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => NavigationProvider(),
        child: Scaffold(
          body: Form(
            key: _formKey, // Use key property for Form widget
            child: FutureBuilder(
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
                                    'LOG IN',
                                    style: GoogleFonts.oswald(
                                      textStyle: const TextStyle(
                                        fontSize: 35,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 50), // Removed 'const'

                            // welcome back, you've been missed!
                            Text(
                              'Welcome back you\'ve been missed!',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 25), // Removed 'const'

                            // username textfield

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

                            const SizedBox(height: 10), // Removed 'const'

                            // forgot password?
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
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

                            const SizedBox(height: 25),

                            // sign in button
                            ElevatedButton(
                              // Use UniqueKey to force the creation of a new instance
                              onPressed: () {
                                // Your onTap logic
                                print("done");
                                _authenticate();
                              },
                              child: Text("Log In"),
                            ),


                            const SizedBox(height: 50), // Removed 'const'

                            // or continue with
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      'Or continue with',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 50), // Removed 'const'

                            // google + apple sign in buttons
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // google button
                                SquareTile(imagePath: 'lib/images/google.png'),

                                SizedBox(width: 25),

                                // apple button
                                SquareTile(imagePath: 'lib/images/github.png')
                              ],
                            ),

                            const SizedBox(height: 50), // Removed 'const'

                            // not a member? register now
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Not a member?',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegistrationPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
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
          ),
        ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _authenticate() async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = emailController.text;
      final password = passwordController.text;
      try {
        final User user = await AuthService.loginAdmin(email, password);
        EasyLoading.dismiss();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PostLostItemPage(),
          ),
        );
            } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }
}
