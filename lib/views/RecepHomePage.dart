

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:PatientMonitorMobileApp/views/addPatient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RecepHomePage extends StatefulWidget{

	RecepHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => RecepHomePageState();
		
	}
	
class RecepHomePageState extends State<RecepHomePage> {
  
	ProgressDialog pr;
	User				user = Globals.user;
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
			// floatingActionButton:Padding(
			// 	padding: EdgeInsets.only(bottom: 40,right: 10),
			// 	child: FloatingActionButton(
			// 		child: Icon(Icons.add),
			// 		backgroundColor: Color.fromARGB(255, 68, 189, 50),
			// 		onPressed: (){
			// 			Navigator.of(context).pushNamed('addpatient')
			// 			.whenComplete(() {
			// 				setState(() {});
			// 			});
			// 		},
			// 	)
			// ),
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
															'Receptionist',
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
										SizedBox(height: 140,),
										Column(
											children: [
												Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														getCard(
															'register new Patient',
															Icon(
																Icons.add,
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
															(){}
														),
													],
												),
												SizedBox(height: 50,),
												Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														getCard(
															' new Questionnaire  ',
															Icon(
																Icons.list,
																size: 70,
															),
															EdgeInsets.symmetric(horizontal: 15, vertical:40),
															(){}
														),
														getCard(
															'List Questionnaire',
															Icon(
																FontAwesome.list,
																size: 70,
															),
															EdgeInsets.symmetric(horizontal: 20,vertical: 40),
															(){}
														),
													],
												)
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
				padding: EdgeInsets.zero,
				onPressed: onClick,
				child:Card(
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