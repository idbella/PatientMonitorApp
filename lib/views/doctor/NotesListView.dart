
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/Note.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:requests/requests.dart';

class NotesListView extends StatefulWidget {
	final MedicalFile medicalFile;

	NotesListView({Key key, this.medicalFile}) : super(key: key);
	@override
	State<StatefulWidget> createState() => NotesListViewState(medicalFile);
}
  
class NotesListViewState  extends State<NotesListView>{
	
	List<Note> notes;
	final MedicalFile medicalFile;

  NotesListViewState(this.medicalFile);

	void getNotes()
	{
		if (notes != null)
			return ;
		Requests.get(Globals.url + '/api/file/' + medicalFile.id.toString() + '/notes')
			.then((response) {
				print('notes : ' + response.content().toString());
				if (response.statusCode == 200)
				{
					List<dynamic> list = response.json();
					notes = List();
					if (list.isNotEmpty)
					{
						list.forEach((element) {
							Note note = Note.fromJson(element);
							note.medicalFile = medicalFile;
							notes.add(note);
						});
						
					}
					setState(() {});
				}
			});
	}

	@override
	Widget build(BuildContext context) {

		getNotes();
		List<Widget> list = List();
		
		if (notes == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (notes.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No Notes to show...')]));
		Doctor  doctor = medicalFile.doctor;
		User		user;
		String docName;
		String docTitle;

		if (doctor != null)
			user = doctor.user;
		if (user != null)
		{
			docName = user.firstName + ' ' + user.lastName;
			docTitle = user.title;
		}
		notes.forEach((Note note) {

			Widget wi = Card(
				margin: EdgeInsets.symmetric(vertical:10),
				elevation: 20,
				color: Color.fromARGB(255, 251, 197, 49),
				child:Column(
					children: [
						Card(
							color: Color.fromARGB(255, 140, 122, 230),
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
														backgroundImage:Image.asset('images/doctor.jpg').image
													)
												),
												
												Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children:[
														Text(
															docName.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w800,
																color: Colors.white
															),
														),
														Text(
															docTitle.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w300,
																color: Colors.white
															),
														)
													]
												),
											]
										),
										Row(
											children: [
												Icon(Icons.edit,color: Colors.white),
												SizedBox(width: 20,),
												Icon(Icons.delete,color: Colors.white,)
											],	
										),
										//Icon(Icons.arrow_drop_up,color: Colors.white,)
									],
								)
							)
						),
						Padding(
							padding: EdgeInsets.all(20),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children:[
									Text(note.date.toString(),
										style: TextStyle(fontSize: 13),
									),
									SizedBox(height: 10,),
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
				notes = null;
			});
		});
	}
}