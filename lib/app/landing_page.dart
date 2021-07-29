import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/home_page.dart';
import 'package:time_tracker_final/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_final/services/auth.dart';

class LandingPage extends StatelessWidget {
  final AuthBase auth;
  const LandingPage({required this.auth});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        //Check for the connection state if it's active or not
        if (snapshot.connectionState == ConnectionState.active) {
          //getting the data from the stream
          final User? user = snapshot.data;
          // If there is no user currently available just send user to signIn page
          if (user == null) {
            return SignInPage(
              auth: auth,
            );
          }
          // If there is a active user just send it to HomeScreen
          return HomePage(
            auth: auth,
          );
        }
        // If connection is not true just return a container
        else
          return Container();
      },
    );
  }
}
