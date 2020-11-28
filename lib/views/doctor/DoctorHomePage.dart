

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DoctorHomePage extends StatefulWidget{

	DoctorHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => DoctorHomePageState();
		
	}
	
class DoctorHomePageState extends State<DoctorHomePage> {
  
	ProgressDialog pr;
	User				user = Globals.user;
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
												Image.asset('images/doctor.jpg', width: 100, height: 100,),
												SizedBox(width: 10,),
												Column(
													mainAxisAlignment: MainAxisAlignment.center,
													crossAxisAlignment: CrossAxisAlignment.start,
													children: [
														Text(
															'Doctor',
															style: TextStyle(
																fontSize: 18,
																fontWeight: FontWeight.w700
															),
														),
														Divider(height: 8,),
														Text(user.lastName.toString() + ' ' + user.firstName.toString()),
														SizedBox(height: 5,),
														Text(user.email.toString()),
														SizedBox(height: 5,),
														Text(user.phone.toString())
													]
												)
											]
										),
										SizedBox(height: 50,),
										Column(
											children: [
												Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														getCard(
															'      Render-Vous      ',
															Icon(
																Foundation.calendar,
																size: 70,
															),
															EdgeInsets.symmetric(horizontal: 15, vertical:40),
															(){
																Navigator.of(context).pushNamed('addpatient');
															}
														),
														getCard(
															'List Patients',
															Icon(
																Icons.find_in_page,
																size: 70,
															),
															EdgeInsets.symmetric(horizontal: 40,vertical: 40),
															(){
																Navigator.of(context).pushNamed('listpatients');
															}
														),
													],
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

  void showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Loading"),
      content: Text("Please wait..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

	Widget getCard(String text, Widget icon, EdgeInsetsGeometry padding, Function onClick){
		return (
			FlatButton(
				onPressed: onClick,
				padding: EdgeInsets.zero,
				child: Card(
					elevation: 10,
					child:Padding(
						padding: padding,
						child:Column(
							children: [
								icon,
								Text(text)
							]
						)
					)
				)
			)
		);
	}
}
