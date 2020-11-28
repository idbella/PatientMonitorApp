
import 'package:PatientMonitorMobileApp/models/user.dart';

class MedicalFile{

	int			id;
	String 		title;
	String		motif;
	DateTime		creationDate;
	int			insuranceType;
	String		insurance;
	User			doctor;

	MedicalFile({
		this.id,
		this.title,
		this.motif,
		this.creationDate,
		this.insurance,
		this.insuranceType,
		this.doctor
	});
	
	static MedicalFile fromjson(Map<String, dynamic> json){
		MedicalFile file = MedicalFile(
			id:json['id'],
			title: json['title'],
			motif: json['motif'],
			creationDate: DateTime.parse(json['creation_date']),
			insuranceType: json['insurance_type'],
			insurance: json['insurance']
		);
		return file;
	}
}

