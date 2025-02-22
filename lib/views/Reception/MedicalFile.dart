

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Reception/FileListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MedicalFilePage extends StatefulWidget{

	MedicalFilePage({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => MedicalFilePageState();
}

class MedicalFilePageState extends State<MedicalFilePage> {
  
	ProgressDialog pr;
	Patient			patient;

	void extractArgs(){
		if (patient != null)
			return;
		patient = ModalRoute.of(context).settings.arguments;
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();
		FloatingActionButton floatingActionButton;
		if (Globals.user.role == Globals.recepId)
			floatingActionButton = FloatingActionButton(
				backgroundColor: Colors.green,
				onPressed: ()=>Navigator.of(context).pushNamed('addfile', arguments: patient),
				child: Icon(Icons.add),
			);
		
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			backgroundColor:Globals.backgroundColor,
			floatingActionButton: floatingActionButton,
			body:SafeArea(
				child:SingleChildScrollView(
					child: Stack(
						children: [
							ClipPath(
								child:Container(
									height: 230,
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
										SizedBox(height: 30,),
										TextField(
											decoration: InputDecoration(
												border:  OutlineInputBorder(
													borderRadius: BorderRadius.all(Radius.circular(5)),
													borderSide:  BorderSide(color: Colors.teal)
												),
												fillColor: Colors.white,
												filled: true,
												suffix: Icon(Icons.search),
												hintText: 'Search for medical file'
											),
										),
										SizedBox(height: 15,),
										//FileListView(),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('observations médicales')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Antécédents médicaux')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Antécédents chirurgicaux')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('traitement en cours')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Allergie du patient')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Histoire de la maladie')
											)
										),
										Card(
											child:ListTile(
												leading: Icon(Icons.dehaze_rounded),
												title: Text('Facteurs de risque')
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
