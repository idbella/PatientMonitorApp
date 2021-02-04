

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Allergy.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AllergyPage extends StatefulWidget{

	AllergyPage({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => AllergyPageState();
}

class AllergyPageState extends State<AllergyPage> {
  
	ProgressDialog			pr;
	Patient					patient;

  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

	void extractArgs(){
		if (patient != null)
			return;
		patient = ModalRoute.of(context).settings.arguments;
		print('userId for patient = ' + patient.user.id.toString());
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();

		if (allergies == null)
			getAllergy(patient.id);
		
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
			backgroundColor:Globals.backgroundColor,
			floatingActionButton: FloatingActionButton(
				onPressed: (){
					showDialog(
						context: context,
						builder: (BuildContext context) {
							return StatefulBuilder(builder: (context, setState){
								return AlertDialog(
									title: Text('Ajouter une allergie'),
									content: Container(
										height: 200,
										child:Padding(
											padding: EdgeInsets.only(right: 0),
											child:Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children:[
													Text('titre : '),
													SizedBox(height: 10,),
													textField(hint:'titre',controller: titleController),
													SizedBox(height: 10,),
													Text('description : '),
													textField(
														hint: 'description',
														controller: descController,
														multiline: true
													)
												]
											)
										)
									),
									actions: [
										FlatButton(
											onPressed: () => Navigator.of(context).pop(),
											child: Text('Cancel')
										),
										FlatButton(
											onPressed: () {
												Navigator.of(context).pop();
												addAllergy(patient.id);
											},
											child: Text('Ok')
										)
									],
								);
							});
						}
					);
				},
				child:Icon(Icons.add)
			),
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
							Padding(
								padding: EdgeInsets.all(20),
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										patientInfo(),
										SizedBox(height: 40),
										Text(
											"List d'Allergie",
											style: TextStyle(
												color: Colors.blueGrey,
												fontSize: 26,
												fontWeight: FontWeight.w400
											),
										),
										SizedBox(height: 30),
										getAllergyList()
									]
								)
							)
						]
					)
				)
			)
		);
	}

	Widget patientInfo()
	{
		return (
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
			)
		);
	}

	List<Allergy> allergies;
	
	Widget getAllergyList()
	{
		if (allergies == null)
			return (Text('please wait...'));
		if (allergies.isEmpty)
			return (Text('no Allery'));
		List<Widget> list = List();
		allergies.forEach((element) {
			list.add(Card(
				child:ListTile(
					leading: Icon(Icons.dehaze_rounded),
					title: Text(element.title),
					subtitle: Text(element.description),
				)
			));
		});
		return Column(children: list);
	}

	void getAllergy(int patientId)
	{
		String url = Globals.url + '/api/patient/' + patientId.toString() + '/allergy';
		Requests.get(url).then((response) {
			allergies = List();
			if (response.statusCode == 200)
			{
				List<dynamic> list = response.json();
				
				if (list.isNotEmpty)
				{
					list.forEach((element) {
						Allergy allergy = Allergy.fromJson(element);
						allergies.add(allergy);
					});
				}
			}
			setState((){});
		}).catchError((error){
			Globals.showAlertDialog(context, 'error', error);
		});
	}

	void addAllergy(int patientId)
	{
		String url = Globals.url + '/api/patient/' + patientId.toString() + '/allergy';
		
		var body = {
			'title':titleController.text,
			'desc':descController.text
		};
		Requests.post(url, body: body).then((value) {
			if (value.statusCode == 200)
				setState((){allergies = null;});
			else
				Globals.showAlertDialog(context, 'unexpected error', value.content());
		}).catchError((e){
			Globals.showAlertDialog(context, 'error', e.toString());
		});
	}
}
