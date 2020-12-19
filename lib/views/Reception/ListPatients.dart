
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/controllers/RecepController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Drawer.dart';
import 'package:PatientMonitorMobileApp/views/Reception/PatientsListView.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ListPatientsPage extends StatefulWidget{

	ListPatientsPage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => ListPatientsPageState();
}

class ListPatientsPageState extends State<ListPatientsPage> {

	TextEditingController searchController = TextEditingController();
	@override
	Widget build(BuildContext context) {

		refreshPatientsList();
		User user = Globals.user;
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			drawer: UserDrawer(),
			floatingActionButton: FloatingActionButton(
				onPressed: ()=>refreshPatientsList(true),
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
															backgroundImage:Image.asset(Globals.user.role == Globals.doctorId ? 'images/doctor.jpg' : 'images/avatar.png').image,
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
												TypeAheadField(
													textFieldConfiguration: TextFieldConfiguration(
														style: TextStyle(fontSize: 15),
														decoration: InputDecoration(
															prefixText: ' patient : ',
															suffix: Icon(Icons.search),
															border: OutlineInputBorder()
														),
														controller: searchController,
													),
													suggestionsCallback: (pattern) async {
														var list = Globals.patientsList.where((patient) {
															if (patient.cin.toString().startsWith(pattern))
																return true;
															if (patient.user.firstName.startsWith(pattern))
																return true;
															if (patient.user.lastName.startsWith(pattern))
																return true;
															if (patient.user.email.startsWith(pattern))
																return true;
															return false;
														}).toList();
														return list;
													},
													itemBuilder: (context, Patient patient) {
														return ListTile(
															leading: CircleAvatar(backgroundImage: Image.asset('images/avatar.png').image,),
															title: Text(patient.user.firstName + ' ' + patient.user.lastName),
															subtitle: Text(patient.user.email.toString()),
														);
													},
													onSuggestionSelected: (Patient patient) {
														setState((){
															searchController.text = patient.user.firstName + ' ' + patient.user.lastName;
														});
													},
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
		print('reload');
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

	void refreshPatientsList([bool reload=false])
	{
		List<dynamic> list;

		if (reload || Globals.patientsList == null)
		{
			Globals.patientsList = null;
		
			listPatients().then((value) {
				if (value.statusCode == 200)
				{
					list = value.json();
					print('patients : ' + list.toString());
					Globals.patientsList = List();
					if (list.isNotEmpty) {
						list.forEach((element) {
							Patient patient = Patient.fromjson(element);
							Globals.patientsList.add(patient);
						});
					}
					setState((){});
				}
				else if (value.statusCode == 401)
					Navigator.pushReplacementNamed(context, 'login');
			})
			.catchError((err){
				print('errr = ' + err.toString());
			});
		}
	}
}
