import 'package:PatientMonitorMobileApp/views/AddUser.dart';
import 'package:flutter/material.dart';
import 'views/LoginPage.dart';
import 'views/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/Splash.dart';
import 'package:PatientMonitorMobileApp/views/EditUser.dart';
import 'package:PatientMonitorMobileApp/views/RecepHomePage.dart';

void main() {
  Globals.url = 'http://10.30.248.2:8080';//'https://idbella.herokuapp.com';
  Globals.logged = false;
  Globals.data = null;
  Globals.usersList = List();
  Globals.patientsList = List();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Patient Monior',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'splash',
      routes: {
        'login' :(context) => LoginPage(title:'login Page'),
        'admin' :(context) => AdminHomePage(title: 'Admin',),
        'splash':(context) => SplashPage(),
        'edit'  :(context) => EditUserPage(),
        'add'   :(context) => AddUserPage(),
        'recep' :(context) => RecepHomePage()
      },
    );
  }
}
