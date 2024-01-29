import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retrieve_me/auth/auth_services.dart';

import '../model/chat_model.dart';

class ChatScreenPost extends StatefulWidget {
  final String userId;
  final String postId;
  final String receiverId;
  const ChatScreenPost(
      {required this.userId, required this.postId, required this.receiverId});

  @override
  _ChatScreenPostState createState() => _ChatScreenPostState();
}

class _ChatScreenPostState extends State<ChatScreenPost> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('UserChats')
                .doc(widget.postId)
                .collection('Users')
                .doc(widget.receiverId)
                .collection('Messages')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
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

              return Align(
                alignment: (AuthService.currentUser!.uid == widget.userId
                    ? Alignment.centerLeft
                    : Alignment.centerRight),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Container(
                        padding: const EdgeInsets.only(
                            left: 18, top: 18, bottom: 18),
                        decoration: BoxDecoration(
                          color: AuthService.currentUser!.uid == widget.userId
                              ? Colors.blue.shade600
                              : Color.fromARGB(255, 61, 184, 116),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Text(messages[index].message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            )),
                        // Add other UI elements for the message
                      ));
                    },
                  ),
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
              decoration: const InputDecoration(
                hintText: 'Type a message...',
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
          .collection('UserChats')
          .doc(widget.postId)
          .collection('Users')
          .doc(widget.receiverId)
          .collection('Messages')
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
