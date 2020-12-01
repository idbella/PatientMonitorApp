
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/doctor/NotesListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => ViewNotesState();
}

class ViewNotesState extends State<ViewNotes>{

	MedicalFile	medicalFile;
	Patient		patient;

	void extractArgs(){
		if (medicalFile != null)
			return;
		medicalFile = ModalRoute.of(context).settings.arguments;
		patient = medicalFile.patient;
	}

	@override
	Widget build(BuildContext context) {

		extractArgs();
	
		return (
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
				floatingActionButton: FloatingActionButton(
					onPressed: ()=>Navigator.of(context).pushNamed('addnote', arguments:medicalFile),
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
									child:NotesListView(medicalFile: medicalFile,)
								)
							]
						)
					)
				)
			)
		);
		}
	}
