import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/my_button.dart';
import 'package:retrieve_me/Components/navigation_drawer_widget.dart';
import 'package:retrieve_me/auth/auth_services.dart';
import 'package:retrieve_me/pages/ChatPage.dart';
import 'package:retrieve_me/pages/mapscreen.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';
import 'package:intl/intl.dart';
import 'package:widget_zoom/widget_zoom.dart';

import '../firebase_options.dart';

GlobalKey<ScaffoldState> _sKey = GlobalKey();

class LostItemListPage extends StatefulWidget {
  const LostItemListPage({super.key});

  @override
  State<LostItemListPage> createState() => _LostItemListPageState();
}

class _LostItemListPageState extends State<LostItemListPage> {
  Stream<QuerySnapshot> query =
      FirebaseFirestore.instance.collection('LostProduct').snapshots();
  int index = 0;
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
              FirebaseFirestore.instance.collection('LostProduct').snapshots();
        } else {
          query = FirebaseFirestore.instance
              .collection('LostProduct')
              .where('LostItem', isEqualTo: _searchText.trim())
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
              'Lost Items',
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
            return SafeArea(
                child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 45, 44, 46),
                          Color.fromARGB(255, 5, 63, 111),
                          Color.fromARGB(255, 5, 63, 111)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        viewSearchBar(),
                        queryLostItems(),
                      ],
                    )));
          },
        ),
      ),
    );
  }

  Widget queryLostItems() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: query,
        // FirebaseFirestore.instance.collection('LostProduct').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true, // Add shrinkWrap: true to ListView.builder
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 137, 181, 201),
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
                                  ds['LostItem'],
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
                                  'Date of Request',
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
                                  'Time of Request',
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
                                    onPressed: () async {
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
                                const SizedBox(height: 10),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width:
                                      MediaQuery.of(context).size.width * 0.350,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      print('User Id');
                                      print(ds['UserID']);
                                      await addLostProductToUser(
                                          AuthService.currentUser!.uid,
                                          ds.id,
                                          ds['UserID']);

                                      print(ds.id);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                              userId:
                                                  AuthService.currentUser!.uid,
                                              postId: ds.id,
                                              receiverId: ds['UserID']),
                                        ),
                                      );
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => MapScreen(
                                      //           address: ds['CityLocation']),
                                      //     ));
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
          labelText: 'Search Lost Item',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  // Future<void> createSubcollection(String userID, String productID) async {
  //   // Reference to the main "items" collection
  //   CollectionReference itemsCollection =
  //       FirebaseFirestore.instance.collection('UserMessage');
  //
  //   // Reference to the specific item document
  //   DocumentReference itemDocument = itemsCollection.doc(productID);
  //
  //   // Reference to the "messages" subcollection inside the item document
  //   CollectionReference messagesCollection =
  //       itemDocument.collection('messages');
  //
  //   // Add a new document with the message
  //   await messagesCollection.add({
  //     // You can include a timestamp if needed
  //   });
  // }

  Future<void> addLostProductToUser(
      String userId, String productId, String postUserID) async {
    try {
      // Reference to the user document in the database
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('User').doc(userId);

      // Get the current data of the user
      DocumentSnapshot userSnapshot = await userRef.get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Retrieve the existing list of lost product IDs or create an empty list
      List<String> lostProductIds =
          List<String>.from(userData['lostProductIds'] ?? []);

      // Add the new lost product ID to the list
      lostProductIds.add(productId);

      // Update the user document with the new list of lost product IDs
      await userRef.update({
        'lostProductIds': lostProductIds,
      });

      print('Lost product ID added to user document successfully.');
    } catch (e) {
      print('Error adding lost product ID to user document: $e');
    }
    try {
      // Create a document in the UserMessages collection
      await FirebaseFirestore.instance
          .collection('UserMessage')
          .doc(productId)
          .collection(userId)
          .add({
        // Add any additional information you want to store for the conversation
        'timestamp': FieldValue.serverTimestamp(),
        'senderId': userId,
        'receiverId': postUserID,
        'message': 'this product is mine',
      });

      print('Chat document created successfully.');
    } catch (e) {
      print('Error creating chat document: $e');
    }

    try {
      // Reference to the product claim document in the database
      DocumentReference productClaimRef =
          FirebaseFirestore.instance.collection('ProductClaim').doc(productId);

      // Get the current data of the product claim document
      DocumentSnapshot productClaimSnapshot = await productClaimRef.get();
      Map<String, dynamic>? productClaimData =
          productClaimSnapshot.data() as Map<String, dynamic>?;

      if (postUserID != userId) {
        if (productClaimData == null) {
          // If the document doesn't exist, create it with the productId as the document ID
          await productClaimRef.set({
            'productId': productId,
            'assertUsers': [userId],
          });
        } else {
          // If the document already exists, update the assertUsers field
          List<String> assertUsers =
              List<String>.from(productClaimData['assertUsers'] ?? []);
          assertUsers.add(userId);

          // Update the product claim document with the new list of assertUsers
          await productClaimRef.update({
            'assertUsers': assertUsers,
          });
        }
      }

      print('User asserted claim for product successfully.');
    } catch (e) {
      print('Error asserting claim for product: $e');
    }
  }
}
