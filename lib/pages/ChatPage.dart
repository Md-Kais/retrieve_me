import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatScreen.dart';

class ChatPage extends StatelessWidget {
  final String userId;
  final String postId;
  final String receiverId;
  ChatPage(
      {required this.userId, required this.postId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blue.shade600,
            size: 30,
          ),
          title: const Text(
            'Chat Page',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
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
          child: ChatScreen(
            userId: userId,
            postId: postId,
            receiverId: receiverId,
          ),
        ));
  }
}
//recieverId
