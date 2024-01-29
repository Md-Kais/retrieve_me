import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retrieve_me/pages/ChatPageForPost.dart';

import '../auth/auth_services.dart';
// Import your ChatPage

class UserListPage extends StatefulWidget {
  final String productId;

  const UserListPage({Key? key, required this.productId}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: FutureBuilder(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No users found.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var user = snapshot.data?[index];
                return _buildUserCard(user!, context);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    try {
      // Fetch the list of user IDs associated with the product
      final productDoc = await FirebaseFirestore.instance
          .collection('UserMessage')
          .doc(widget.productId)
          .get();

      List<String> userIds =
      List<String>.from(productDoc['messageProductIds'] ?? []);

      List<Map<String, dynamic>> usersList = [];
      for (var userId in userIds) {
        var userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          usersList.add(userDoc.data() as Map<String, dynamic>);
        }
      }

      return usersList;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('${user['firstName']} ${user['lastName']}'),
        subtitle: Text(user['userId'] ?? 'Unknown'),
        onTap: () {
          _navigateToChatPage(user['userId']);
        },
      ),
    );
  }

  void _navigateToChatPage(String receiverId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPagePost(
          userId: AuthService.currentUser!.uid,
          postId: widget.productId,
          receiverId: receiverId,
        ),
      ),
    );
  }
}
