import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/home/models/job.dart';
import 'package:time_tracker_final/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_final/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_final/services/auth.dart';
import 'package:time_tracker_final/services/database.dart';

class JobsPage extends StatelessWidget {
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

//***********************************DBMS OPERATIONS**************************************************
  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job?>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs!.map((job) => Text(job!.name)).toList();
            return ListView(
              children: children,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occurred'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
