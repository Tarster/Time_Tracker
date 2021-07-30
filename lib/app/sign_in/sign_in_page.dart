import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_final/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_final/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_final/services/auth.dart';

class SignInPage extends StatelessWidget {
  final AuthBase auth;

  const SignInPage({required this.auth});

  void _anonymousSignIn() async {
    try {
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  void _googleSignIn() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _emailSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EmailSignInPage(
                auth: auth,
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 5.0,
      ),
      body: _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 170.0, bottom: 50.0),
            child: Text(
              'Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          //Sign in with Google
          SocialSignInButton(
            text: 'Sign in with google',
            textColor: Colors.black87,
            buttonColor: Colors.white,
            onPressed: _googleSignIn,
            imageName: 'images/google-logo.png',
          ),

          //Facebook SignIn
          SocialSignInButton(
            text: 'Sign in with facebook',
            textColor: Colors.white,
            buttonColor: Color(0xFF334D92),
            onPressed: _facebookSignIn,
            imageName: 'images/facebook-logo.png',
          ),

          //Sign in with Email
          SignInButton(
            textColor: Colors.white,
            text: 'Sign in with email',
            buttonColor: Colors.teal[600]!,
            onPressed: () => _emailSignIn(context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              'or',
              style: TextStyle(fontSize: 14.0, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          //Go anonymous
          SignInButton(
            textColor: Colors.white,
            text: 'Go anonymous',
            buttonColor: Colors.yellow[900]!,
            onPressed: _anonymousSignIn,
          )
        ],
      ),
    );
  }
}

void _facebookSignIn() {
  //TODO: Implement facebook sign in here
}
