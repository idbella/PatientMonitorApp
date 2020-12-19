
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class FileListView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => FileListViewState();
}
  
class FileListViewState  extends State<FileListView>{
	
	List<MedicalFile> medicalFiles;
	Patient patient;

	void getMedicalFiles()
	{
		if (medicalFiles != null)
			return ;
		Requests.get(Globals.url + '/api/patients/' + patient.id.toString() + '/files')
			.then((response) {
				print('files : ' + response.content().toString());
				if (response.statusCode == 200)
				{
					List<dynamic> list = response.json();
					medicalFiles = List();
					if (list.isNotEmpty)
					{
						list.forEach((element) {
							MedicalFile medicalFile = MedicalFile.fromjson(element);
							medicalFile.patient = patient;
							medicalFiles.add(medicalFile);
							medicalFile.nurses = List();
							if (element['doctor'] != null)
							{
								if (Globals.doctors != null && Globals.doctors.isNotEmpty)
								{
									Doctor doc = Globals.doctors.firstWhere((doctor) => doctor.user.id == element['doctor']);
									if (doc != null)
										medicalFile.doctor = doc;
								}
							}
							if (element['nurses'] != null)
							{
								print('nurses = '+ element['nurses'].toString());
								if (Globals.nurses != null && Globals.nurses.isNotEmpty)
								{
									List<String> nurses = List();
									if (element['nurses'].toString().contains(','))
										nurses = element['nurses'].toString().split(',');
									else
										nurses.add(element['nurses']);
									nurses.forEach((nurseId) {
										var nurse = Globals.nurses.firstWhere((nurse) => nurse.user.id == int.parse(nurseId));
										if (nurse != null)
											medicalFile.nurses.add(nurse);
									});
								}
							}
							medicalFile.nurses.forEach((element) {print('nurse: ' + element.user.email.toString());});
						});
						setState(() {});
					}
				}
			}).catchError((err){
				Globals.showAlertDialog(context, 'Errord', err.toString());
			});
	}

	void extractArgs(){
   	if (patient != null)
      	return;
   	patient = ModalRoute.of(context).settings.arguments;
	}

	@override
	Widget build(BuildContext context) {

		extractArgs();
		getMedicalFiles();

		List<Widget> list = List();
		
		if (medicalFiles == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (medicalFiles.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No medical files to show...')]));

		medicalFiles.forEach((MedicalFile medicalFile) {
			String insurance;
			if (Globals.insuarnces.isNotEmpty)
			{
				Insurance i = Globals.insuarnces.firstWhere((element) => element.id == medicalFile.insuranceType);
				if (i != null)
				{
					insurance = i.title.toString();
					if (i.editable)
						insurance = medicalFile.insurance.toString();
				}
			}

			String doctor = 'No Doctor Assigned yet !';
			if (medicalFile.doctor != null)
				doctor = medicalFile.doctor.user.firstName +" "+ medicalFile.doctor.user.lastName;
			Widget wi = Card(
				shape: RoundedRectangleBorder(
   				borderRadius: BorderRadius.circular(30),
				),
				margin: EdgeInsets.symmetric(vertical:15),
				elevation: 5,
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					crossAxisAlignment: CrossAxisAlignment.start,
					children:[
						ListTile(
							tileColor: Color.fromARGB(255, 0, 151, 230),
							contentPadding: EdgeInsets.symmetric(horizontal:10),
							title:Text(
								medicalFile.title.toString(),
								style: TextStyle(
									color: Colors.white,
									fontSize: 20,
									fontWeight: FontWeight.w500
								),
								overflow: TextOverflow.ellipsis,
							),
							subtitle: Text(
								medicalFile.creationDate.toString(),
								style: TextStyle(color: Color.fromARGB(255, 220, 221, 225),)
							),
							trailing: Icon(MaterialCommunityIcons.dots_vertical),
						),
						Padding(
							padding: EdgeInsets.symmetric(vertical: 20, horizontal:20),
							child:Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									getKeyValue('Consultation reason', medicalFile.motif.toString()),
									SizedBox(height: 8,),
									getKeyValue('Doctor', doctor.toString()),
									SizedBox(height: 8,),
									getKeyValue('Nurses', getNurses(medicalFile)),
									SizedBox(height: 8,),
									getKeyValue('Inusrance', insurance.toString()),
									SizedBox(height: 8,),
									getKeyValue('Appointment', 'not set'),
									SizedBox(height: 8,),
									getKeyValue('Status', 'Active'),
									SizedBox(height: 10,),
									getButtons(medicalFile)
								]
							)
						)
					]
				)
			);
			list.add(wi);
		});
		return Column(children: list,);
	}

	String getNurses(MedicalFile medicalFile)
	{
		String nurses;
		medicalFile.nurses.forEach((element) {
			if (nurses == null)
				nurses = element.user.fullName();
			else
				nurses += ' - ' + element.user.fullName();
		});
		if (nurses != null)
			return nurses;
		return 'no Nurse assigned !';
	}

	Widget getKeyValue(title, value){
		return (
			RichText(
				text: TextSpan(
					style: TextStyle(
						fontSize: 15.0,
						color: Colors.black,
					),
					children: <TextSpan>[
						TextSpan(
							text:title + ' : ',
							style:TextStyle(
								fontWeight: FontWeight.bold,
								fontSize: 18
							)
						),
						TextSpan(
							text: value,
						),
					],
				),
			)
		);
	}

	Widget getButtons(MedicalFile medicalFile)
	{
		Widget deleteBtn = getButton(
			'delete',
			Icons.delete,
			Color.fromARGB(255, 232, 65, 24),
			() => delete(medicalFile.id)
		);
		Widget editBtn = getButton(
			'edit',
			Icons.assignment,
			Colors.lightBlue,
			() => Navigator.of(context).pushNamed('editfile', arguments:medicalFile)
		);
		Widget viewBtn = getButton(
			'view',
			Icons.description,
			Color.fromARGB(255, 76, 209, 55),
			() => Navigator.of(context).pushNamed('viewfile', arguments:medicalFile)
		);

		if (Globals.user.role == Globals.recepId)
			return Row(
				mainAxisAlignment: MainAxisAlignment.spaceBetween,
				children: [
					deleteBtn,
					editBtn,
				],
			);
		return Row(
			mainAxisAlignment: MainAxisAlignment.end,
			children:[
				viewBtn
			]
		);
	}

	Widget getButton(String title, IconData icon, Color color, Function onClick)
	{
		return RaisedButton(
			elevation: 8,
			color: color,
			onPressed: onClick,
			child: Row(
				children:[
					Icon(
						icon,
						color: Colors.white
					),
					SizedBox(width: 5,),
					Text(title,
						style:TextStyle(
							color: Colors.white
						)
					)
				]
			),
		);
	}

	void  delete(fileId)
	{
		Requests.delete(Globals.url + '/api/file/$fileId').then((value) {
			if (value.statusCode == 200)
			setState(() {
				medicalFiles.clear();
			});
		});
	}
}