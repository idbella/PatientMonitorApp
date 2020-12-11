import 'package:PatientMonitorMobileApp/DateTextField.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:intl/intl.dart';

class AddPatientPage extends StatefulWidget{

	AddPatientPage({Key key}) : super(key: key);

	@override
	State<StatefulWidget> createState() => AddPatientPageState();
		
	}
	
enum Genre { male, female }

class AddPatientPageState extends State<AddPatientPage> {

	TextEditingController fnameController = TextEditingController();
	TextEditingController lnameController = TextEditingController();
	TextEditingController phoneController = TextEditingController();
	TextEditingController cinController = TextEditingController();
	TextEditingController motifController = TextEditingController();

	DateTime date = DateTime.now();

	Patient patient;

	void extractArgs(){
   	if (patient != null)
      	return;
   	patient = ModalRoute.of(context).settings.arguments;
		if (patient != null){
			fnameController.text = patient.user.firstName.toString();
			lnameController.text = patient.user.lastName.toString();
			phoneController.text = patient.user.phone.toString();
			cinController.text = patient.cin.toString();
			date = patient.birthdate;
		}
	}

	@override
	Widget build(BuildContext context) { 
		extractArgs();
		return (
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
				body: SingleChildScrollView(
					child: Stack(
						children: [
							Container(
								height: 270,
								width: MediaQuery.of(context).size.width,
								decoration: BoxDecoration(
									image: DecorationImage(
										image: AssetImage('images/reception.jpg'),
										fit:BoxFit.fitWidth
									)
								),
							),
							Positioned(
								left:15,
								top: 140,
								child: Container(
								width: 120.0,
								height: 120.0,
								decoration: BoxDecoration(
									image: DecorationImage(
										image: Image.asset('images/avatar.png').image,
										fit: BoxFit.cover,
									),
									borderRadius: BorderRadius.all(Radius.circular(60.0)),
									border: Border.all(
										color: Colors.blue,
										width: 7.0,
									),
								),
							),
							),
							Padding(
								padding: EdgeInsets.all(20),
								child:Column(
									children: [
										SizedBox(height: 250,),
										textField(hint:'enter first name', icon:Icon(Icons.person), label: 'first name', controller: fnameController),
										SizedBox(height: 20,),
										textField(hint:'enter last name', icon:Icon(Icons.person), label: 'last name', controller: lnameController),
										SizedBox(height: 20,),
										textField(hint:'enter phone number', icon:Icon(Icons.phone), label: 'phone number', controller: phoneController),
										SizedBox(height: 20,),
										textField(hint:'enter CIN', icon:Icon(Icons.portrait), label: 'CIN', controller: cinController),
										SizedBox(height: 20),
										MyTextFieldDatePicker(
											labelText: "BirthDate",
											prefixIcon: Icon(Icons.date_range),
											suffixIcon: Icon(Icons.arrow_drop_down),
											lastDate: date,
											firstDate: DateTime(1910),
											initialDate: date,
											onDateChanged: (selectedDate) {
												date = selectedDate;
											},
										),
										Visibility(
											visible: patient == null,
											child: Column(
												children: [
													SizedBox(height: 20,),
													textField(
														maxlines: null,
														inputtype: TextInputType.multiline,
														hint:'consultation reason', icon:Icon(Icons.article),
														label: 'consultation reason',
														controller: motifController
													),
												],
											)
										),
										SizedBox(height: 20),
										Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												RaisedButton(
													child: Text('cancel', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
													onPressed: ()=> Navigator.of(context).pop(),
													color: Color.fromARGB(255, 25, 42, 86),
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
												),
												SizedBox(width: 40,),
												RaisedButton(
													child: Text('next', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
													onPressed: next,
													color: Color.fromARGB(255, 25, 42, 86),
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
												)
											]
										),
									]
								)
							)
						]
					)
				)
			)
		);
	}

	String check(){
		if (fnameController.text.length <= 0)
			return 'first name';
		if (lnameController.text.length <= 0)
			return 'last name';
		if (cinController.text.length <= 0)
			return 'cin';
		if (phoneController.text.length <= 0)
			return 'phone number';
		if (motifController.text.length <= 0)
			return 'motif';
		return null;
	}

	void next(){
		String field;
		if ((field = check()) != null)
		{
			Globals.showAlertDialog(context, 'Missing fields', '$field is required');
			return;
		}
		var body = {
			'first_name':fnameController.text,
			'last_name':lnameController.text,
			'phone':phoneController.text,
			'cin':cinController.text,
			'birthday':DateFormat('yyyy-MM-dd').format(date),
			'motif':motifController.text.toString()
		};
		print('req body = '+ body.toString());
		Navigator.of(context)
			.pushNamed(
				'addpatientextra',
				arguments: {
					'patient':patient,
					'args':body
				}
			);
	}
}