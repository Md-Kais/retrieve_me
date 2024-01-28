import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Components/navigation_drawer_widget.dart';
import '../model/UserModel.dart';
import '../provider/navigation_provider.dart';
import 'leaderBoardPage.dart';

class UserPage extends StatefulWidget {
  static const String routeName = '/userPage';

  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  UserModel? userModel;

  @override
  void didChangeDependencies() {
    userModel = ModalRoute.of(context)!.settings.arguments as UserModel;
    super.didChangeDependencies();
  }

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
              title: SafeArea(
                child: Text(
                  "${userModel?.firstName} ${userModel?.lastName}",
                  style: const TextStyle(
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
                    tileMode: TileMode.clamp,
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
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
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildText(
                                        'Name: ${userModel!.firstName} ${userModel!.lastName}',
                                        isHeader: true),
                                    _buildText('Email: ${userModel!.email}'),
                                    _buildText(
                                        'Profession: ${userModel!.profession}'),
                                    _buildText('Points: ${userModel!.rating}'),
                                    _buildText(
                                        'Address: ${userModel!.address}'),
                                    _buildText('Creation Time: '
                                        '${_formatTimestamp(userModel!.userCreationTime)}'),
                                  ],
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
                                  child: Center(
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: const BorderSide(
                                              color: Colors.grey),
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
                                                  '⬅️ LEADERBOARD',
                                                  style: GoogleFonts.oswald(
                                                    textStyle: const TextStyle(
                                                      fontSize: 35,
                                                      color: Colors.purple,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  )),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )));
  }

  Widget _buildText(String text, {bool isHeader = false}) {
    return Column(children: [
      Text(
        text,
        style: GoogleFonts.oswald(
          textStyle: TextStyle(
            fontSize: isHeader ? 32 : 26,
            color: Colors.white,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
      const SizedBox(height: 5),
    ]);
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A'; // or any default value for null timestamp
    }
    // Convert Firebase Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();

    // Format DateTime to a desired format using intl package
    String formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);

    return formattedDate;
  }
}
