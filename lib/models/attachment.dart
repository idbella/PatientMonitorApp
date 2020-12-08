
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
class AttachFile{
	int		id;
	String	name;
	bool		downloaded = false;

	AttachFile(this.id,this.name);
	String url;
	static AttachFile  fromJson(var json)
	{
		AttachFile file = AttachFile(
			json['id'],
			json['file_name']
		);
		return file;
	}
}
class Attachment{
	int							id;
	int							type;
	String						title;
	User							user;
	DateTime						date;
	MedicalFile					medicalFile;
	List<AttachFile>			files;

	Attachment(this.id,this.title,this.date,this.type);

	static Attachment fromJson(var json)
	{
		int id = json['id'];
		Attachment attachment = Attachment(
			id,
			json['title'],
			DateTime.parse(json['creation_date']),
			json['type'],
		);

		attachment.files = List();
		(json['files'] as List<dynamic>).forEach((element) {
			int attachmentId = element['id'];
			AttachFile file = AttachFile.fromJson(element);
			attachment.files.add(file);
			file.url = Globals.url + '/api/download/$attachmentId';
		});
		return attachment;
	}
}
