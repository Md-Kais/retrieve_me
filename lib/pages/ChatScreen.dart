import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retrieve_me/auth/auth_services.dart';

import '../model/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String postId;
  final String receiverId;

  ChatScreen({required this.userId, required this.postId, required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserMessage')
                .doc(widget.postId)
                .collection(widget.userId)
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<Chat> messages = snapshot.data!.docs
                  .map((doc) => Chat(
                senderId: doc['senderId'],
                receiverId: doc['receiverId'],
                message: doc['message'],
                timestamp: doc['timestamp'],
              ))
                  .toList();

              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    bool isCurrentUser = AuthService.currentUser!.uid == messages[index].senderId;

                    return Align(
                      alignment: isCurrentUser ? Alignment.topRight : Alignment
                          .topLeft,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: isCurrentUser ? Radius.circular(20) : Radius.zero,
                            topLeft: isCurrentUser ? Radius.zero : Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          messages[index].message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: Colors.white), // Set hint text color
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set border color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Set border color when focused
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.brown.shade900),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageText = _messageController.text.trim();

    if (messageText.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('UserMessage')
          .doc(widget.postId)
          .collection(widget.userId)
          .add({
        'senderId': widget.userId,
        'receiverId': widget.receiverId,
        'message': messageText,
        'timestamp': Timestamp.now(),
      });

      // Clear the input field
      _messageController.clear();
    }
  }
}
