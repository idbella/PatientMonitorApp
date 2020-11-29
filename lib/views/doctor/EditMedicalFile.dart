

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/DateTextField.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/TimePicker.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ViewMedicalFile extends StatefulWidget{

	ViewMedicalFile({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => ViewMedicalFileState();
}

class ViewMedicalFileState extends State<ViewMedicalFile> {
  
	ProgressDialog		pr;
	MedicalFile			medicalFile;
	DateTime				date = DateTime.now();
	TimeOfDay			time = TimeOfDay.now();
	bool					rendezVous = true;
	int					_selected;

	TextEditingController titleController = TextEditingController();
	TextEditingController motifController = TextEditingController();
	TextEditingController doctorController = TextEditingController();

	void extractArgs(){
		if (medicalFile != null)
			return;
		medicalFile = ModalRoute.of(context).settings.arguments;
		if (medicalFile != null)
		{
			titleController.text = medicalFile.title.toString();
			motifController.text = medicalFile.motif.toString();
			doctorController.text = medicalFile.doctor.toString();
		}
	}

	@override
	Widget build(BuildContext context) {
		
		extractArgs();

		List<Widget> widgets = List();
		
		Globals.insuarnces.forEach((Insurance element) {
			widgets.add(getCard(element));
		});
		
		return Scaffold(
			backgroundColor:Globals.backgroundColor,
			body:SafeArea(
				child:SingleChildScrollView(
					child: Stack(
						children: [
							ClipPath(
								child:Container(
									height: 170,
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
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										patientInfo(),
										SizedBox(height: 40,),
										textField(
											readOnly: true,
											hint:'titre de dossier',
											label:'titre de dossier',
											controller: titleController,
											icon:Icon(Icons.title)
										),
										SizedBox(height: 20,),
										textField(
											readOnly: true,
											multiline: true,
											maxlines: null,
											hint:'motif de consultation',
											label:'motif de consultation',
											controller: motifController,
											icon:Icon(Icons.article)
										),
										SizedBox(height: 20,),
										Container(
											width:double.infinity,
											child:Center(
												child:Text(
													'Notes',
													style: TextStyle(
														fontSize: 25,
														fontWeight: FontWeight.w700
													),
												)
											)
										),
										Column(children:[getNotes(),getNotes()])
									]
								)
							)
						]
					)
				)
			)
		);
	}

	Widget getNotes()
	{
		return (Column(
			children: [
				Card(
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
											SizedBox(
												width: 50,
												child:CircleAvatar(
													backgroundImage:Image.asset('images/doctor.jpg').image
												)
											),
											
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children:[
													Text(
														"Dr. Said Id-bella Ali",
														style: TextStyle(
															fontWeight: FontWeight.w800,
															color: Colors.white
														),
													),
													Text(
														"tabib mokhtass fi alwilada",
														style: TextStyle(
															fontWeight: FontWeight.w300,
															color: Colors.white
														),
													)
												]
											),
											SizedBox(width: 20,),
											Icon(Icons.arrow_drop_up,color: Colors.white,)
											
										],
									)
								)
							),
							Padding(
								padding: EdgeInsets.all(20),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children:[
										Text('2010/12/12 23:22',
											style: TextStyle(fontSize: 13),
										),
										SizedBox(height: 10,),
										Text(
											'This is a simple widget that allows your users to create tags by entering the tags name inside of textfield and make the tags appear in the textfield. After entering the tag, the user can press the spacebar or enter button to save the tag and move on to enter another tag.',
											style:TextStyle(
												fontSize: 17,
												fontWeight: FontWeight.w300,
												color: Colors.black
											),
										),
									]
								)
							)
						],
					),
				),
				SizedBox(height: 10,),
				Card(
					elevation: 20,
					color: Color.fromARGB(255, 251, 197, 49),
					child:Column(
						children: [
							Card(
								color: Color.fromARGB(255, 39, 60, 117),
								elevation: 5,
								margin: EdgeInsets.zero,
								child:Padding(
									padding: EdgeInsets.all(10),
									child:Row(
										crossAxisAlignment: CrossAxisAlignment.center,
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											SizedBox(
												width: 50,
												child:CircleAvatar(
													backgroundImage:Image.asset('images/avatar.png').image
												)
											),
											
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children:[
													Text(
														"Nurse Youssef Yassine",
														style: TextStyle(
															fontWeight: FontWeight.w800,
															color: Colors.white
														),
													),
													Text(
														"momarid mokhtass fi alwilada",
														style: TextStyle(
															fontWeight: FontWeight.w300,
															color: Colors.white
														),
													)
												]
											),
											SizedBox(width: 20,),
											Icon(Icons.arrow_drop_up,color: Colors.white,)
											
										],
									)
								)
							),
							Padding(
								padding: EdgeInsets.all(20),
								child: Text(
									'This is a simple widget that allows your users to create tags by entering the tags name inside of textfield and make the tags appear in the textfield. After entering the tag, the user can press the spacebar or enter button to save the tag and move on to enter another tag.',
									style:TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.w300,
										color: Colors.black
									),
								),
							)
						],
					),
				)
			]
		)
		);
	}
	Widget getCard(Insurance element){
		return
			Card(
				child: ListTile(
					onTap: (){
						setState(() {
							_selected = element.id;
						});
					},
					title:Column(
						children:[
							Row(
								children:[
									Radio(
										value: element.id,
										groupValue: _selected,
										onChanged: (value){
											setState(() {
												_selected = value;
											});
										}
									),
									Text(element.title.toString()),
								]
							),
							Visibility(
								visible: _selected == element.id && element.editable,
								child: Column(
									children:[
										textField(
											label: element.title.toString(),
											hint: element.title.toString(),
											maxlines: null,
											inputtype: TextInputType.multiline,
											controller: element.controller
										),
										SizedBox(height: 10,)
									]
								)
							)
						]
					)
				)
			);
	}
	
	Widget patientInfo()
	{
		Patient patient = medicalFile.patient;
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
}
