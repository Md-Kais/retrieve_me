import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignInAccount? googleUser = GoogleSignIn().currentUser;
  static User? get currentUser => _auth.currentUser;
  static Future<User> loginAdmin(String email, String password) async {
    final credintial = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return credintial.user!;
  }

  static Future<User> signInWithGoogle() async {
    try {
      googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return result.user!;
    } on Exception catch (e) {
      print(
          '--------------------------------------------------------------------$e--------------------------------------------------------------------');
      // TODO
      return e as User;
    }
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();

      return await FirebaseAuth.instance.signInWithProvider(githubProvider);
    } on Exception catch (e) {
      // TODO
      return e as UserCredential;
    }
  }

  static Future<User> registerUser(
      String email, String password, String contactNumber) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user!;
  }

  static Future<void> logout() async {
    await GoogleSignIn().signOut();
    return _auth.signOut();
  }
}
