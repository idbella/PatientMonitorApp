

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Drawer.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
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
			bottomNavigationBar: BottomMenu(selectedIndex: 0),
			drawer: UserDrawer(),
			backgroundColor:Globals.backgroundColor,
			body:Builder(
				builder:(context){
					return SafeArea(
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
											Scaffold.of(context).openDrawer();
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
											SizedBox(height: 150,),
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
																'Patients List',
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
													SizedBox(height: 20,),
													// Row(
													// 	mainAxisAlignment: MainAxisAlignment.spaceBetween,
													// 	children: [
													// 		getCard(
													// 			' new Questionnaire  ',
													// 			Icon(
													// 				Icons.list,
													// 				size: 70,
													// 			),
													// 			EdgeInsets.symmetric(horizontal: 15, vertical:40),
													// 			(){}
													// 		),
													// 		getCard(
													// 			'List Questionnaire',
													// 			Icon(
													// 				FontAwesome.list,
													// 				size: 70,
													// 			),
													// 			EdgeInsets.symmetric(horizontal: 20,vertical: 40),
													// 			(){}
													// 		),
													// 	],
													// ),
													SizedBox(height: 20,),
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
															// getCard(
															// 	'List Patients',
															// 	Icon(
															// 		Icons.find_in_page,
															// 		size: 70,
															// 	),
															// 	EdgeInsets.symmetric(horizontal: 40,vertical: 40),
															// 	(){
															// 		Navigator.of(context).pushNamed('listpatients');
															// 	}
															// ),
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
				);
			})
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
