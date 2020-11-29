
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/doctor/NotesListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class AddNote extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => AddNoteState();
}

class AddNoteState extends State<AddNote>{

	TextEditingController	noteController = TextEditingController();
	MedicalFile					medicalFile;
	Patient						patient;
	int							_visibleTo = 0;

	void extractArgs(){
		if (medicalFile != null)
			return;
		medicalFile = ModalRoute.of(context).settings.arguments;
		patient = medicalFile.patient;
	}

	@override
	Widget build(BuildContext context) {

		extractArgs();
	
		return (
			Scaffold(
				backgroundColor:Globals.backgroundColor,
				body:SafeArea(
					child:SingleChildScrollView(
						child: Column(
							children: [
								Stack(
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
												]
											)
										)
									]
								),
								Padding(
									padding: EdgeInsets.symmetric(horizontal:20),
									child:Column(
										children: [
											Padding(
												padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
												child:Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children: [
														Text('Visible to '),
														DropdownButton<int>(
															value: _visibleTo,
															icon: Icon(Icons.arrow_downward),
															iconSize: 24,
															elevation: 16,
															style: TextStyle(color: Colors.deepPurple),
															onChanged: (int newValue) {
																setState(() {
																	_visibleTo = newValue;
																});
															},
															items: [
																DropdownMenuItem<int>(
																	value: 0,
																	child: Row(
																		children: [
																			Icon(Icons.person),
																			Text('Only Me')
																		]
																	),
																),
																DropdownMenuItem<int>(
																	value: 1,
																	child: Row(
																		children: [
																			Icon(Icons.person),
																			Text('Nurses Only')
																		]
																	),
																),
																DropdownMenuItem<int>(
																	value: 2,
																	child: Row(
																		children: [
																			Icon(Icons.person),
																			Text('Patient Only')
																		]
																	),
																)
															],
														),
													],
												)
											),
											Theme(
												data:  ThemeData(
												primaryColor: Color.fromARGB(255, 225, 177, 44),
												primaryColorDark: Colors.red,
												),
												child:TextFormField(
													controller: noteController,
													keyboardType: TextInputType.multiline,
													maxLines: 14,
													decoration:  InputDecoration(
														border:  OutlineInputBorder(
															borderRadius: BorderRadius.all(Radius.circular(20)),
														),
														hintText: 'note',
														prefixText: ' ',
														suffixStyle: const TextStyle(color: Colors.green),
														filled: true,
														fillColor:  Color.fromARGB(255, 251, 197, 49)
													),
													style: TextStyle(
														fontSize: 20,
														fontWeight: FontWeight.w300
													),
												)
											),
											Padding(
												padding: EdgeInsets.all(20),
												child:Row(
													mainAxisAlignment: MainAxisAlignment.spaceBetween,
													children:[
														RaisedButton(
															child: Text('cancel', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
															onPressed: (){},
															color: Color.fromARGB(255, 0, 151, 230),
															shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
														),
														RaisedButton(
															child: Text('Save', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
															onPressed: ()=>saveNote(medicalFile.id),
															color: Color.fromARGB(255, 0, 151, 230),
															shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
														)
													]
												)
											)
										],
									)
								)
							]
						)
					)
				)
			)
		);
		}

		void saveNote(int fileId)
		{
			String url = Globals.url + '/api/file/' + fileId.toString() + '/notes';
			var body = {
				'notes':noteController.text.toString()
			};
			Requests.post(url, body: body).then((value) {
				if (value.statusCode == 200)
					Navigator.pop(context);
				print(value.content());
			}).catchError((e){
				print('note error : ' + e.toString());
			});
		}
	}
