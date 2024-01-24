import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:retrieve_me/db/db_helper.dart';

import '../auth/auth_services.dart';
import '../model/UserModel.dart';
import '../model/image_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;


  // Future<void> addUser(User user,firstName,lastName,address,contactNumber)
  // async{
  //   try {
  //     final userModel = UserModel(
  //       userId: user.uid,
  //       email: user.email!,
  //       firstName : firstName,
  //       lastName: lastName,
  //       userCreationTime: Timestamp.fromDate(DateTime.now()),
  //       address: address,
  //       profession: 'Student',
  //       contactNo: contactNumber,
  //
  //     );
  //     await db_helper.addUser(userModel);
  //
  //   }
  //   catch(error){
  //     print('Error adding user to Firestore: $error');
  //     // Handle error accordingly
  //   }
  //
  // }
  List<UserModel> userList = [];

  getAllUsers() {
    db_helper.getAllUsers().listen((event) {
      userList = List.generate(event.docs.length, (index) =>
          UserModel.fromMap(event.docs[index].data()));
      print(userList.length);
      notifyListeners();
    });
  }

  getUserInfo() {
    db_helper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      if(snapshot.exists) {
        userModel = UserModel.fromMap(snapshot.data()!);
        notifyListeners();
      }

    });
  }
  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
    const String imageDirectory = 'Users/';
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('$imageDirectory$imageName');
    final uploadTask = photoRef.putFile(File(imageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return ImageModel(
      imageName: imageName,
      downloadUrl: url,
      directoryName: imageDirectory,
    );
  }
  Future<bool> doesUserExist(String uid) => db_helper.doesUserExist(uid);
}