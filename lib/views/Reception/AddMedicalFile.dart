
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/DateTextField.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/TimePicker.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/Nurse.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:intl/intl.dart';
class AddMedicalFilePage extends StatefulWidget{

	AddMedicalFilePage({Key key, this.title}) : super(key: key);
	
	final String title;
	@override
	State<StatefulWidget> createState() => AddMedicalFilePageState();
}

class AddMedicalFilePageState extends State<AddMedicalFilePage> {
  
	ProgressDialog		pr;
	Patient				patient;
	
	DateTime				firstDate = DateTime.now();
	DateTime				lastDate = DateTime.now().add(Duration(days: 90));
	DateTime				date = DateTime.now();
	
	TimeOfDay			time = TimeOfDay.now();
	bool					rendezVous = true;
	int					_selected;
	Doctor				_doctor;
	List<Nurse>			nurses = List();

	TextEditingController titleController = TextEditingController();
	TextEditingController motifController = TextEditingController();
	TextEditingController doctorController = TextEditingController();
	TextEditingController nurseController = TextEditingController();

	void extractArgs(){
		if (patient != null)
			return;
		patient = ModalRoute.of(context).settings.arguments;
	}

	@override
	Widget build(BuildContext context) {

		extractArgs();

		List<Widget> widgets = List();
		
		Globals.insuarnces.forEach((Insurance element) {
			widgets.add(getCard(element));
		});
		
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 1),
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
											hint:'titre de dossier',
											label:'titre de dossier',
											controller: titleController,
											icon:Icon(Icons.title)
										),
										SizedBox(height: 20,),
										textField(
											multiline: true,
											maxlines: null,
											hint:'consultation reason',
											label:'consultation reason',
											controller: motifController,
											icon:Icon(Icons.article)
										),
										SizedBox(height: 20,),
										Column(
											children: [
												SizedBox(height: 20,),
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
														List list = List();
														if (Globals.nurses != null && Globals.nurses.isNotEmpty)
															list = Globals.nurses.where((nurse) {
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
													itemBuilder: (context, nurse) {
														return ListTile(
															leading: CircleAvatar(backgroundImage: Image.asset('images/avatar.png').image,),
															title: Text(nurse.user.firstName + ' ' + nurse.user.lastName),
															subtitle: Text(nurse.user.title.toString()),
														);
													},
													onSuggestionSelected: (nurse) {
														setState((){
															if (!nurses.contains(nurse))
																nurses.add(nurse);
															nurseController.text = '';
														});
													},
												),
												SizedBox(height: 20,),
												Column(
													children:getNursesView()
												),
											]
										),
										SizedBox(height: 10,),
										Stack(
											children: <Widget>[
												Container(
													width: double.infinity,
													height: 200,
													margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
													decoration: BoxDecoration(
														border: Border.all(
															color: Colors.grey,
															width: 1
														),
														borderRadius: BorderRadius.circular(5),
														shape: BoxShape.rectangle,
													),
												),
												Positioned(
													left: 10,
													top: 0,
													child: Container(
														padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
														color: Globals.backgroundColor,
														child: Row(
															children:[
																SizedBox(
																	width: 30,
																	child:Checkbox(
																		value: rendezVous,
																		onChanged: (value)=> setState(() => rendezVous = value)
																	),
																),
																Text(
																	'Appointment',
																	style: TextStyle(color: Colors.black, fontSize: 14),
																)	
															]
														)
													)
												),
												Visibility(
													visible: rendezVous,
													child:Padding(
														padding: EdgeInsets.symmetric(horizontal:20,vertical: 10),
														child:Column(
															children: [
																SizedBox(height: 50,),
																Row(
																	children: [
																		Text('Date : '),
																		SizedBox(width: 20,),
																		Flexible(child:MyTextFieldDatePicker(
																			labelText: "Date",
																			prefixIcon: Icon(Icons.date_range),
																			suffixIcon: Icon(Icons.arrow_drop_down),
																			lastDate: lastDate,
																			firstDate: firstDate,
																			initialDate: date,
																			onDateChanged: (selectedDate) {
																				date = selectedDate;
																			},
																		),
																		)
																	],
																),
																SizedBox(height: 20,),
																Row(
																	children: [
																		Text('Time : '),
																		SizedBox(width: 20,),
																		Flexible(
																			child: MyTextFieldTimePicker(
																				labelText: "time",
																				ctx: context,
																				initialDate: time,
																				prefixIcon: Icon(Icons.timer),
																				suffixIcon: Icon(Icons.arrow_drop_down),
																				onDateChanged: (time){
																					this.time = time;
																				},
																			),
																		)
																	],
																)
															],
														)
													),
												),
												Visibility(
													visible: rendezVous == false,
													child:Positioned(
														top:110,
														left: 100,
														child:Row(
															crossAxisAlignment: CrossAxisAlignment.center,
															mainAxisAlignment: MainAxisAlignment.spaceBetween,
															children:[
																Icon(Icons.info),
																Text('  No appointments.'),
															]
														)
													)
												)
											],
										),
										Padding(
											padding: EdgeInsets.all(20),
											child:Column(
												children: [
													Text(
														'Insurance type',
														style: TextStyle(
															fontSize: 24,
															fontWeight: FontWeight.w600
														),
													),
													SizedBox(height: 20,),
													Column(children: widgets,),
												]
											)
										),
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												RaisedButton(
													child: Row(
														children:[
															Icon(Icons.arrow_back),
															SizedBox(width: 5,),
															Text('cancel', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
														]
													),
													onPressed: ()=> Navigator.of(context).pop(),
													color: Colors.blue,
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
												),
												SizedBox(width: 20,),
												RaisedButton(
													child: Row(
														children:[
															Text('Save', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
															SizedBox(width: 5,),
														]
													),
													onPressed: (){addMedicalFile(patient.id);},
													color: Colors.green,
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

	Widget getCard(Insurance element){
		return
			Card(
				color: Colors.white,
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

	void addMedicalFile(int patientId)
	{
		if (_doctor == null)
			return Globals.showAlertDialog(context, 'required fields', 'doctor is requird');
		if (nurses.isEmpty)
			return Globals.showAlertDialog(context, 'required fields', 'at least one nurse is requird');

		var body = {
			'insurance_type':_selected.toString(),
			'title':titleController.text,
			'motif':motifController.text,
			'doctor':_doctor.user.id,
			'nurses':getSelectedNurses(),
			'appointment':DateFormat('yyy-MM-dd').format(date) +' '+ time.hour.toString() + ':' + time.minute.toString() + ':00',
			'insurance':Globals.insuarnces.where((element) => element.id == _selected).first.controller.text.toString()
		};
		body.removeWhere((key,val)=>key=='doctor' && val == null);
		body.removeWhere((key,val)=>key=='insurance_type' && val == null);
		Requests.post(Globals.url + '/api/patients/' + patientId.toString() + '/file', body: body)
		.then((value){
			print('add file = ' + value.content());
			if (value.statusCode == 200)
				Navigator.of(context).pop();
		}).catchError((e){
			print('add file error : ' + e.toString());
		});
	}

}
