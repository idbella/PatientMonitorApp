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
		return Drawer(
			child:Container(
				color: Color.fromARGB(255, 113, 128, 147),
				child: SafeArea(
					child:Column(
						children:[
							Container(
								width: double.infinity,
								color: Colors.white,
								child:Container(
									width: 40,
									child:CircleAvatar(
										radius: 100,
										backgroundImage: Image.asset('images/doctor.jpg').image,
									),
								)
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
		);
	}
}