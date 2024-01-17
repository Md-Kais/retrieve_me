import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retrieve_me/Components/navigation_drawer_widget.dart';
import 'package:retrieve_me/provider/navigation_provider.dart';
import 'package:intl/intl.dart';

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
                    queryLostItems(),
                  ],
                ));
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
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                      margin: const EdgeInsets.all(15.0),
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
                              Image.network(
                                'https://placehold.co/600x400/000000/FFFFFF/png',
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
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
}
