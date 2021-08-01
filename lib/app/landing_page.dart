import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/home/jobs_page.dart';
import 'package:time_tracker_final/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_final/services/auth.dart';
import 'package:time_tracker_final/services/database.dart';

class LandingPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final auth  =Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        //Check for the connection state if it's active or not
        if (snapshot.connectionState == ConnectionState.active) {
          //getting the data from the stream
          final User? user = snapshot.data;
          // If there is no user currently available just send user to signIn page
          if (user == null) {
            return SignInPage.create(context);
          }
          // If there is a active user just send it to HomeScreen
          return Provider<Database>(
              create: (_)=> FirestoreDatabase(uid: user.uid),
              child: JobsPage());
        }
        // If connection is not true just return a container
        else
          return Container();
      },
    );
  }
}
