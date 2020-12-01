
import 'package:PatientMonitorMobileApp/controllers/RecepController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Reception/PatientsListView.dart';
import 'package:flutter/material.dart';

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

		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			backgroundColor:Color.fromARGB(255, 0, 168, 255),
			body:DefaultTabController(
				length: 3,
				child: Scaffold(
					backgroundColor: Globals.backgroundColor,
					appBar: AppBar(
						backgroundColor: Color.fromARGB(255, 64, 115, 158),
						title: Text('Manage Patients'),
					),
					body: getContent()
				),
			),
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
