
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/doctor/AttachmentsListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';

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
	
	@override
	Widget build(BuildContext context) {

		extractArgs();
		double _iconsSize = 70;
		return (
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
				floatingActionButton: FloatingActionButton(
					onPressed: (){
						showDialog(
							context: context,
							builder: (BuildContext context) {
								return AlertDialog(
									title: Text('Add attachment'),
									content: Container(
										height: 230,
										child:Padding(
											padding: EdgeInsets.only(right: 0),
											child:Column(
												children:[
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															FlatButton(
																child: Column(
																	children:[
																		Icon(Icons.picture_as_pdf,size: _iconsSize,),
																		Text('Document')
																	]
																),
																onPressed: (){

																}
															),
															FlatButton(
																child: Column(
																	children:[
																		Icon(Icons.image,size: _iconsSize,),
																		Text('Image')
																	]
																),
																onPressed: (){

																}
															)
														]
													),
													SizedBox(
														height: 30,
													),
													Row(
														mainAxisAlignment: MainAxisAlignment.spaceBetween,
														children: [
															FlatButton(
																child: Column(
																	children:[
																		Icon(Icons.description,size: _iconsSize,),
																		Text('ordonnance')
																	]
																),
																onPressed: (){

																}
															),
															FlatButton(
																child: Column(
																	children:[
																		Icon(Icons.medical_services,size: _iconsSize,),
																		Text('Radiologie')
																	]
																),
																onPressed: (){

																}
															)
														]
													)
												]
											)
										)
									),
									actions: [
										IconButton(
											onPressed: ()=>Navigator.of(context).pop(),
											icon: Icon(Icons.cancel)
										)
									],
								);
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
	}
