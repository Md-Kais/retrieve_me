import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatScreenPost.dart';

class ChatPagePost extends StatelessWidget {
  final String userId;
  final String postId;
  final String receiverId;
  ChatPagePost(
      {required this.userId, required this.postId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          title: const SafeArea(
            child: Text(
              'Chatting...',
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
                Color.fromARGB(255, 5, 63, 111)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ChatScreenPost(
              userId: userId, postId: postId, receiverId: receiverId),
        ));
  }
}
