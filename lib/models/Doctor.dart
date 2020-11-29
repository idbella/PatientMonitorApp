
import 'package:PatientMonitorMobileApp/models/user.dart';

class Doctor{

	Doctor({this.id,this.speciality});

	User		user;
	int		id;
	String	speciality;

	static Doctor fromJson(Map<String, dynamic> json){ 
		Doctor doctor = Doctor(
			id:json['id'],
			speciality: json['speciality']
		);
		doctor.user = User(
			firstName: json['first_name'],
			lastName: json['last_name'],
			phone: json['phone'],
			email: json['email']
		);
		return doctor;
	}
}
