import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Chat({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}
