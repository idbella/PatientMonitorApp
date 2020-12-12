
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/attachment.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class AttachmentsListView extends StatefulWidget {
	final MedicalFile medicalFile;

	AttachmentsListView({Key key, this.medicalFile}) : super(key: key);
	@override
	State<StatefulWidget> createState() => AttachmentsListViewState(medicalFile);
}
  
class AttachmentsListViewState  extends State<AttachmentsListView>{

	final MedicalFile medicalFile;

  AttachmentsListViewState(this.medicalFile);

	void getNotes()
	{
		if (medicalFile.attachments != null)
			return ;
		Requests.get(Globals.url + '/api/file/' + medicalFile.id.toString() + '/attachments')
			.then((response) {
				print('attachments : ' + response.content().toString());
				if (response.statusCode == 200)
				{
					List<dynamic> list = response.json();
					medicalFile.attachments = List();
					if (list.isNotEmpty)
					{
						list.forEach((element) {
							Attachment attachment = Attachment.fromJson(element);
							attachment.medicalFile = medicalFile;
							medicalFile.attachments.add(attachment);
							attachment.user = User(id:element['userId']);
						});
					}
					setState(() {});
				}
				if (response.statusCode == 404)
					setState(() {medicalFile.attachments = List();});
			});
	}

	@override
	Widget build(BuildContext context) {

		getNotes();
		List<Widget> list = List();
		
		if (medicalFile.attachments == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (medicalFile.attachments.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No Attachments to show...')]));
		Doctor	doctor = medicalFile.doctor;
		User		user;
		String	docName;
		String	docTitle;

		if (doctor != null)
			user = doctor.user;
		if (user != null)
		{
			docName = user.firstName + ' ' + user.lastName;
			docTitle = user.title;
		}
		medicalFile.attachments.forEach((Attachment attachment) {

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
														),
														SizedBox(height: 5,),
														Text(DateFormat('yMMMMd').format(attachment.date) + ' ' + DateFormat('jm').format(attachment.date),
															style: TextStyle(fontSize: 10,color: Colors.white70),
														),
													]
												),
											]
										),
										Row(
											children: [
												// Icon(Icons.edit,color: Colors.white),
												// SizedBox(width: 20,),
												Visibility(
													visible: attachment.user.id == Globals.user.id,
													child:IconButton(
														icon:Icon(Icons.delete,color: Colors.white,),
														onPressed: ()=>showAlertDialog(context, attachment),
													)
												)
											],
										),
									],
								)
							)
						),
						Padding(
							padding: EdgeInsets.all(5),
							child:Builder(
								builder: (context){
									List<Widget> list = List();
									list.add(
										Padding(
											padding: EdgeInsets.all(10),
											child:Text(
											attachment.title,
											style: TextStyle(
												fontWeight: FontWeight.w300,
												fontSize: 18
											),
										))
									);
									attachment.files.forEach((element) {
										list.add(getSingleFileView(attachment, element));
									});
									list.add(
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												SizedBox(width: 10,),
												RaisedButton(
													onPressed: (){
														showSelectDialog(attachment);
													},
													child:Row(
													children: [
														Icon(Icons.add),
														Text('add '),
													]
												)
												)
											],
										)
									);
									Widget wi = Column(
										crossAxisAlignment: CrossAxisAlignment.center,
										children:list
									);
									return wi;
								}
							)
						)
					],
				),
			);
			list.add(wi);
		});
		return Column(children: list,);
	}

	void showAlertDialog(BuildContext context, Attachment attachment)
	{
		Widget cancelButton = FlatButton(
			child: Text("Cancel"),
			onPressed: () {
			Navigator.of(context).pop();
			}
		);
		Widget okButton = FlatButton(
			child: Text("Delete"),
			onPressed: () {
				delete(attachment.id);
			},
		);
	
		AlertDialog alert = AlertDialog(
			title: Text("Confirm"),
			content: Text("Delete Attachment ?"),
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
	void  delete(attachmentId)
	{
		Navigator.of(context).pop();
		String url = Globals.url + '/api/attachments/' + attachmentId.toString();
		Requests.delete(url)
			.then((value) {
				print(value.statusCode.toString());
				if (value.statusCode == 200)
					setState(() {
						medicalFile.attachments = null;
					});
				else
					Globals.showAlertDialog(context, 'error', value.content());
			}
		);
	}

	void downloadAtachment(AttachFile file, filePath) async {									
		Dio(
			BaseOptions(
				headers: {'Authorization' : 'Bearer ${Globals.token}'}
			)
		).download(file.url, filePath).then((value){
			if (value.statusCode == 200)
			{
				setState(() {
				  file.downloaded = true;
				});
				print(value.statusCode.toString());
			}
		}).catchError((e){
			print(e.toString());
		});
	}

	void openAttachment(fileName){
		OpenFile.open(fileName);
	}

	Future<bool> isDownloaded(AttachFile file) async {
		String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
		String filePath = path + '/' + file.name;
		bool exist = false;
		try{
			exist = await File(filePath).exists();
		}catch(e){}
		return exist;
	}

	Widget getSingleFileView(Attachment attachment, AttachFile file)
	{
		Widget leading = Icon(Icons.picture_as_pdf,size: 40,);
		var type = attachment.type;
		if (type == Globals.radioAttach || type == Globals.imageAttach)
			leading = Image.network(
				file.url,
				headers: {'Authorization' : 'Bearer ${Globals.token}'},
				height: 100,
				width: 80,
			);
		if (!file.downloaded)
			isDownloaded(file).then((value) {
				if (value == true)
					setState(() {
						file.downloaded = true;
					});
			});
		return Card(
			child:ListTile(
				onTap: (){
					var type = attachment.type;
					if (type == Globals.imageAttach || type == Globals.radioAttach)
					showDialog(
						context: context,
						builder: (BuildContext context) {
							return AlertDialog(
								backgroundColor: Colors.transparent,
								content:InteractiveViewer(
									panEnabled: true,
									boundaryMargin: EdgeInsets.all(100),
									minScale: 0.5,
									maxScale: 10,
									child: Image.network(
										file.url,
										width: 200,
										height: 200,
										fit: BoxFit.cover,
									),
								)
							);
						}
					);
				},
				contentPadding: EdgeInsets.all(10),
				leading: leading,
				title:Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children:[
						Text(
							file.name,
							style:TextStyle(
								fontSize: 17,
								fontWeight: FontWeight.w300,
								color: Colors.black
							),
						),
					]
				),
				trailing: IconButton(
					onPressed: () async{
						String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
						String filePath = path + '/' + file.name;
						bool exist = false;
						try{
							exist = await File(filePath).exists();
						}catch(e){}
						if (exist)
							openAttachment(filePath);
						else
							downloadAtachment(file, filePath);
					},
					icon:Icon(file.downloaded ? Icons.open_in_full : Icons.download_outlined)
				)
			),
		);
	}
	bool showLoading = false;
	void showSelectDialog(Attachment attachment)
	{
		int id = attachment.id;
		showLoading = false;
		showDialog(
			context: context,
			builder: (BuildContext context) {
				return StatefulBuilder(builder: (context, setState){
					return AlertDialog(
						title: Text('Add attachment'),
						content: Container(
							height: 120,
							child:Padding(
								padding: EdgeInsets.only(top: 30),
								child:Column(
									children: [
										Visibility(
											visible: showLoading,
											child:Text('please wait...')
										),
										Visibility(
											visible:!showLoading,
											child:Row(
												children: [
													FlatButton(
														onPressed: () async {
															setState((){showLoading = true;});
															var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
															if (pickedFile != null)
																uploadFile(pickedFile.path, id);
															else
																Navigator.of(context).pop();
														},
														child: Column(
															children:[
																Icon(AntDesign.camera,size: 60,),
																Text('open camera')
															]
														)
													),
													SizedBox(height: 20,),
													FlatButton(
														onPressed: () async{
															setState((){showLoading = true;});
															FilePickerResult result = await FilePicker.platform.pickFiles();

															if(result != null) {
																uploadFile(result.files.single.path, id);
															} else
																Navigator.of(context).pop();
														},
														child:
															Column(
																children:[
																	Icon(AntDesign.folder1,size: 60,),
																	Text('select file')
																]
															)
													)
												],
											)
										)
									]
								)
							)
						),
						actions: [
							FlatButton(
								onPressed: ()=>Navigator.of(context).pop(),
								child: Text('cancel')
							)
						],
					);
				});
			}
		);
	}


	void uploadFile(file, id) async
	{
		Globals.loading(context, 'please wait..');
		String url = Globals.url + '/api/attachments/$id/file';
		String filename = file;
		if (filename.contains('/'))
			filename = file.split('/').last;
		var formData = FormData.fromMap({
			"title": filename,
			"file": await MultipartFile.fromFile(file, filename: filename),
		});
		print('filename : ' + filename);
		Dio(
			BaseOptions(
				headers: {'Authorization' : 'Bearer ${Globals.token}'}
			)
		).post(
			url,
			data:formData
		).then((value) {
			print(value.statusCode.toString());
		}).catchError((e){
			print(e);
			Globals.progressDialog.hide();
			Globals.showAlertDialog(context, 'error', e.toString());
		}).then((value){
			Globals.progressDialog.hide();
			showLoading = false;
			if (ModalRoute.of(context).settings.name == 'viewattachments')
			{
				Navigator.of(context).pop();
				setState(() {
				  medicalFile.attachments = null;
				});
			}
		});
	}
}