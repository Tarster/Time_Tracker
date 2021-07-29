import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymously();
  Future<void> signOut();
  Future<User?> signInWithGoogle();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  //Stream for checking if the which state our user have currently now.
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  //variable to store the current User
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  //Function to sign in Anonymously
  @override
  Future<User?> signInAnonymously() async {
    //Function call to return the user credential
    final userCredential = await _firebaseAuth.signInAnonymously();
    //Return the user variable
    return userCredential.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    //Getting the google user from here
    final googleUser = await GoogleSignIn().signIn();
    //Checking if the value is not null
    if (googleUser != null) {
      //Creating authentication object here
      final googleAuth = await googleUser.authentication;
      //Checking if ID_TOKEN is null or not
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return userCredential.user;
      }
      else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID token',
        );
    }  }
      else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  //Function for signing out
  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
