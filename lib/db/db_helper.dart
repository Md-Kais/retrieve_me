import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/UserModel.dart';

class db_helper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final String adminCollection = 'Admins';

  // static fiinal String collectionUser = 'Users';
  static Future<bool> isAdmin(String uid) async {
    final snapshot = await _db.collection(adminCollection).doc(uid).get();
    return snapshot.exists;
  }

  static Future<void> addUser(UserModel userModel) {
    print(userModel.email);
    return _db
        .collection(collectionUser).add(userModel.toMap());
  }

  static Future<bool> doesUserExist(String uid) async {
    final snapshot = await _db.collection(collectionUser).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      String uid) {
    return _db.collection(collectionUser).doc(uid).snapshots();
  }
}
