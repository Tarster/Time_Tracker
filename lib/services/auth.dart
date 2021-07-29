import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase{
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<void> signOut();
}

class Auth implements AuthBase{
  final _firebaseAuth = FirebaseAuth.instance;

  //Stream for checking if the which state our user have currently now.
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  //variable to store the current User
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  //Function to sign in Anonymously
  @override
  Future<User?> signInAnonymously() async{
    //Function call to return the user credential
    final userCredential = await _firebaseAuth.signInAnonymously();
    //Return the user variable
    return userCredential.user;
  }

  //Function for signing out
  @override
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}