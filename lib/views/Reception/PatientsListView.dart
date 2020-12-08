
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

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
		List<Widget> list = List();

		patients.forEach((patient) {
			Widget w = Card(
						elevation: 5,
						child:Column(
							children:[
								ListTile(
									contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
									onTap: () {
										Navigator.of(context)
										.pushNamed('viewpatient', arguments:patient);
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
												patient.user.firstName.toString() + ' ' + patient.user.lastName.toString(),
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
													Text(patient.user.email.toString(), overflow: TextOverflow.ellipsis,),
													)
												]
											),
											SizedBox(height: 5,),
											Row(
												children: [
													Icon(Icons.phone, size: 15,),
													VerticalDivider(width: 5,),
													Flexible(child:
													Text(patient.user.phone.toString(), overflow: TextOverflow.ellipsis,),
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
											Visibility(
												visible: Globals.user.role == Globals.recepId,
												child:getButton(
													'delete',
													Icons.delete,
													Color.fromARGB(255, 232, 65, 24),
													() => showAlertDialog(context, patient)
												)
											),
											Visibility(
												visible: Globals.user.role == Globals.recepId,
												child:getButton(
													'edit',
													Icons.assignment,
													Colors.lightBlue,
													() => Navigator.of(context)
														.pushNamed('addpatient', arguments:patient)
												)
											),
											getButton(
												'view',
												Icons.description,
												Color.fromARGB(255, 76, 209, 55),
												() => Navigator.of(context)
													.pushNamed('viewpatient', arguments:patient)
											),
										],
									)
								)
							]
						)
			);
			list.add(w);
		});
   	return Column(children:list);
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
		print('delete patient ' + patient.id.toString());
		Requests.delete(Globals.url + '/api/patients/' + patient.id.toString())
		.then((value) {
			if (value.statusCode == 200)
			{
				Navigator.of(context).pop();
				setState(() {
					Globals.patientsList.removeWhere((element) => element.user.id == patient.id);
				});
				print('success');
			} else {
					Navigator.of(context).pop();
					Globals.showAlertDialog(context, 'error', value.content().toString());
				}
		}).catchError((e){
			Navigator.of(context).pop();
			Globals.showAlertDialog(context, 'error', e.toString());
		});
	}
}
