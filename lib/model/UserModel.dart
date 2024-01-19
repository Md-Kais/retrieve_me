import 'package:cloud_firestore/cloud_firestore.dart';

// import 'address_model.dart';
const String collectionUser='Users';

const String userFieldId='userId';
const String userFieldFirstName='firstName';
const String  userFieldAddress = 'address';
const String userFieldCreationTime='CreationTime';
const String userFieldRating='rating';
const String userFieldProfession='profession';
const String userFieldContact ='contactNo';
const String userFieldEmail='email';

class UserModel{
  String userId;
  String firstName;
  String address;
  Timestamp? userCreationTime;
  String? rating;
  String profession;
  String contactNo;
  String email;

  UserModel({
    required this.userId,
    required this.firstName,
    required this.address,
    this.userCreationTime,
    this.rating,
    required this.profession,
    required this.contactNo,
    required this.email
  });


  Map<String,dynamic>toMap(){
    return <String,dynamic>{
      userFieldId:userId,
      userFieldFirstName:firstName,
      userFieldAddress:address,
      userFieldCreationTime:userCreationTime,
      userFieldRating: rating,
      userFieldProfession: profession,
      userFieldContact: contactNo,
      userFieldEmail:email,
    };
  }
  factory UserModel.fromMap(Map<String,dynamic>map)=>UserModel(
    userId: map[userFieldId],
    firstName: map[userFieldFirstName],
    address: map[userFieldAddress] ,
    userCreationTime: map[userFieldCreationTime],
    rating: map[userFieldRating],
    profession: map[userFieldProfession],
    contactNo: map[userFieldContact],
    email: map[userFieldEmail],
  );
}