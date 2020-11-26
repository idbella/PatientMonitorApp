
import 'package:PatientMonitorMobileApp/views/Reception/ListPatients.dart';
import 'package:PatientMonitorMobileApp/views/Reception/addPatientExtra.dart';
import 'package:PatientMonitorMobileApp/views/Reception/viewPatient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:PatientMonitorMobileApp/views/LoginPage.dart';

import 'package:PatientMonitorMobileApp/views/Admin/AddUser.dart';
import 'package:PatientMonitorMobileApp/views/Admin/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Admin/EditUser.dart';

import 'package:PatientMonitorMobileApp/views/Reception/EditPatient.dart';
import 'package:PatientMonitorMobileApp/views/Reception/InsurancePage.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Reception/addPatient.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
      	DeviceOrientation.portraitUp,
      	DeviceOrientation.portraitDown
		]);
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
      initialRoute: 'login',
      routes: {
        'login' :(context) => LoginPage(title:'login Page'),
        'admin' :(context) => AdminHomePage(title: 'Admin',),
        'edit'  :(context) => EditUserPage(),
        'adduser':(context) => AddUserPage(),
        'recep' :(context) => RecepHomePage(),
        'addpatient':(context) => AddPatientPage(),
		  'addpatientextra':(context)=>AddPatientExtraPage(),
        'editpatient':(context) => EditPatientPage(),
		  'insurance':(context) => InsurancePage(),
		  'listpatients':(contect)=>ListPatientsPage(),
		  'viewpatient':(context)=>ViewPatientPage(),

      },
    );
  }
}