import 'package:firebase_core/firebase_core.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/db/db_helper.dart';
import 'package:retrieve_me/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrieve_me/pages/leaderBoardPage.dart';
import '../Components/navigation_drawer_widget.dart';
import '../auth/auth_services.dart';
import '../firebase_options.dart';
import '../model/image_model.dart';
import '../provider/navigation_provider.dart';
import 'package:flutter/foundation.dart';

import '../provider/user_provider.dart';

GlobalKey<ScaffoldState> _sKey = GlobalKey();
final FirebaseAuth _auth = FirebaseAuth.instance;

User? get currentUser => _auth.currentUser;

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userModel;
  List<UserModel> userListX = [];

  @override
  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
    getUserInfo();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context, listen: false).getAllUsers();
    userListX = UserProvider().userList;
    await Future.delayed(const Duration(seconds: 5));
  }

  // Fetch user information from Firestore
  void getUserInfo() async {
    db_helper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          userModel = UserModel?.fromMap(snapshot.data()!);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: Scaffold(
        drawer: const NavigationDrawerWidget(),
        key: _sKey,
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _sKey.currentState!.openDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 70,
                                          backgroundColor: Colors.transparent,
                                          child: CachedNetworkImage(
                                            imageUrl: userModel!
                                                .thumbnailImage.downloadUrl,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${userModel?.firstName} ${userModel?.lastName}',
                                          style: GoogleFonts.oswald(
                                            textStyle: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          userModel!.profession,
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.cyanAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Points: ${userModel!.rating}',
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.amberAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          userModel!.address,
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            Card(
                              elevation: 5, // Adjust the elevation as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: InkWell(
                                onTap: () {
                                  // Add your onTap logic here
                                  print('Statistics Card Tapped');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.cyan, Colors.indigo],
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildStatColumn('Lost Items', '10'),
                                      const SizedBox(width: 18),
                                      _buildStatColumn('Found Items', '20'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the leaderboard page here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LeaderBoardPage(), // Replace with the actual page
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      // Navigate to the leaderboard page or add your onTap logic here
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LeaderBoardPage(), // Replace with the actual page
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'LEADERBOARD 👉',
                                            style: GoogleFonts.oswald(
                                              textStyle: const TextStyle(
                                                fontSize: 35,
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _buildStatColumn(String title, String number) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          number,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
