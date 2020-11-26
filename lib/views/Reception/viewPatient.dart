

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();
		
		return Scaffold(
			backgroundColor:Globals.backgroundColor,
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
							Positioned(
								top:20,
								right: 20,
								child:IconButton(
									icon: Icon(Icons.menu),
									onPressed: (){
									   logout().then((value) {
											if (value.statusCode == 200)
												print('logged out');
												Navigator.pushReplacement(
													context,
													MaterialPageRoute(builder: (context) => LoginPage(checkLogin: false,))
												);
											}
										).catchError((err){
											print(err.toString());
										});
									}
								),
							),
							Padding(
								padding: EdgeInsets.all(20),
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										SizedBox(height: 10,),
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
										),
										SizedBox(height: 50,),
										Column(
											children: [
												Card(
													elevation: 5,
													child: Padding(
														padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
														child:Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.start,
															children:[
																Row(
																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																	children:[
																		Expanded(child:Text(
																			'motif de consultation testing',
																			style: TextStyle(
																				fontSize: 20,
																				fontWeight: FontWeight.w500
																			),
																			overflow: TextOverflow.ellipsis,
																		)),
																		Icon(MaterialCommunityIcons.dots_vertical)
																	]
																),
																Text('14/12/2020 22:45'),
																Divider(),
																Text('Doctor : ',
																	style: TextStyle(
																		fontWeight: FontWeight.w700
																	),
																),
																SizedBox(height: 8,),
																Text('insurance : ',
																	style: TextStyle(
																		fontWeight: FontWeight.w700
																	),
																),
																SizedBox(height: 8,),
																Text('rendez-vous : ',
																	style: TextStyle(
																		fontWeight: FontWeight.w700
																	),
																),
															]
														)
													)
												),
											],
										)
									]
								)
							)
						]
					)
				)
			)
		);
	}

	Widget file(){
		return(
			Card(
				elevation: 5,
				child:ListTile(
					title: Column(
						children:[
							Text(
								'motif de consultation',
								style: TextStyle(
									fontSize: 20,
									fontWeight: FontWeight.w500
								),
								overflow: TextOverflow.ellipsis,
							),
							Text(
								'motif de consultation',
								style: TextStyle(
									fontSize: 20,
									fontWeight: FontWeight.w500
								),
								overflow: TextOverflow.ellipsis,
							),
							Text(
								'motif de consultation',
								style: TextStyle(
									fontSize: 20,
									fontWeight: FontWeight.w500
								),
								overflow: TextOverflow.ellipsis,
							),
						]
					)
				)
			)
		);
	}

}