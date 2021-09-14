import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/common_widgets/avatar.dart';
import 'package:time_tracker_final/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';

class AccountPage extends StatelessWidget {
  //const AccountPage({Key? key}) : super(key: key);

  //Sign Out method
  void _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(
          context,
          title: 'Logout',
          content: 'Are you sure that you want to logout?',
          defaultActionText: 'Logout',
          cancelActionText: 'Cancel',
        ) ??
        false;
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
            child: Icon(
              Icons.logout,
              color: Colors.white70,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: _buildUserInfo(auth.currentUser),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User? currentUser) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Avatar(
            radius: 50,
            photoUrl: currentUser!.photoURL,
          ),
        ),
        if (currentUser.displayName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              currentUser.displayName!,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          )
      ],
    );
  }
}
