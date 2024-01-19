import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retrieve_me/db/db_helper.dart';

import '../auth/auth_services.dart';
import '../model/UserModel.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;
  // Future<void> addUser(User user) async{
  //   try {
  //     final userModel = UserModel(
  //       userId: user.uid,
  //       email: user.email!,
  //       displayName: user.displayName!,
  //       userCreationTime: Timestamp.fromDate(DateTime.now()),
  //       address: user.!,
  //       profession: user.photoURL!,
  //       contactNo: '01912345667',
  //
  //     );
  //     await db_helper.addUser(userModel);
  //   }
  //   catch(error){
  //     print('Error adding user to Firestore: $error');
  //     // Handle error accordingly
  //   }
  // }

  getUserInfo() {
    db_helper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }
    });
  }

  Future<bool> doesUserExist(String uid) => db_helper.doesUserExist(uid);
}