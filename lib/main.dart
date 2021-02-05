
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/Allergy.dart';
import 'package:PatientMonitorMobileApp/views/Calendar.dart';
import 'package:PatientMonitorMobileApp/views/Factor.dart';
import 'package:PatientMonitorMobileApp/views/Profile.dart';
import 'package:PatientMonitorMobileApp/views/Reception/AddMedicalFile.dart';
import 'package:PatientMonitorMobileApp/views/Reception/ChirurgList.dart';
import 'package:PatientMonitorMobileApp/views/Reception/EditMedicalFile.dart';
import 'package:PatientMonitorMobileApp/views/Reception/ListPatients.dart';
import 'package:PatientMonitorMobileApp/views/Reception/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/views/Reception/MedicalList.dart';
import 'package:PatientMonitorMobileApp/views/Reception/Staff.dart';
import 'package:PatientMonitorMobileApp/views/Reception/addPatientExtra.dart';
import 'package:PatientMonitorMobileApp/views/Reception/viewPatient.dart';
import 'package:PatientMonitorMobileApp/views/doctor/AddNote.dart';
import 'package:PatientMonitorMobileApp/views/doctor/AddNurseNote.dart';
import 'package:PatientMonitorMobileApp/views/doctor/DoctorHomePage.dart';
import 'package:PatientMonitorMobileApp/views/doctor/EditMedicalFile.dart';
import 'package:PatientMonitorMobileApp/views/doctor/EditNote.dart';
import 'package:PatientMonitorMobileApp/views/doctor/ViewAttachments.dart';
import 'package:PatientMonitorMobileApp/views/doctor/ViewNotes.dart';
import 'package:PatientMonitorMobileApp/views/doctor/ViewNurseNotes.dart';
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
	// Globals.url = 'http://192.168.42.179:8080';
	// Globals.url = 'http://10.30.248.2:8080';
	runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
      title: 'Patient Monitor',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'login',
      routes: {
			'calendar'			:(context) => AppointmentsView(),
			'login'				:(context) => LoginPage(),
			'admin' 				:(context) => AdminHomePage(),
			'edit'  				:(context) => EditUserPage(),
			'adduser'			:(context) => AddUserPage(),
			'recep' 				:(context) => RecepHomePage(),
			'addpatient'		:(context) => AddPatientPage(),
			'addpatientextra'	:(context) => AddPatientExtraPage(),
			'editpatient'		:(context) => EditPatientPage(),
			'insurance'			:(context) => InsurancePage(),
			'listpatients'		:(contect) => ListPatientsPage(),
			'viewpatient'		:(context) => ViewPatientPage(),
			'editfile'			:(context) => EditMedicalFile(),
			'doctor'				:(context) => DoctorHomePage(),
			'viewfile'			:(context) => ViewMedicalFile(),
			'viewnotes'			:(context) => ViewNotes(),
			'addnote'			:(context) => AddNote(),
			'addfile'			:(context) => AddMedicalFilePage(),
			'viewattachments' :(context) => ViewAttachments(),
			'editnote'			:(context) => EditNote(),
			'profile'			:(context) => Profile(),
			'staff'				:(context) => StaffPage(),
			'medicalFile'		:(context) => MedicalFilePage(),
			'allergy'			:(context) => AllergyPage(),
			'factor'				:(context) => FactorPage(),
			'medical'			:(context) => MedicalListPage(),
			'chirurgical'		:(context) => ChirurgicalListPage(),
			'nurseNotes'		:(context) => ViewNurseNotes(),
			'addNurseNote'		:(context) => AddNurseNote(),
      },
    );
  }
}
