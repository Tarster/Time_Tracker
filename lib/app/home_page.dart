import 'package:flutter/material.dart';
import 'package:time_tracker_final/services/auth.dart';

class HomePage extends StatelessWidget {

  final AuthBase auth;
  const HomePage({required this.auth,});
  //Sign Out method
  void _signOut() async {
    try {
      await auth.signOut();

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            onPressed: _signOut,
            child: Icon(
              Icons.logout,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}
