
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';

class Attachment{
	int							id;
	int							type;
	String						title;
	String						fileName;
	User							user;
	DateTime						date;
	MedicalFile					medicalFile;

	Attachment(this.id,this.title,this.date,this.type,this.fileName);

	static Attachment fromJson(var json)
	{
		Attachment note = Attachment(
			json['id'],
			json['title'],
			DateTime.parse(json['creation_date']),
			json['type'],
			json['file_name']
		);
		return note;
	}
}
