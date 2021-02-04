
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';

class Patient{

	Patient({this.id,this.cin,this.address,this.postalCode,this.sexe,
	this.city,this.country, this.userId, String birthday,
	this.dia,this.tab,this.obe,this.hta}){
    this.birthdate = DateTime.parse(birthday);
  }

	int		id;
	String 	cin;
	String	address;
	int		sexe;
	String	postalCode;
	String	city;
	String	country;
	int		userId;
	User		user;
	DateTime	birthdate;
	String	tab;
	String	dia;
	String	hta;
	String	obe;

	static Patient fromjson(Map<String, dynamic> json){ 
		Patient patient = new Patient(
			id:json['patientid'] as int,
			cin: json['cin'].toString(),
			sexe: json['sexe'],
			address:json['address'].toString(),
			city:json['city'].toString(),
			country:json['country'].toString(),
			postalCode: json['postalcode'].toString(),
			userId:json['userid'],
			birthday: json['birthday'].toString(),
			obe: json['obe'],
			hta: json['hta'],
			tab: json['tab'],
			dia: json['dia']
		);
   	patient.user = User(
			role: Globals.patientId,
			phone: json['phone'],
			id:json['userid'],
			email: json['email'],
			firstName: json['first_name'],
			lastName: json['last_name'],
			title: json['title']
      );
		return patient;
	}
}
