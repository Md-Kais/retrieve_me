import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retrieve_me/Components/chatservice.dart';

class ChatPage extends StatefulWidget {
  final String receiverID;
  final String productID;
  const ChatPage(
      {super.key, required this.receiverID, required this.productID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  late ChatService chatService;

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.productID);
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void messageSend() {
    if (messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
    }
  }

  // late String sender;
  // late String text;
  // late bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: chatService.getMessages(widget.receiverID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs[index];
                        final String currentUserID =
                            firebaseAuth.currentUser!.uid;
                        final bool isCurrentUser =
                            message['senderID'] == currentUserID;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['senderID'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(message['message']),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.attach_file),
                  ),
                  // FloatingActionButton(
                  //   onPressed: messageSend,
                  //   child: Icon(Icons.send),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ChatMessage extends StatelessWidget {
//   final String sender;
//   final String text;

//   ChatMessage({required this.sender, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 4.0),
//           Text(text),
//         ],
//       ),
//     );
//   }
// }
