import 'package:PatientMonitorMobileApp/views/AddUser.dart';
import 'package:PatientMonitorMobileApp/views/EditPatient.dart';
import 'package:PatientMonitorMobileApp/views/addPatient.dart';
import 'package:flutter/material.dart';
import 'views/LoginPage.dart';
import 'views/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Splash.dart';
import 'package:PatientMonitorMobileApp/views/EditUser.dart';
import 'package:PatientMonitorMobileApp/views/RecepHomePage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr'),
        const Locale('ar'),
      ],
      debugShowCheckedModeBanner: false,
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
        'adduser':(context) => AddUserPage(),
        'recep' :(context) => RecepHomePage(),
        'addpatient':(context)=> AddPatientPage(),
        'editpatient':(context)=> EditPatientPage()
      },
    );
  }
}
