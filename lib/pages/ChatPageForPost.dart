import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ChatScreenPost.dart';

class ChatPagePost extends StatelessWidget {
  final String userId;
  final String postId;
  final String receiverId;
  ChatPagePost({required this.userId, required this.postId, required this
      .receiverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: ChatScreenPost(userId: userId, postId: postId, receiverId:
      receiverId),
    );
  }
}
