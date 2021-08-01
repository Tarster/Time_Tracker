import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:time_tracker_final/app/home/models/job.dart';
import 'package:time_tracker_final/services/api_path.dart';
import 'package:time_tracker_final/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job?>> jobsStream();
}

class FirestoreDatabase implements Database {
  //To get the user id when he/she is logging in the firebase_cloud
  final String uid;
  //Simple constructor for getting data
  FirestoreDatabase({required this.uid});

  final _service = FirestoreService.instance;

  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
      path: APIPaTH.jobs(uid), builder: (data) => Job.fromMap(data));

  //Method to write data to Firebase_Firestore (CREATE OPERATION)
  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPaTH.job(uid, 'job_abc'),
        data: job.toMap(),
      );
}
