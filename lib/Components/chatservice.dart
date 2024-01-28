import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retrieve_me/model/message.dart';

class ChatService extends ChangeNotifier {
  final String productID;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ChatService(this.productID);

  Future<void> sendMessage(String receivedID, String message) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    Message chatMessage = Message(
        productID: productID,
        senderID: currentUserID,
        receiverID: receivedID,
        timestamp: timestamp,
        message: message);

    List<String> ids = [currentUserID, receivedID];
    ids.sort();
    String chatRoomID = ids.join('_');
    await FirebaseFirestore.instance
        .collection('UserMessage')
        .doc(chatRoomID)
        .collection(receivedID)
        .doc(timestamp)
        .set(chatMessage.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String receivedID) {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    List<String> ids = [currentUserID, receivedID];
    ids.sort();
    String chatRoomID = ids.join('_');
    return FirebaseFirestore.instance
        .collection('UserMessage')
        .doc(chatRoomID)
        .collection(receivedID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
