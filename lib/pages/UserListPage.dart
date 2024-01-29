import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/UserModel.dart';

class UserListPage extends StatelessWidget {
  final String productId;

  const UserListPage({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receiver List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Use a collection group query to fetch messages across subcollections
        stream: FirebaseFirestore.instance
            .collectionGroup('UserMessage')
            .where('postId', isEqualTo: productId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No data found.');
          } else {
            final receiverIds = snapshot.data!.docs
                .map((doc) => doc.reference.parent.parent?.id)
                .toSet(); // Get unique collection names (receiver IDs)

            return ListView.builder(
              itemCount: receiverIds.length,
              itemBuilder: (context, index) {
                final receiverId = receiverIds.elementAt(index);
                return ListTile(
                  title: Text(receiverId!),
                  // Add more UI elements as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
