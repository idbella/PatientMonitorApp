
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/Note.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class NurseNotesListView extends StatefulWidget {
	final Patient		patient;

	NurseNotesListView(this.patient, {Key key}) : super(key: key);
	@override
	State<StatefulWidget> createState() => NurseNotesListViewState(patient);
}
  
class NurseNotesListViewState  extends State<NurseNotesListView>{
	
	List<Note>			notes;
	final Patient		patient;
	MedicalFile			medicalFile = MedicalFile();

	NurseNotesListViewState(this.patient);

	void getNotes()
	{
		String url = Globals.url + '/api/patient/' + patient.id.toString() + '/notes';
		Requests.get(url)
			.then((response) {
				medicalFile.notes = List();
				if (response.statusCode == 200)
				{
					List<dynamic> list = response.json();
					
					if (list.isNotEmpty)
					{
						list.forEach((element) {
							if (element['type'] != 1)
								return ;
							Note note = Note.fromJson(element);
							note.medicalFile = medicalFile;
							medicalFile.notes.add(note);
							note.user = User(
								id				: element['userId'],
								title			: element['title'],
								firstName	: element['first_name'],
								lastName		: element['last_name'],
								role			: element['fk_role']
							);
						});
					}
					setState(() {});
				}
			});
	}

	@override
	Widget build(BuildContext context) {

		if (medicalFile.notes == null)
			getNotes();
		List<Widget> list = List();
		
		if (medicalFile.notes == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (medicalFile.notes.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No Notes to show...')]));

		medicalFile.notes.forEach((Note note) {
			ImageProvider image;
			Color bgColor;
			if (note.user.role == Globals.doctorId)
			{
				bgColor = Color.fromARGB(255, 140, 122, 230);
				image = Image.asset('images/doctor.jpg').image;
			}
			else
			{
				image = Image.asset('images/avatar.png').image;
				bgColor = Colors.lightBlue;
			}

			Widget wi = Card(
				margin: EdgeInsets.symmetric(vertical:10),
				elevation: 20,
				color: Color.fromARGB(255, 251, 197, 49),
				child:Column(
					children: [
						Card(
							color: bgColor,
							elevation: 5,
							margin: EdgeInsets.zero,
							child:Padding(
								padding: EdgeInsets.all(10),
								child:Row(
									crossAxisAlignment: CrossAxisAlignment.center,
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										Row(
											children:[
												SizedBox(
													width: 50,
													child:CircleAvatar(
														backgroundImage:image
													)
												),
												Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children:[
														Text(
															note.user.fullName(),
															style: TextStyle(
																fontWeight: FontWeight.w800,
																color: Colors.white
															),
														),
														Text(
															note.user.title.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w300,
																color: Colors.white
															),
														),
														SizedBox(height: 5,),
														Text(DateFormat('yMMMMd').format(note.date) + ' ' + DateFormat('jm').format(note.date),
															style: TextStyle(fontSize: 10,color: Colors.white70),
														),
													]
												),
											]
										),
										Visibility(
											visible: Globals.user.id == note.user.id,
											child:Row(
												children: [
													IconButton(
														icon:Icon(Icons.edit,color: Colors.white),
														onPressed: () => Navigator.of(context).pushNamed('editnote', arguments:note)
													),
													SizedBox(width: 20,),
													Icon(Icons.delete,color: Colors.white,)
												],
											)
										)
									],
								)
							)
						),
						Padding(
							padding: EdgeInsets.all(20),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children:[
									Text(
										note.note,
										style:TextStyle(
											fontSize: 17,
											fontWeight: FontWeight.w300,
											color: Colors.black
										),
									),
								]
							)
						)
					],
				),
			);
			list.add(wi);
		});
		return Column(children: list,);
	}

	void  delete(noteId)
	{
		Requests.delete(Globals.url + '/api/notes/$noteId').then((value) {
			if (value.statusCode == 200)
			setState(() {
				medicalFile.notes.removeWhere((element) => element.id==noteId);
			});
		});
	}
}