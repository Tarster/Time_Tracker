import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/home/models/job.dart';
import 'package:time_tracker_final/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_final/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_final/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({required this.database, this.job});
  final Database database;
  final Job? job;
  static Future<void> show(BuildContext context,
      {required Database database, Job? job}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a different job name',
              defaultActionText: 'OK');
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(
            name: _name!,
            ratePerHour: _ratePerHour!,
            id: id,
          );
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation Failed', exception: e);
      }
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? "New Job" : "Edit Job"),
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            child: Text(
              'save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: _buildContext(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContext() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              initialValue: _name,
              validator: (value) =>
                  value!.isNotEmpty ? null : "Name can't be empty",
              onSaved: (value) => _name = value,
              decoration: InputDecoration(labelText: 'Job Name'),
            ),
            TextFormField(
              initialValue: _ratePerHour == null ? null : '$_ratePerHour',
              validator: (value) =>
                  value!.isNotEmpty ? null : "Rate per hour can't be empty",
              onSaved: (value) => _ratePerHour = int.parse(value ?? '0'),
              decoration: InputDecoration(labelText: 'Rate per hour'),
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
            ),
          ],
        ));
  }
}
