import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retrieve_me/model/UserModel.dart';
import 'package:retrieve_me/pages/ChatPageForPost.dart';

import '../auth/auth_services.dart';

class UserListPage extends StatefulWidget {
  final String postId;

  const UserListPage({Key? key, required this.postId}) : super(key: key);

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    super.initState();
    _usersStream = _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _usersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No users found.'),
            );
          } else {
            print('Snapshot data:');
            snapshot.data!.docs.forEach((doc) {
              print(doc.data());
            });

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {

                final userDoc = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                final UserModel user = UserModel.fromMap(userDoc);
                return _buildUserCard(user, context);
              },
            );
          }
        },
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _fetchUsers() {
    print('66');
    Future<void> getUserCollectionInfo() async {
      try {
        QuerySnapshot<Map<String, dynamic>> userCollectionSnapshot = await FirebaseFirestore.instance
            .collection('UserChats')
            .doc(widget.postId)
            .collection('Users')
            .get();

        // Access individual documents in the collection
        userCollectionSnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> document) {
          print('Document ID: ${document.id}');
          // print('Document Data: ${document.data()}');
        });
      } catch (e) {
        print('Error getting user collection info: $e');
      }
    }
    getUserCollectionInfo();
    print('67');

    return FirebaseFirestore.instance
        .collection('UserChats')
        .doc(widget.postId)
        .collection('Users')
        .snapshots();
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.userId ?? 'Unknown'),
        onTap: () {
          _navigateToChatPage(user.userId);
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
          postId: widget.postId,
          receiverId: receiverId,
        ),
      ),
    );
  }
}
