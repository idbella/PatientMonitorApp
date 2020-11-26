
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';

class AccountType{
  int id;
  String title;
  AccountType(this.id, this.title);
}

class Globals {

	static String				url					= 'http://172.16.177.126:8080';
	static List<User>			usersList			= List();
	static List<Patient>		patientsList		= List();
	static List<Insurance>	insuarnces			= List();
	static int					adminId				= 1;
	static int					nurseId				= 3;
	static int					doctorId				= 2;
	static int					recepId				= 5;
	static int					patientId			= 4;
	static User					user					= User();
	static Color				backgroundColor	= Color.fromARGB(255, 0xd1,0xee,0xfe);

	static List<AccountType> accountTypes = List.from(
		[
			AccountType(2,'doctor'),
			AccountType(3,'nurse'),
			AccountType(5,'receptionist'),
		]
	);
}
