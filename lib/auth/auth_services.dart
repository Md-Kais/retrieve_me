
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retrieve_me/db/db_helper.dart';

class AuthService{
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User ? get currentUser => _auth.currentUser;
  static Future<User> loginAdmin(String email,String password) async{
    final credintial = await _auth.signInWithEmailAndPassword(email: email, password: password);

    return credintial.user!;
  }




  static Future<User> registerUser(String email, String password, String contactNumber) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return credential.user!;
  }

  static Future<void> logout(){
    return _auth.signOut();
  }
}