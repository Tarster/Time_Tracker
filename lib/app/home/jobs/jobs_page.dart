import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_final/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_final/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_final/app/home/models/job.dart';
import 'package:time_tracker_final/common_widgets/show_alert_dialog.dart';
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
        onPressed: () => EditJobPage.show(context),
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
            final children = jobs!
                .map((job) => JobListTile(
                      job: job!,
                      onTap: () => EditJobPage.show(context, job: job),
                    ))
                .toList();
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