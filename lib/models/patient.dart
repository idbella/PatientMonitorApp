
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';

class Patient{

	Patient({this.id,this.cin,this.address,this.postalCode,this.sexe,this.city,this.country, this.userId, String birthday}){
    this.birthdate = DateTime.parse(birthday);
  }

	int     id;
	String  cin;
  String  address;
  int    sexe;
  String  postalCode;
  String  city;
  String  country;
  int     userId;
  User    user;
  DateTime birthdate;

	static Patient fromjson(Map<String, dynamic> json){ 
		Patient patient = new Patient(
				id:json['patientid'] as int,
				cin: json['cin'].toString(),
				sexe: json['sexe'],
				address:json['adress'].toString(),
        city:json['city'].toString(),
				country:json['country'].toString(),
        postalCode: json['postalcode'].toString(),
        userId:json['userid'],
        birthday: json['birthday'].toString()
			);
    patient.user = User(
      role: Globals.patientId,
      phone: json['phone'],
      id:json['userid'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      );
		return patient;

	}
}
