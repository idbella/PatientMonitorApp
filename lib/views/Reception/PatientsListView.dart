
import 'package:PatientMonitorMobileApp/controllers/RecepController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class PatientsListView extends StatefulWidget{
  
	PatientsListView();

	@override
	State<StatefulWidget> createState() => PatientsListViewState();
}

class PatientsListViewState extends State<PatientsListView>{

	PatientsListViewState();

	@override
	Widget build(BuildContext context) {

   	List<Patient> patients = Globals.patientsList;
		if (patients.isEmpty)
			return (Text('empty list'));
   	return ListView.builder(
			itemCount: patients.length,
			itemBuilder: (BuildContext ctx, int index) {
				return Padding(
					padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
					child:Card(
						elevation: 5,
						child:Column(
							children:[
								ListTile(
									contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
									onTap: () {
										Navigator.of(context)
										.pushNamed('viewpatient', arguments:patients[index]);
									},
									leading: CircleAvatar(
										backgroundImage: Image.asset('images/avatar.png').image,
										radius: 30,
									),
									title: Column(
										crossAxisAlignment: CrossAxisAlignment.start,
										children:[
											SizedBox(height: 10,),
											Text(
												patients[index].user.firstName.toString() + ' ' + patients[index].user.lastName.toString(),
												style: TextStyle(
													fontSize: 20,
													fontWeight: FontWeight.w500
												),
											)
										]
									),
									subtitle: Column(
										children:[
											Divider(height: 10,),
											Row(
												children: [
													Icon(Icons.email, size: 15,),
													VerticalDivider(width: 5,),
													Flexible(child:
													Text(patients[index].user.email.toString(), overflow: TextOverflow.ellipsis,),
													)
												]
											),
											SizedBox(height: 5,),
											Row(
												children: [
													Icon(Icons.phone, size: 15,),
													VerticalDivider(width: 5,),
													Flexible(child:
													Text(patients[index].user.phone.toString(), overflow: TextOverflow.ellipsis,),
													)
												]
											)
										]
									),
									isThreeLine: true
								),
								SizedBox(height: 10,),
								Padding(
									padding: EdgeInsets.only(left:10,right:10,bottom:10),
									child:Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											getButton(
												'delete',
												Icons.delete,
												Color.fromARGB(255, 232, 65, 24),
												() => showAlertDialog(context, patients[index])
											),
											getButton(
												'edit',
												Icons.assignment,
												Colors.lightBlue,
												() => Navigator.of(context)
													.pushNamed('addpatient', arguments:patients[index])
											),
											getButton(
												'view',
												Icons.description,
												Color.fromARGB(255, 76, 209, 55),
												() => Navigator.of(context)
													.pushNamed('viewpatient', arguments:patients[index])
											),
										],
									)
								)
							]
						)
					)
				);
			}
		);
	}

	showAlertDialog(BuildContext context, Patient patient) {

		Widget cancelButton = FlatButton(
			child: Text("Cancel"),
			onPressed: () {
			Navigator.of(context).pop();
			}
		);
	
		Widget okButton = FlatButton(
			child: Text("Delete"),
			onPressed: () => deletePatient(patient),
		);
		String fname = patient.user.firstName.toString() + ' ' + patient.user.lastName.toString();
		AlertDialog alert = AlertDialog(
			title: Text("Confirm"),
			content: Text("Delete user " + fname),
			actions: [
				cancelButton,
				okButton
			],
		);

		showDialog(
			context: context,
			builder: (BuildContext context) {
			return alert;
			},
		);
	}

	Widget getButton(String title, IconData icon, Color color, Function onClick)
	{
		return RaisedButton(
			elevation: 5,
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

	void deletePatient(Patient patient)
	{
		Requests.delete(Globals.url + '/api/patients/' + patient.id.toString())
		.then((value) {
			if (value.statusCode == 200)
			{
				Navigator.of(context).pop();
				setState(() {
					Globals.patientsList.removeWhere((element) => element.user.id == patient.id);
				});
				print('success');
			}
			else
				print(value.statusCode.toString());
		}).catchError((e){
			print(e.toString());
		});
	}
}
