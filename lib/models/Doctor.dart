
import 'package:PatientMonitorMobileApp/models/user.dart';

class Doctor{

	User		user;

	static Doctor fromJson(Map<String, dynamic> json){ 
		Doctor doctor = Doctor();
		doctor.user = User(
			id:			json['id'],
			firstName:	json['first_name'],
			lastName:	json['last_name'],
			phone:		json['phone'],
			email:		json['email'],
			title:		json['title']
		);
		return doctor;
	}
}
