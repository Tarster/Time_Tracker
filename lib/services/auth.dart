import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final _firebaseAuth = FirebaseAuth.instance;
  //variable to store the current User
  User? get currentUser => _firebaseAuth.currentUser;

  //Function to sign in Anonymously
  Future<User?> signInAnonymously() async{
    //Function call to return the user credential
    final userCredential = await _firebaseAuth.signInAnonymously();
    //Return the user variable
    return userCredential.user;
  }

  //Function for signing out
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}