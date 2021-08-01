import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_final/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_final/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_final/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_final/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';

class SignInPage extends StatelessWidget {
  final SignInManager manager;
  final bool isLoading;
  const SignInPage({required this.manager, required this.isLoading});

  // Trick to get dependency while starting the widget
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) => SignInPage(
              manager: manager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    //If user aborted the sign in process don't show any exception
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    //else just blast it on the screen
    showExceptionAlertDialog(context,
        title: 'Sign in Failed', exception: exception);
  }

  void _googleSignIn(BuildContext context) async {
    try {
      manager.signInWithGoogle();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    }
  }

  void _emailSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EmailSignInPage(), fullscreenDialog: true),
    );
  }

  void _anonymousSignIn(BuildContext context) async {
    try {
      manager.signInAnonymously();
    } on FirebaseException catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Time Tracker'),
          elevation: 5.0,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buildContainer(context));
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
            onPressed: () => _googleSignIn(context),
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
            onPressed: () => _anonymousSignIn(context),
          )
        ],
      ),
    );
  }
}

void _facebookSignIn() {
  //TODO: Implement facebook sign in here
}
