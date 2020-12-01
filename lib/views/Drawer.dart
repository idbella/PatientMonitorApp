import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatefulWidget {
  @override
  _UserDrawerState createState() => _UserDrawerState();
}

User user = Globals.user;

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
									title: Text('logout'),
									leading: Icon(Icons.keyboard_arrow_left),
									onTap: (){
										logout().then((value) {
											if (value.statusCode == 200)
												print('logged out');
												Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(checkLogin: false,)));
											}
										).catchError((err){
											print(err.toString());
										});
									},
								)
							)
						]
					)
				)
			)
		));
	}
}