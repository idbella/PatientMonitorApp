

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

class FactorPage extends StatefulWidget{

	FactorPage({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => FactorPageState();
}

class FactorPageState extends State<FactorPage> {
  
	ProgressDialog			pr;
	Patient					patient;

  TextEditingController obeController = TextEditingController();
  TextEditingController tabController = TextEditingController();
  TextEditingController diaController = TextEditingController();
  TextEditingController htaController = TextEditingController();

	void extractArgs(){
		if (patient != null)
			return;
		patient = ModalRoute.of(context).settings.arguments;
		obeController.text = patient.obe;
		htaController.text = patient.hta;
		tabController.text = patient.tab;
		diaController.text = patient.dia;
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();
		
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
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
							Padding(
								padding: EdgeInsets.all(20),
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										patientInfo(),
										SizedBox(height: 40),
										Text(
											"Facteurs de risque",
											style: TextStyle(
												color: Colors.blueGrey,
												fontSize: 26,
												fontWeight: FontWeight.w400
											),
										),
										SizedBox(height: 30),
										getFactor('diabète', diaController),
										getFactor('HTA', htaController),
										getFactor('Obésité,', obeController),
										getFactor('tabac', tabController),
										Container(
											width: 100,
											child:
												RaisedButton(
													elevation: 5,
													color: Color.fromARGB(255, 76, 209, 55),
													onPressed: (){
														saveFactor(patient.id);
													},
													child: Row(
														children:[
															Icon(
																Icons.save,
																color: Colors.white
															),
															SizedBox(width: 5,),
															Text('save',
																style:TextStyle(
																	color: Colors.white
																)
															)
														]
													),
												),
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

	Widget getFactor(String name, TextEditingController controller)
	{
		return Card(
			margin: EdgeInsets.symmetric(vertical:10),
			elevation: 20,
			color: Color.fromARGB(255, 251, 197, 49),
			child:Column(
				children: [
					Card(
						color: Color.fromARGB(255, 140, 122, 230),
						elevation: 5,
						margin: EdgeInsets.zero,
						child:Padding(
							padding: EdgeInsets.all(10),
							child:Row(
								crossAxisAlignment: CrossAxisAlignment.center,
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Row(
										children:[
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children:[
													Text(
														name,
														style: TextStyle(
															fontWeight: FontWeight.w400,
															color: Colors.white,
															fontSize: 25
														),
													),
												]
											),
										]
									),
								],
							)
						)
					),
					Padding(
						padding: EdgeInsets.all(20),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children:[
								textField(
									controller: controller,
									hint:'Facteurs de risque ' + name,
									label: 'Facteurs de risque ' + name,
								),
							]
						)
					)
				],
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

	void saveFactor(int patientId)
	{
		String url = Globals.url + '/api/patient/' + patientId.toString() + '/factor';
		
		var body = {
			'obe' : obeController.text,
			'hta' : htaController.text,
			'tab' : tabController.text,
			'dia' : diaController.text
		};
		Requests.post(url, body: body).then((value) {
			if (value.statusCode == 200)
				Globals.showAlertDialog(context, 'ok', 'done');
			else
				Globals.showAlertDialog(context, 'unexpected error', value.content());
		}).catchError((e){
			Globals.showAlertDialog(context, 'error', e.toString());
		});
	}
}
