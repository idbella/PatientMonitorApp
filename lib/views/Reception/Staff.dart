import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/Nurse.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class StaffPage extends StatefulWidget{

	StaffPage({Key key}) : super(key: key);
	@override
	State<StatefulWidget> createState() => StaffPageState();	
}

class StaffPageState extends State<StaffPage> {

	List<Insurance>			inlist = List();
	TextEditingController	doctorController = TextEditingController();
	TextEditingController	nurseController = TextEditingController();
	Doctor						_doctor;
	List<Nurse>					nurses = List();
	MedicalFile					medicalFile;
	bool							first = true;


	void getArgs()
	{
		Map<String,dynamic> patientInfo = ModalRoute.of(context).settings.arguments;
		if (patientInfo != null){
			var args = patientInfo['args'];
			medicalFile = args['medicalFile'];
			if (medicalFile != null)
			{
				
			}
		}
	}

	@override
	Widget build(BuildContext context) {

		if (first)
		{
			first = false;
			getArgs();
		}
		return
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
      		body: SingleChildScrollView(
      			child: SafeArea(
						child:Stack(
							children: [
							Container(
								height: 320,
								width: MediaQuery.of(context).size.width,
								decoration: BoxDecoration(
									image: DecorationImage(
										image: AssetImage('images/nurse.jpg'),
										fit:BoxFit.fitWidth
									)
								),
							),
							Padding(
								padding: EdgeInsets.all(20),
								child:Column(
									children: [
										SizedBox(height: 320,),
										Text(
											'Medical Staff',
											style: TextStyle(
												fontSize: 26,
												fontWeight: FontWeight.w400
											),
										),
										SizedBox(height: 20,),
										Text('Doctor :'),
										TypeAheadField(
											textFieldConfiguration: TextFieldConfiguration(
												style: TextStyle(fontSize: 15),
												decoration: InputDecoration(
													prefixIcon: CircleAvatar(backgroundImage: Image.asset('images/doctor.jpg').image,radius: 10,),
													prefixText: ' doctor : ',
													border: OutlineInputBorder()
												),
												controller: doctorController,
											),
											suggestionsCallback: (pattern) async {
												var list = Globals.doctors.where((doctor) {
													if (doctor.user.title.toString().startsWith(pattern))
														return true;
													if (doctor.user.firstName.startsWith(pattern))
														return true;
													if (doctor.user.lastName.startsWith(pattern))
														return true;
													return false;
												}).toList();

												list.forEach((element) {print(element.user.email);});
												return list;
											},
											itemBuilder: (context, Doctor doctor) {
												return ListTile(
													leading: CircleAvatar(backgroundImage: Image.asset('images/doctor.jpg').image,),
													title: Text(doctor.user.firstName + ' ' + doctor.user.lastName),
													subtitle: Text(doctor.user.title.toString()),
												);
											},
											onSuggestionSelected: (Doctor doctor) {
												setState((){
													_doctor = doctor;
													doctorController.text = doctor.user.firstName + ' ' + doctor.user.lastName;
												});
											},
										),
										Card(
											color: Colors.white,
											child:ListTile(
												leading: _doctor == null ? Icon(Icons.info, color: Colors.red,) : CircleAvatar(backgroundImage: Image.asset('images/doctor.jpg').image,radius: 20,),
												title: Text(_doctor != null ? _doctor.user.fullName() : 'please select a doctor !'),
												trailing: _doctor !=null?IconButton(
													onPressed: () => setState(() {
														_doctor = null;
														doctorController.text = '';
													}),
													icon: Icon(Icons.delete,color:Colors.red),
												):null,
											)
										),
										SizedBox(height: 20,),
										Text('Nurses :'),
										TypeAheadField(
											textFieldConfiguration: TextFieldConfiguration(
												style: TextStyle(fontSize: 15),
												decoration: InputDecoration(
													prefixIcon: CircleAvatar(backgroundImage: Image.asset('images/avatar.png').image,radius: 10,),
													prefixText: ' Nurse : ',
													border: OutlineInputBorder()
												),
												controller: nurseController,
											),
											suggestionsCallback: (pattern) async {
												var list = Globals.nurses.where((nurse) {
													if (nurses.length > 0 && nurses.firstWhere((element) => element.user.id == nurse.user.id) != null)
														return false;
													if (nurse.user.title.toString().startsWith(pattern))
														return true;
													if (nurse.user.firstName.startsWith(pattern))
														return true;
													if (nurse.user.lastName.startsWith(pattern))
														return true;
													return false;
												}).toList();
												if (list == null)
												{
													print('list = null');
													list = List();
												}
												return list;
											},
											itemBuilder: (context, Nurse nurse) {
												return ListTile(
													leading: CircleAvatar(backgroundImage: Image.asset('images/avatar.png').image,),
													title: Text(nurse.user.firstName + ' ' + nurse.user.lastName),
													subtitle: Text(nurse.user.title.toString()),
												);
											},
											onSuggestionSelected: (Nurse nurse) {
												setState((){
													nurses.add(nurse);
													nurseController.text = '';
												});
											},
										),
										SizedBox(height: 20,),
										Column(
											children:getNursesView()
										),
										SizedBox(height: 30,),
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

	List<Widget> getNursesView()
	{
		List<Widget> list = List();
		nurses.forEach((nurse) {
			list.add(
				Card(
					color: Colors.white,
					child:ListTile(
						leading: CircleAvatar(backgroundImage: Image.asset('images/avatar.png').image,radius: 20,),
						title: Text(nurse.user.fullName()),
						trailing: IconButton(
							onPressed: () => setState(() => nurses.removeWhere((_nurse) => _nurse.user.id == nurse.user.id)),
							icon: Icon(Icons.delete,color:Colors.red),
						),
					)
				)
			);
		});
		if (nurses.isEmpty)
		{
			list.add(
				Card(
					color: Colors.white,
					child:ListTile(
						leading: Icon(Icons.info, color: Colors.red,),
						title: Text('please select a nurse !'),
					)
				)
			);
		}
		return list;
	}

	String getSelectedNurses()
	{
		String data;
		nurses.forEach((nurse) {
			if (data != null)
				data += ',' + nurse.user.id.toString();
			else
				data = nurse.user.id.toString();
		});
		return data;
	}

	void next(){
		if (_doctor == null)
			return Globals.showAlertDialog(context, 'required fields', 'doctor is requird');
		if (nurses.isEmpty)
			return Globals.showAlertDialog(context, 'required fields', 'at least one nurse is requird');
		Map<String,dynamic> body = {
			'doctor':_doctor.user.id,
			'nurses':getSelectedNurses()
		};
		Map<String,dynamic> patientInfo = ModalRoute.of(context).settings.arguments;

		var args = patientInfo['args'];
		body = {...args,...body};
		print('final req body = '+ body.toString());
		Requests.post(Globals.url + '/api/patients/', body: body)
		.then((value) {
			if (value.statusCode == 200)
			{
				Globals.patientsList = null;
				Navigator.pushReplacement(
					context,
					MaterialPageRoute(builder: (context)=>RecepHomePage())
				);
				print('success');
			}
			else
				print(value.statusCode.toString());
		})
		.catchError((e){
			print(e.toString());
		});
	}
}
