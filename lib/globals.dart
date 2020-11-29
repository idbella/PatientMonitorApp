
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:requests/requests.dart';

class AccountType{
  int id;
  String title;
  AccountType(this.id, this.title);
}

class Globals {

	static String				url					= 'http://172.16.176.200:8080';
	static List<User>			usersList			= List();
	static List<Patient>		patientsList;
	static List<Insurance>	insuarnces			= List();
	static List<Doctor>		doctors				= List();
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

	static void getInsurances({Function callback})
	{
		if (Globals.insuarnces.isNotEmpty)
			return ;
		Requests.get(Globals.url + '/api/insurance').then((Response response){
			print('insyrance : ' + response.content().toString());
			if (response.statusCode == 200)
			{
				List<dynamic> list = response.json();
				list.forEach((json) { 
					Globals.insuarnces.add(Insurance.fromJson(json));
				});
				if (callback != null)
					callback();
			}
			else
				print('error ' + response.content().toString());
		});
	}

	static void getDoctors({Function callback})
	{
		if (Globals.insuarnces.isNotEmpty)
			return ;
		Requests.get(Globals.url + '/api/doctors').then((Response response){
			print('doctors : ' + response.content().toString());
			if (response.statusCode == 200)
			{
				List<dynamic> list = response.json();
				list.forEach((json) {
					doctors.add(Doctor.fromJson(json));
				});
				if (callback != null)
					callback();
			}
			else
				print('error ' + response.content().toString());
		});
	}

	static void init()
	{
		getInsurances();
		getDoctors();
	}
}
