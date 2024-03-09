import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/navigation_drawer_widget.dart';
import 'package:retrieve_me/pages/imageMatching.dart';
import 'package:retrieve_me/pages/mapscreen.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';
import 'package:intl/intl.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:http/http.dart' as http;
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
  bool isLoading = false;
  double maxMatchProbability = 0.0;
  String maxMatchItem = '';
  String maxMatchItemImageUrl = '';
  late List<DocumentSnapshot> lostItems;
  int index = 0;
  Stream<QuerySnapshot> query =
      FirebaseFirestore.instance.collection('FoundProduct').snapshots();
  TextEditingController searchController = TextEditingController();
  String _searchText = "";
  String placeholder = 'https://placehold.co/600x400/000000/FFFFFF/png';

  @override
  void initState() {
    super.initState();
    fetchLostItems();
    searchController.addListener(() {
      setState(() {
        _searchText = searchController.text;
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
    searchController.dispose();
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

  Future<void> fetchLostItems() async {
    QuerySnapshot lostItemsSnapshot =
        await FirebaseFirestore.instance.collection('LostProduct').get();

    setState(() {
      lostItems = lostItemsSnapshot.docs;
    });
  }

  Future<void> findMatchingLostItem(String foundItemImageUrl) async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, String>> lostItemsData = [];

    for (var lostItem in lostItems) {
      String lostItemImageUrl = lostItem['ImageURL'];

      lostItemsData.add({
        'found_item_image_url': foundItemImageUrl,
        'lost_item_image_url': lostItemImageUrl,
        'lost_item_name': lostItem['LostItem'],
      });
    }

    print('Found Item Image URL: $foundItemImageUrl');
    print('Lost Items Data: $lostItemsData');
    print('Lost Items Data JSON: ${jsonEncode(lostItemsData)}');
    // make sure to run the backend server first before running the app
    final response = await http.post(
      Uri.parse(
          'http://192.168.0.183:5000/calculate_similarity'), // remember to change the IP address to your local machine's IP address if you are running the server locally
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'lost_items_data': lostItemsData,
        'found_item_image_url': foundItemImageUrl
      }),
    );

    print('Response: ${response.body}');
    maxMatchProbability = 0.0;
    maxMatchItem = '';
    maxMatchItemImageUrl = '';

    EasyLoading.dismiss();

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));

      print('Results: $results');

      // Process the results
      for (int i = 0; i < results.length; i++) {
        double similarityScore = results[i]['similarity_score'];
        String lostItemName = results[i]['itemName'];
        if (similarityScore >= maxMatchProbability) {
          maxMatchProbability = similarityScore.toDouble();
          maxMatchItem = lostItemName;
          maxMatchItemImageUrl = lostItems[i]['ImageURL'];
        }

        // Do something with the similarity score and lost item information
        print('Lost Item: $lostItemName, Similarity Score: $similarityScore');
      }
      print(
          'Max Match Probability: $maxMatchProbability, Max Match Item: $maxMatchItem, Max Match Item Image URL: $maxMatchItemImageUrl');
      maxMatchProbability = maxMatchProbability * 100;
      // EasyLoading.dismiss();
      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageMatching(
              lostItemImageURL: maxMatchItemImageUrl,
              lostItemName: maxMatchItem,
              lostItemMatchProbability:
                  double.parse(maxMatchProbability.toStringAsFixed(3)),
            ),
          ));
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle errors
      print('Error: ${response.reasonPhrase}');
      print("Make sure to run the backend server first before running the app");
    }
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(10.0),
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
                                      backgroundColor: const Color.fromARGB(
                                          255, 149, 202, 223),
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
                                    onPressed: () {
                                      EasyLoading.show(
                                          status:
                                              'Executing ML Model for image matching...');
                                      findMatchingLostItem(
                                          (ds.data() as Map<String, dynamic>?)!
                                                  .containsKey('ImageURL')
                                              ? ds['ImageURL']
                                              : placeholder);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 149, 202, 223),
                                      // splashFactory: InkRipple.splashFactory,
                                    ),
                                    child: const Text(
                                      'Check Matching Item',
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
                                          AuthService.currentUser!.uid,
                                          ds.id,
                                          ds['UserID']);

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
                                      //       builder: (context) => ChatPage());
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 149, 202, 223),
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
        controller: searchController,
        decoration: const InputDecoration(
          labelText: 'Search Found Item',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  Future<void> addFoundProductToUser(
      String userId, String productId, String postUserID) async {
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
      messageProductIds.add(productId);

      // Update the user document with the new list of lost product IDs
      await userRef.update({
        'messageProductIds': messageProductIds,
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
