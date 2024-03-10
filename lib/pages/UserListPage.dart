import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatPageForPost.dart';

class UserListPage extends StatelessWidget {
  final String productId;
  final String currentUserId;

  UserListPage({required this.productId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const SafeArea(
          child: Text(
            'Claimers',
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ProductClaim')
              .doc(productId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: Text(
                  'No message found',
                  style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Set the text size to 20
                    ),
                  ),
                ),
              );
            }

            var productClaimData = snapshot.data!.data() as Map<String, dynamic>?;

            if (productClaimData == null ||
                !productClaimData.containsKey('assertUsers')) {
              return Center(
                child: Text(
                  'No message found',
                  style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20, // Set the text size to 20
                    ),
                  ),
                ),
              );
            }

            List<String> assertUsers =
            List<String>.from(Set.from(productClaimData['assertUsers'] ?? []));

            return ListView.builder(
              itemCount: assertUsers.length,
              itemBuilder: (context, index) {
                return buildUserListTile(
                    context, assertUsers[index], productId, currentUserId);
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildUserListTile(BuildContext context, String userId,
      String productId, String currentUserId) {
    return ListTile(
      title: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }

          var userData = snapshot.data;
          String firstName = userData?['firstName'];
          String lastName = userData?['lastName'];
          String userName = '$firstName $lastName';

          return Text(
            userName,
            style: GoogleFonts.oswald(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20, // Set the text size to 20
              ),
            ),
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPagePost(
              receiverId: userId,
              postId: productId,
              userId: currentUserId,
            ),
          ),
        );
      },
    );
  }
}
