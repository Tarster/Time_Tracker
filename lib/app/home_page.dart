import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';

class HomePage extends StatelessWidget {

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
    );
    if(didRequestSignOut == null)
      {

      }
    else if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            onPressed: () => _confirmSignOut(context),
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
