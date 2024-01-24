import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/pages/userPage.dart';
import '../Components/navigation_drawer_widget.dart';
import '../provider/navigation_provider.dart';
import '../provider/user_provider.dart';
import 'CustomListTile.dart';

class LeaderBoardPage extends StatefulWidget {
  static const String routeName = '/leaderBoard';
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const SafeArea(

            child: Text(
              'Leader Board',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),



        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 45, 44, 46),
                    Color.fromARGB(255, 5, 63, 111),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
        ),
        drawer: const NavigationDrawerWidget(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 45, 44, 46),
                Color.fromARGB(255, 5, 63, 111),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [

                  Expanded(
                    child: Consumer<UserProvider>(
                      builder: (context, provider, child) => ListView.builder(
                        itemCount: provider.userList.length,
                        itemBuilder: (context, index) {
                          final userX = provider.userList[index];
                          return CustomListTile(
                            serialNumber: index + 1,
                            user: userX,
                            onTap: () {
                              // Add your navigation logic here
                              Navigator.pushNamed(context, UserPage.routeName,
                                  arguments: userX);

                            },
                          );
                        },
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
