
import 'package:PatientMonitorMobileApp/models/user.dart';

class Nurse{

	User		user;

	static Nurse fromJson(Map<String, dynamic> json){ 
		Nurse nurse = Nurse();
		nurse.user = User(
			id:			json['id'],
			firstName:	json['first_name'],
			lastName:	json['last_name'],
			phone:		json['phone'],
			email:		json['email'],
			title:		json['title']
		);
		return nurse;
	}
}
