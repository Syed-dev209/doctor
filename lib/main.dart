import 'package:doctor/models/doctorDetails.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/service/pushNotificationService.dart';
import 'package:doctor/singIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotifications fcm=PushNotifications();
  fcm.initialize();
  runApp(
      MyApp()
  );
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>UserDetails(),),
        ChangeNotifierProvider(create: (context)=>DoctorDetails()),
        ChangeNotifierProvider(create: (context)=>ExerciseDescription())
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xff674cfb),
          accentColor: Colors.black
        ),
        home: SignIn(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
