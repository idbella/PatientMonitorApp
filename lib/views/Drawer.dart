import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}


class _UserDrawerState extends State<UserDrawer> {
	
  	@override
  	Widget build(BuildContext context) {
		return SizedBox(
			width: 200,
			child:Drawer(
			child:Container(
				color: Color.fromARGB(255, 220, 221, 225),
				child: SafeArea(
					child:Column(
						children:[
							Container(
								width: double.infinity,
								color: Colors.white,
								child:Container(
									height: 180,
									child:Image.asset('images/doctor.jpg',fit: BoxFit.fill,),
									decoration: BoxDecoration(
										borderRadius: BorderRadius.circular(100),
										//border: BoxBorder.lerp(a, b, t)
									),
								),
							),
							Card(
								child:ListTile(
									title: Text('Home'),
									leading: Icon(Icons.home),
									onTap: (){
										String page = 'listpatients';
										if (Globals.user.role == Globals.adminId)
											page = 'admin';
										else if (Globals.user.role == Globals.recepId)
											page = 'recep';
										if (ModalRoute.of(context).settings.name != page)
											Navigator.pushNamed(context, page);
									},
								)
							),
							Card(
								child:ListTile(
									title: Text('Profile'),
									leading: Icon(Icons.person),
									onTap: (){
										if (ModalRoute.of(context).settings.name != 'profile')
											Navigator.pushNamed(context, 'profile');
									},
								)
							),
							Card(
								child:ListTile(
									title: Text('Patients'),
									leading: Icon(Icons.person),
									onTap: (){
										if (ModalRoute.of(context).settings.name != 'listpatients')
											Navigator.pushNamed(context, 'listpatients');
									},
								)
							),
							Card(
								child:ListTile(
									title: Text('logout'),
									leading: Icon(Icons.keyboard_arrow_left),
									onTap: (){
										logout().then((value) {
											value.remove('token').then((value) {
												Navigator.pushAndRemoveUntil(
													context,
													MaterialPageRoute(
														builder: (context) => LoginPage(checkLogin: false,)
													),
													(va)=>false
												);
											});
										});
									},
								)
							),
							Card(
								child:ListTile(
									title: Text('staff'),
									leading: Icon(Icons.keyboard_arrow_left),
									onTap: (){
										Navigator.of(context).pushNamed('staff');
									},
								)
							),
						]
					)
				)
			)
		));
	}
}