
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/RecepController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Drawer.dart';
import 'package:PatientMonitorMobileApp/views/Reception/PatientsListView.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';

class ListPatientsPage extends StatefulWidget{

	ListPatientsPage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => ListPatientsPageState();
}

class ListPatientsPageState extends State<ListPatientsPage> {

	@override
	Widget build(BuildContext context) {

		refreshPatientsList(context, setState);
		User user = Globals.user;
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			drawer: UserDrawer(),
			floatingActionButton: FloatingActionButton(
				onPressed: ()=>refreshPatientsList(context, setState, true),
				child: Icon(Icons.refresh),
			),
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
														CircleAvatar(
															radius: 50,
															backgroundImage:Image.asset('images/doctor.jpg',).image,
														),
														SizedBox(width: 10,),
														Column(
															mainAxisAlignment: MainAxisAlignment.center,
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Divider(height: 8,),
																Text(
																	user.lastName.toString() + ' ' + user.firstName.toString(),
																	style: TextStyle(
																		fontSize: 16,
																		fontWeight: FontWeight.w500
																	),
																),
																Text(
																	user.title.toString(),
																	style: TextStyle(
																		fontSize: 15,
																		//fontWeight: FontWeight.w200
																	),
																	overflow: TextOverflow.ellipsis,
																),
																SizedBox(height: 5,),
																Text(user.email.toString()),
																SizedBox(height: 5,),
																Text(user.phone.toString())
															]
														)
													]
												),
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
														hintText: 'Search for patient'
													),
												),
												SizedBox(height: 10,),
												getContent()
											]
										)
									)
								]
							)
						)
					);
				}
			)
		);
	}

	Widget getContent()
	{
		if (Globals.patientsList == null)
			return Center(child:Text('Loading...'));
		if (Globals.patientsList.isEmpty)
			return Center(child:Text('No Patients to view'));
		return PatientsListView();
	}

	void showAlertDialog(BuildContext context) {
   	AlertDialog alert = AlertDialog(
   		title: Text("Loading"),
   		content: Text("Please wait..."),
   	);

   	showDialog(
      	context: context,
      	builder: (BuildContext context) {
        	return alert;
      	}
    	);
	}
}
