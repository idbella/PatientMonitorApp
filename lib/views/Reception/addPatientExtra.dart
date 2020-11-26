
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:requests/requests.dart';

class AddPatientExtraPage extends StatefulWidget{

	AddPatientExtraPage({Key key}) : super(key: key);

	@override
	State<StatefulWidget> createState() => AddPatientExtraPageState();
		
	}
	
enum Genre { male, female }

class AddPatientExtraPageState extends State<AddPatientExtraPage> {

	Genre _selected = Genre.male;

	User user;

	Country _country = Country.MA;

	TextEditingController emailController = TextEditingController();
	TextEditingController addressController = TextEditingController();
	TextEditingController cityController = TextEditingController();
	TextEditingController postalCodeController = TextEditingController();
	TextEditingController cinController = TextEditingController();

	Patient					patient;
	Map<String,dynamic>	args;

	void extractArgs(){
   	
		if (patient != null)
      	return;
   	
		Map<String,dynamic> patientInfo = ModalRoute.of(context).settings.arguments;
		
		patient = patientInfo['patient'];
		args = patientInfo['args'];

		if (patient != null){
			emailController.text			= patient.user.email.toString();
			addressController.text		= patient.address.toString();
			cityController.text			= patient.city.toString();
			cinController.text			= patient.cin.toString();
			postalCodeController.text	= patient.postalCode.toString();
			_country = Country.ALL.where((country) => country.name == patient.country).first;
		}
	}

	@override
	Widget build(BuildContext context) { 

		extractArgs();
		
		return
   		Scaffold(
				backgroundColor:Globals.backgroundColor,
      		body: SingleChildScrollView(
      			child: Stack(children: [
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
										image: NetworkImage('https://cdn.intra.42.fr/users/medium_sid-bell.jpg'),
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
									textField(
										hint:'enter email',
										icon:Icon(Icons.mail),
										label: 'email',
										controller: emailController
									),
									SizedBox(height: 20),
									Container(
										padding: EdgeInsets.all(15),
										decoration:
										BoxDecoration(
											border: Border.all(),
											borderRadius:BorderRadius.all(Radius.circular(20)),
										),
										child:Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Row(
													children: [
														Icon(FontAwesome.user, color: Colors.grey,),
														Text('Sexe :'),
													]
												),
												Row(
													children: [
														Radio(value: Genre.male, groupValue: _selected,
															onChanged: (value){
																setState(() {
																	_selected = value;
																});
															}
														),
														Icon(FontAwesome.male),
														Text('male'),
														VerticalDivider(),
														Radio(value: Genre.female, groupValue: _selected, onChanged: (value){
															print('sel = ' + _selected.toString());
															setState(() {
															_selected = value;
															});
														}),
														Icon(FontAwesome.female),
														Text('female'),
													],
												),
											]
										),
									),
									SizedBox(height: 20,),
									textField(hint:'Address', icon:Icon(Icons.map), label: 'address', controller: addressController),
									SizedBox(height: 20,),
									Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Flexible(
												child:textField(
													hint:'City',
													label: 'City',
													controller: cityController
												)
											),
											SizedBox(width: 20,),
											Flexible(
												child:textField(
													hint:'Postal Code',
													label: 'Postal Code',
													controller: postalCodeController
												),
											)
										]
									),
									SizedBox(height: 20,),
									Container(
										padding: EdgeInsets.all(15),
										decoration:
										BoxDecoration(
											border: Border.all(),
											borderRadius:BorderRadius.all(Radius.circular(20)),
										),
										child:Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Row(
												children: [
													Icon(Icons.home),
													VerticalDivider(),
													Text('Country : '),
												]
												),
												CountryPicker(
												onChanged: (Country country) {
													setState(() {
														_country = country;
													});
												},
												selectedCountry: _country,
												),
											]
										),
									),
									SizedBox(height: 20,),
            					Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											RaisedButton(
												child: Text('back', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
												onPressed: (){Navigator.of(context).pop();},
												color: Color.fromARGB(255, 25, 42, 86),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
											),
											SizedBox(width: 40,),
											RaisedButton(
												child: Text(patient == null ? 'next' : 'save', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
												onPressed: next,
												color: Color.fromARGB(255, 25, 42, 86),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
											)
										]
									),
								]
      					)
      				),
					]
				)
      	)
		);
	}

	void next(){
		var body = {
			'email': emailController.text,
			'sexe':_selected == Genre.female ? '1' : '0',
			'address':addressController.text,
			'country':_country.name,
			'postalcode':postalCodeController.text,
			'city':cityController.text
		};
		body = {...args, ...body};
		print(body);
		if (patient != null)
			updatePatient(body);
		else
			Navigator.of(context).pushNamed('insurance', arguments: {'patient':patient,'args':body});
	}

	void updatePatient(body)
	{
		body.removeWhere((key,val)=>key=='email'&&patient.user.email == val.toString());
		Requests.post(Globals.url + '/api/patients/' + patient.id.toString(), body: body)
		.then((value) {
			print('edit ' + patient.user.email+ ' ' + value.statusCode.toString());
			if (value.statusCode == 200)
				Globals.patientsList = List();
				Navigator.pushReplacement(
					context,
					MaterialPageRoute(builder: (context)=>RecepHomePage())
				);
		}).catchError((err){
			print(err);
		});
	}
}
