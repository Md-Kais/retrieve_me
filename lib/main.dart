import 'package:flutter/material.dart';
import 'package:retrieve_me/pages/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Retrieve-Me',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      useMaterial3: true,
    ),
    // home: const RegistrationPage(),
    home: LoginPage(),
  ));
}
