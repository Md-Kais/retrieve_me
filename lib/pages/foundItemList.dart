import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/navigation_drawer_widget.dart';
import 'package:retrieve_me/pages/mapscreen.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';
import 'package:intl/intl.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../auth/auth_services.dart';
import '../firebase_options.dart';
import 'ChatPage.dart';

GlobalKey<ScaffoldState> _sKey = GlobalKey();

class FoundItemListPage extends StatefulWidget {
  const FoundItemListPage({super.key});

  @override
  State<FoundItemListPage> createState() => _FoundItemListPageState();
}

class _FoundItemListPageState extends State<FoundItemListPage> {
  int index = 0;
  Stream<QuerySnapshot> query =
      FirebaseFirestore.instance.collection('FoundProduct').snapshots();
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  String placeholder = 'https://placehold.co/600x400/000000/FFFFFF/png';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
        if (_searchText == "") {
          query =
              FirebaseFirestore.instance.collection('FoundProduct').snapshots();
        } else {
          query = FirebaseFirestore.instance
              .collection('FoundProduct')
              .where('FoundItem', isEqualTo: _searchText.trim())
              .snapshots();
          print('Query result is: $query');
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NavigationProvider(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const SafeArea(
            child: Text(
              'Found Items',
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
        key: _sKey,
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
              child: Column(
                children: [
                  viewSearchBar(),
                  queryFoundItems(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget queryFoundItems() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: query,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 137, 181, 201),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              WidgetZoom(
                                heroAnimationTag: 'tag',
                                zoomWidget: Image.network(
                                  (ds.data() as Map<String, dynamic>?)!
                                          .containsKey('ImageURL')
                                      ? ds['ImageURL']
                                      : placeholder,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromARGB(255, 114, 53, 3),
                                  ),
                                ),
                                Text(
                                  ds['FoundItem'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromARGB(255, 114, 53, 3),
                                  ),
                                ),
                                Text(
                                  ds['Category'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const Text(
                                  'Date When Found',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromARGB(255, 114, 53, 3),
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy')
                                      .format(ds['DateTime'].toDate()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const Text(
                                  'Time When Found',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Color.fromARGB(255, 114, 53, 3),
                                  ),
                                ),
                                Text(
                                  DateFormat('hh:mm a')
                                      .format(ds['DateTime'].toDate()),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.350,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MapScreen(
                                                address: ds['ItemLocation']),
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 149, 202, 223),
                                      // splashFactory: InkRipple.splashFactory,
                                    ),
                                    child: const Text(
                                      'Location',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Checkbox.width * 0.70,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.350,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await addFoundProductToUser(
                                        AuthService
                                            .currentUser!.uid, ds.id);
                                      await createChatDocument(ds.id,
                                          AuthService.currentUser!.uid,
                                          ds['UserID']);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage
                                            (userId: AuthService
                                              .currentUser!.uid, postId: ds.id ,
                                            receiverId:  ds['UserID']),
                                        ),
                                      );
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => ChatPage());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 149, 202, 223),
                                      // splashFactory: InkRipple.splashFactory,
                                    ),
                                    child: const Text(
                                      'Assert a Claim',
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Checkbox.width * 0.70,
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ],
                      )),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget viewSearchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 15.0, right: 15.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        backgroundBlendMode: BlendMode.darken,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        style: TextStyle(color: Colors.amber[50]),
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search Found Item',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Future<void> addFoundProductToUser(
      String userId, String lostProductId) async {
    try {
      // Reference to the user document in the database
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      // Get the current data of the user
      DocumentSnapshot userSnapshot = await userRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Retrieve the existing list of lost product IDs or create an empty list
      List<String> messageProductIds =
      List<String>.from(userData['messageProductIds'] ?? []);

      // Add the new lost product ID to the list
      messageProductIds.add(lostProductId);

      // Update the user document with the new list of lost product IDs
      await userRef.update({
        'messageProductIds': messageProductIds,
      });

      print('Lost product ID added to user document successfully.');
    } catch (e) {
      print('Error adding lost product ID to user document: $e');
    }
  }
  Future<void> createChatDocument(String productId, String userId, String
  postUserID)
  async {
    try {
      // Create a document in the UserMessages collection
      String customId = userId;
      customId += '_';
      customId += postUserID;
      print(customId);
      await FirebaseFirestore.instance.collection('UserMessage').doc(productId)
          .collection(userId).add({
        // Add any additional information you want to store for the conversation
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': userId,
        'receiverId' : postUserID,
        'message' : 'this product is mine',
      });

      print('Chat document created successfully.');
    } catch (e) {
      print('Error creating chat document: $e');
    }
  }
}
