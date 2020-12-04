
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';

class Note{
	int							id;
	String						note;
	User							user;
	DateTime						date;
	MedicalFile					medicalFile;
	int							permissions;

	Note(this.id,this.note,this.date,this.permissions);

	static Note fromJson(var json)
	{
		Note note = Note(
			json['id'],
			json['notes'],
			DateTime.parse(json['date']),
			json['permissions']
		);
		return note;
	}
}
