
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/Note.dart';
import 'package:PatientMonitorMobileApp/models/Nurse.dart';
import 'package:PatientMonitorMobileApp/models/attachment.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';

class MedicalFile{

	Patient		patient;
	int			id;
	String 		title;
	String		motif;
	DateTime		creationDate;
	int			insuranceType;
	String		insurance;
	Doctor		doctor;
	List<Note>	notes;
	List<Attachment>	attachments;
	List<Nurse> nurses;

	MedicalFile({
		this.id,
		this.title,
		this.motif,
		this.creationDate,
		this.insurance,
		this.insuranceType,
		this.doctor,
		this.patient
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

