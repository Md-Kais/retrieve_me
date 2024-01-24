import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'image_model.dart';

// import 'address_model.dart';
const String collectionUser = 'Users';

const String userFieldId = 'userId';
const String userFieldFirstName = 'firstName';
const String userFieldlastName = 'lastName';
const String userFieldAddress = 'address';
const String userFieldCreationTime = 'CreationTime';
const String userFieldRating = 'rating';
const String userFieldProfession = 'profession';
const String userFieldContact = 'contactNo';
const String userFieldEmail = 'email';
const String userFieldThumbnail = 'thumbnail';

class UserModel {
  String userId;
  String firstName;
  String lastName;
  String address;
  Timestamp? userCreationTime;
  num? rating;
  String profession;
  String contactNo;
  String email;
  ImageModel thumbnailImage;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.address,
    this.userCreationTime,
    this.rating,
    required this.profession,
    required this.contactNo,
    required this.email,
    required this.thumbnailImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      userFieldId: userId,
      userFieldFirstName: firstName,
      userFieldlastName: lastName,
      userFieldAddress: address,
      userFieldCreationTime: userCreationTime,
      userFieldRating: rating,
      userFieldProfession: profession,
      userFieldContact: contactNo,
      userFieldEmail: email,
      userFieldThumbnail: thumbnailImage.toJson(), //
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        userId: map[userFieldId],
        firstName: map[userFieldFirstName],
        lastName: map[userFieldlastName],
        address: map[userFieldAddress],
        userCreationTime: map[userFieldCreationTime],
        rating: map[userFieldRating],
        profession: map[userFieldProfession],
        contactNo: map[userFieldContact],
        email: map[userFieldEmail],
        thumbnailImage: ImageModel.fromJson(map[userFieldThumbnail]),
      );
}
