import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Components/navigation_drawer_widget.dart';
import '../auth/auth_services.dart';
import '../provider/navigation_provider.dart';

class ItemHistory extends StatefulWidget {
  static const String routeName = '/itemHistory';

  const ItemHistory({Key? key}) : super(key: key);

  @override
  _ItemHistoryState createState() => _ItemHistoryState();
}

class _ItemHistoryState extends State<ItemHistory> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  // Example user ID, replace it with the actual user ID
  String userID = AuthService.currentUser!.uid;

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
                'Item History',
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
            child: FutureBuilder(
              future: _fetchUserHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No item history found.'));
                } else {
                  // Display the fetched item history
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            var item = snapshot.data?[index];
                            return _buildItemCard(item!);
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          )),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUserHistory() async {
    try {
      // Fetch foundProductIds and lostProductIds from the Users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userID)
          .get();

      final foundProductIds =
          List<String>.from(userDoc['foundProductIds'] ?? []);
      final lostProductIds = List<String>.from(userDoc['lostProductIds'] ?? []);

      // Fetch details for each foundProductId and lostProductId
      List<Map<String, dynamic>> itemHistory = [];
      for (var foundProductId in foundProductIds) {
        var foundProductDoc = await FirebaseFirestore.instance
            .collection('FoundProduct')
            .doc(foundProductId)
            .get();

        if (foundProductDoc.exists) {
          itemHistory.add(foundProductDoc.data() as Map<String, dynamic>);
        }
      }

      for (var lostProductId in lostProductIds) {
        var lostProductDoc = await FirebaseFirestore.instance
            .collection('LostProduct')
            .doc(lostProductId)
            .get();

        if (lostProductDoc.exists) {
          itemHistory.add(lostProductDoc.data() as Map<String, dynamic>);
        }
      }

      // Sort itemHistory by date in descending order
      itemHistory.sort((a, b) =>
          (b['DateTime'] as Timestamp).compareTo(a['DateTime'] as Timestamp));

      return itemHistory;
    } catch (e) {
      print('Error fetching item history: $e');
      return [];
    }
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    // Customize this widget based on your UI design
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(item['FoundItem'] ?? item['Category'] ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item['LostItem'] ?? item['Category'] ?? 'Unknown'),
            Text(item['ItemLocation'] ?? 'Unknown location'),
            Text('Date: ${_formatDateTime(item['DateTime'] as Timestamp)}'),
          ],
        ),
        leading: Image.network(item['ImageURL'] ?? ''),
        // Add more details as needed
      ),
    );
  }

  String _formatDateTime(Timestamp timestamp) {
    // Format timestamp to a readable date format
    final dateTime = timestamp.toDate();
    final formatter = DateFormat('MMMM d, yyyy h:mm a');
    return formatter.format(dateTime);
  }
}
