
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/Note.dart';
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
													"Dr. Said Id-bella Ali",
													style: TextStyle(
														fontWeight: FontWeight.w800,
														color: Colors.white
													),
												),
												Text(
													"tabib mokhtass fi alwilada",
													style: TextStyle(
														fontWeight: FontWeight.w300,
														color: Colors.white
													),
												)
											]
										),
										SizedBox(width: 20,),
										Icon(Icons.arrow_drop_up,color: Colors.white,)
										
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

	Widget getKeyValue(title, value){
		return (
			RichText(
				text: TextSpan(
					style: TextStyle(
						fontSize: 15.0,
						color: Colors.black,
					),
					children: <TextSpan>[
						TextSpan(
							text:title + ' : ',
							style:TextStyle(
								fontWeight: FontWeight.bold,
								fontSize: 18
							)
						),
						TextSpan(
							text: value,
						),
					],
				),
			)
		);
	}

	Widget getButton(String title, IconData icon, Color color, Function onClick)
	{
		return RaisedButton(
			elevation: 5,
			color: color,
			onPressed: onClick,
			child: Row(
				children:[
					Icon(
						icon,
						color: Colors.white
					),
					SizedBox(width: 5,),
					Text(title,
						style:TextStyle(
							color: Colors.white
						)
					)
				]
			),
		);
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