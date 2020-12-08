
import 'dart:io';

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/doctor/AttachmentsListView.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class ViewAttachments extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => ViewAttachmentsState();
}

class ViewAttachmentsState extends State<ViewAttachments>{

	MedicalFile	medicalFile;
	Patient		patient;

	void extractArgs(){
		if (medicalFile != null)
			return;
		medicalFile = ModalRoute.of(context).settings.arguments;
		patient = medicalFile.patient;
	}

	@override
	void initState() {
		Permission.storage.request().then((value) {
			if (value.isDenied)
				Navigator.of(context).pop();
		});
   	super.initState();
	}
	int _selected = 3;
	TextEditingController titleController = TextEditingController();
	@override
	Widget build(BuildContext context) {

		extractArgs();

		return (
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
				floatingActionButton: FloatingActionButton(
					onPressed: (){
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return StatefulBuilder(builder: (context, setState){
									return AlertDialog(
										title: Text('New attachment'),
										content: Container(
											height: 250,
											child:Padding(
												padding: EdgeInsets.only(right: 0),
												child:Column(
													crossAxisAlignment: CrossAxisAlignment.start,
													children:[
														Text('attachment type : '),
														SizedBox(height: 10,),
														DropdownButton<int>(
															isExpanded: true,
															value: _selected,
															icon: Icon(Icons.arrow_downward),
															iconSize: 24,
															elevation: 16,
															style: TextStyle(color: Colors.deepPurple),
															onChanged: (int newValue) {
																setState(() {
																	_selected = newValue;
																});
															},
															items: [
																DropdownMenuItem<int>(
																	value: 2,
																	child: Row(
																		children: [
																			Icon(Icons.note),
																			Text('Document')
																		]
																	),
																),
																DropdownMenuItem<int>(
																	value: 1,
																	child: Row(
																		children: [
																			Icon(Icons.image),
																			Text('Photo')
																		]
																	),
																),
																DropdownMenuItem<int>(
																	value: 3,
																	child: Row(
																		children: [
																			Icon(Icons.image),
																			Text('Radiologie')
																		]
																	),
																),
																DropdownMenuItem<int>(
																	value: 4,
																	child: Row(
																		children: [
																			Icon(Icons.note),
																			Text('Ordonnace')
																		]
																	),
																)
															],
														),
														SizedBox(height: 10,),
														Text('description : '),
														TextField(
															controller: titleController,
															maxLines: 3,
															decoration: InputDecoration(
																contentPadding: EdgeInsets.zero,
																border: OutlineInputBorder(
																	borderSide: BorderSide(color: Colors.teal)
																),
															),
														),
													]
												)
											)
										),
										actions: [
											FlatButton(
												onPressed: () => Navigator.of(context).pop(),
												child: Text('Cancel')
											),
											FlatButton(
												onPressed: () {
													Navigator.of(context).pop();
													newAttachment(medicalFile.id);
												},
												child: Text('Ok')
											)
										],
									);
								});
							}
						);
					},
					child:Icon(Icons.add)
				),
				body:SafeArea(
					child:SingleChildScrollView(
						child: Column(
							children: [
								Stack(
									children: [
										ClipPath(
											child:Container(
												height: 170,
												width: MediaQuery.of(context).size.width,
												decoration: BoxDecoration(
													image: DecorationImage(
														image: AssetImage('images/header.png'),
														fit:BoxFit.fitWidth
													)
												),
											),
											clipper: ImageClipper(),
										),
										Padding(
											padding: EdgeInsets.all(20),
											child: Column(
												mainAxisAlignment: MainAxisAlignment.center,
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													Row(
														children: [
															Image.asset('images/avatar.png', width: 100, height: 100,),
															SizedBox(width: 10,),
															Column(
																mainAxisAlignment: MainAxisAlignment.center,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(
																		'Patient',
																		style: TextStyle(
																			fontSize: 18,
																			fontWeight: FontWeight.w700
																		),
																	),
																	Divider(height: 8,),
																	Text(patient.user.lastName.toString() + ' ' + patient.user.firstName.toString()),
																	SizedBox(height: 5,),
																	Text(patient.user.email.toString()),
																	SizedBox(height: 5,),
																	Text(patient.user.phone.toString())
																]
															)
														]
													)
												]
											)
										)
									]
								),
								Padding(
									padding: EdgeInsets.symmetric(horizontal:20),
									child:AttachmentsListView(medicalFile: medicalFile,)
								)
							]
						)
					)
				)
			)
		);
		}

		void newAttachment(fileId)
		{
			String url = Globals.url + '/api/file/$fileId/attachments';
			var body = {
				'title':titleController.text.toString(),
				'type':_selected.toString()
			};
			Requests.post(url, body: body).then((value){
				print(value.content().toString());
			}).catchError((e){
				print(e);
			}).then((value) {
				setState((){});
			});
		}
	}
