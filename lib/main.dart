import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_final/app/landing_page.dart';

main() async{
  // This is done to make sure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  //Need to add everytime to actually initialize the firebase library
  //and pass it all the way to the down.
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LandingPage(),
        debugShowCheckedModeBanner: false,
    );
  }
}

