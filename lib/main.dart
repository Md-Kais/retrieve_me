import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/pages/itemHistory.dart';
import 'package:retrieve_me/pages/leaderBoardPage.dart';
import 'package:retrieve_me/pages/login.dart';
import 'package:retrieve_me/pages/profilePage.dart';
import 'package:retrieve_me/pages/registration.dart';
import 'package:retrieve_me/pages/userPage.dart';
import 'package:retrieve_me/provider/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Retrieve-Me',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: LoginPage.routeName,
        routes: {
          LoginPage.routeName: (_) => const LoginPage(),
          ProfilePage.routeName: (_) => const ProfilePage(),
          LeaderBoardPage.routeName: (_) => const LeaderBoardPage(),
          UserPage.routeName: (_) => const UserPage(),
          RegistrationPage.routeName: (_) => const RegistrationPage(),
          ItemHistory.routeName: (_) => const ItemHistory(),
        });
  }
}
