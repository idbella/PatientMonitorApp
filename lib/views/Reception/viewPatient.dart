

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ViewPatientPage extends StatefulWidget{

	ViewPatientPage({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => ViewPatientPageState();
}

class ViewPatientPageState extends State<ViewPatientPage> {
  
	ProgressDialog pr;
	Patient			patient;

	void extractArgs(){
		if (patient != null)
			return;
		patient = ModalRoute.of(context).settings.arguments;
		print('userId for patient = ' + patient.user.id.toString());
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();
		
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			backgroundColor:Globals.backgroundColor,
			body:SafeArea(
				child:SingleChildScrollView(
					child: Stack(
						children: [
							ClipPath(
								child:Container(
									height: 200,
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
										patientInfo(),
										SizedBox(height: 60,),
										Padding(
											padding: EdgeInsets.symmetric(vertical:10),
											child:Text(
												'Dossier médical : ',
												style:TextStyle(
													fontSize: 18,
													fontWeight: FontWeight.w400
												)
											),
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('observations médicales'),
												onTap: (){
													Navigator.of(context).pushNamed('viewnotes', arguments: patient);
												},
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Antécédents médicaux'),
												onTap: (){
													Navigator.of(context).pushNamed('medical', arguments: patient);
												},
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Antécédents chirurgicaux'),
												onTap: (){
													Navigator.of(context).pushNamed('chirurgical', arguments: patient);
												},
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Allergie du patient'),
												onTap: (){
													Navigator.of(context).pushNamed('allergy', arguments: patient);
												},
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Facteurs de risque'),
												onTap: (){
													Navigator.of(context).pushNamed('factor', arguments: patient);
												},
											)
										),
										Padding(
											padding: EdgeInsets.symmetric(vertical:20),
											child:Text(
												'Dossier de soins infirmiers : ',
												style:TextStyle(
													fontSize: 18,
													fontWeight: FontWeight.w400
												)
											),
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Observations infirmières'),
												onTap: (){
													Navigator.of(context).pushNamed('nurseNotes', arguments: patient);
												},
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Plan de soins infirmiers'),
												onTap: (){
													Navigator.of(context).pushNamed('factor', arguments: patient);
												},
											)
										),
										SizedBox(height: 50,)
									]
								)
							)
						]
					)
				)
			)
		);
	}

	Widget patientInfo()
	{
		return (
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
		);
	}
}
