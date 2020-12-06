
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountType{
  int id;
  String title;
  AccountType(this.id, this.title);
}

class Globals {

	static String				url					= 'https://idbella.herokuapp.com';
	static List<User>			usersList			= List();
	static List<Patient>		patientsList;
	static List<Insurance>	insuarnces			= List();
	static List<Doctor>		doctors				= List();
	static int					adminId				= 1;
	static int					nurseId				= 3;
	static int					doctorId				= 2;
	static int					recepId				= 5;
	static int					patientId			= 4;
	static User					user					= User(title: '');
	static Color				backgroundColor	= Color.fromARGB(255, 0xd1,0xee,0xfe);
	static String				token;

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
		Requests.get(Globals.url + '/api/insurance').then((ResponseX response){
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
		Requests.get(Globals.url + '/api/doctors').then((ResponseX response){
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

	static storageSet(String key, String value) async {
   	SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   	await sharedPreferences.setString(key, value);
	}

	static Future<String> storageGet(String key) async {
		SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
		return sharedPreferences.getString(key);
	}

	static void showAlertDialog(BuildContext context, String title, String body) {

		Widget okButton = FlatButton(
			child: Text("Ok"),
			onPressed: () => Navigator.of(context).pop(),
		);

		AlertDialog alert = AlertDialog(
			title: Text(title),
			content: Text(body),
			actions: [
				okButton
			],
		);

		showDialog(
			context: context,
			builder: (BuildContext context) {
			return alert;
			},
		);
	}

}
