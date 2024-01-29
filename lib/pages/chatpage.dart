// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:retrieve_me/auth/auth_services.dart';
// import 'package:retrieve_me/pages/chat_message.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   User user = AuthService.currentUser!;
//   ChatUser currentuser = ChatUser(
//     id: AuthService.currentUser!.uid,
//     firstName: AuthService.currentUser!.displayName,
//   );

//   ChatUser otheruser = ChatUser(
//     id: ds['UserID'],
//     firstName: ds['FullName'],
//   );

//   List<ChatMessage> messages = <ChatMessage>[];
//   List<ChatUser> typing = <ChatUser>[];

//   getData(ChatMessage m) {
//     setState(() {
//       messages.add(m);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: DashChat(
//             currentUser: currentuser, onSend: (ChatMessage m){setState(() {
//               messages.add(m)
//             });}, messages: messages));
//   }
// }
