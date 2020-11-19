
import 'package:PatientMonitorMobileApp/models/user.dart';

class Patient{

	Patient({this.id,this.cin,this.address,this.postalCode,this.sexe,this.city,this.country, this.userId});
	int     id;
	String  cin;
  String  address;
  bool    sexe;
  int     postalCode;
  String city;
  String country;
  int     userId;
  User    user;

	static Patient fromjson(Map<String, dynamic> json){
		Patient user = new Patient(
				id:json['id'] as int,
				cin: json['cin'] as String,
				sexe: json['sexe'] as bool,
				address:json['adress'] as String,
        city:json['city'] as String,
				country:json['country'] as String,
        postalCode: json['postalcode'],
        userId:json['userid']
			);
		return user;
	}
}
