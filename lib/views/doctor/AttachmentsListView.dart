
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/attachment.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class AttachmentsListView extends StatefulWidget {
	final MedicalFile medicalFile;

	AttachmentsListView({Key key, this.medicalFile}) : super(key: key);
	@override
	State<StatefulWidget> createState() => AttachmentsListViewState(medicalFile);
}
  
class AttachmentsListViewState  extends State<AttachmentsListView>{
	
	List<Attachment> attachments;
	final MedicalFile medicalFile;

  AttachmentsListViewState(this.medicalFile);

	void getNotes()
	{
		if (attachments != null)
			return ;
		Requests.get(Globals.url + '/api/file/' + medicalFile.id.toString() + '/attachments')
			.then((response) {
				print('attachments : ' + response.content().toString());
				if (response.statusCode == 200)
				{
					List<dynamic> list = response.json();
					attachments = List();
					if (list.isNotEmpty)
					{
						list.forEach((element) {
							Attachment attachment = Attachment.fromJson(element);
							attachment.medicalFile = medicalFile;
							attachments.add(attachment);
						});
						
					}
					setState(() {});
				}
			});
	}

	@override
	Widget build(BuildContext context) {

		getNotes();
		List<Widget> list = List();
		
		if (attachments == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (attachments.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No Notes to show...')]));
		Doctor  doctor = medicalFile.doctor;
		User		user;
		String docName;
		String docTitle;

		if (doctor != null)
			user = doctor.user;
		if (user != null)
		{
			docName = user.firstName + ' ' + user.lastName;
			docTitle = user.title;
		}
		attachments.forEach((Attachment attachment) {

			Widget wi = Card(
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
															docName.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w800,
																color: Colors.white
															),
														),
														Text(
															docTitle.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w300,
																color: Colors.white
															),
														)
													]
												),
											]
										),
										Row(
											children: [
												Icon(Icons.edit,color: Colors.white),
												SizedBox(width: 20,),
												Icon(Icons.delete,color: Colors.white,)
											],	
										),
										//Icon(Icons.arrow_drop_up,color: Colors.white,)
									],
								)
							)
						),
						Padding(
							padding: EdgeInsets.all(10),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children:[
									ListTile(
										title:Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children:[
												Text(attachment.date.toString(),
													style: TextStyle(fontSize: 12),
												),
												SizedBox(height: 20,),
												Text(
													attachment.title,
													style:TextStyle(
														fontSize: 17,
														fontWeight: FontWeight.w300,
														color: Colors.black
													),
												),
											]
										),
										trailing: IconButton(
											onPressed: (){},
											icon:Icon(Icons.download_outlined)
										),
									)
								]
							)
						)
					],
				),
			);
			list.add(wi);
		});
		return Column(children: list,);
	}

	void  delete(attachmentId)
	{
		String url = Globals.url + '/api/attachments/' + attachmentId.toString();
		Requests.delete(url)
			.then((value) {
				if (value.statusCode == 200)
					setState(() {
						attachments = null;
					});
				else
					Globals.showAlertDialog(context, 'error', value.content());
			}
		);
	}
}