import 'package:time_tracker_final/app/home/models/job.dart';
import 'package:time_tracker_final/services/api_path.dart';
import 'package:time_tracker_final/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job?>> jobsStream();
}

//Method to get current DateTime and convert it to human readable form
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  //To get the user id when he/she is logging in the firebase_cloud
  final String uid;
  //Simple constructor for getting data
  FirestoreDatabase({required this.uid});

  final _service = FirestoreService.instance;

  @override
  Stream<List<Job?>> jobsStream() => _service.collectionStream(
      path: APIPaTH.jobs(uid),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  //Method to write data to Firebase_Firestore (CREATE OPERATION)
  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPaTH.job(uid, job.id),
        data: job.toMap(),
      );
}
