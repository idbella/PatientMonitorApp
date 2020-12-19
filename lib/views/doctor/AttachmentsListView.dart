
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/Doctor.dart';
import 'package:PatientMonitorMobileApp/models/MedicalFile.dart';
import 'package:PatientMonitorMobileApp/models/Nurse.dart';
import 'package:PatientMonitorMobileApp/models/attachment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:PatientMonitorMobileApp/views/doctor/ArView.dart';
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

class AttachmentsListView extends StatefulWidget {
	final MedicalFile medicalFile;

	AttachmentsListView({Key key, this.medicalFile}) : super(key: key);
	@override
	State<StatefulWidget> createState() => AttachmentsListViewState(medicalFile);
}
  
class AttachmentsListViewState  extends State<AttachmentsListView>{

	final MedicalFile medicalFile;

	AttachmentsListViewState(this.medicalFile);

	void getAttachments()
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
							int userId = element['userId'];
							var nurses = Globals.nurses;
							var doctors = Globals.doctors;
							if (doctors != null && doctors.isNotEmpty)
							{
								Doctor doc = doctors.firstWhere((doctor) => doctor.user.id == userId);
								if (doc != null)
									attachment.user = doc.user;
							}
							if (attachment.user == null && nurses != null && nurses.isNotEmpty)
							{
								Nurse nurse = nurses.firstWhere((nurse) => nurse.user.id == userId);
								if (nurse != null)
									attachment.user = nurse.user;
							}
							print(attachment.user);
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

		getAttachments();
		List<Widget> list = List();
		
		if (medicalFile.attachments == null)
			return Center(child:Column(children:[SizedBox(height:100),Text('Loading...')]));
		if (medicalFile.attachments.isEmpty)
			return Center(child:Column(children:[SizedBox(height:100),Text('No Attachments to show...')]));

		medicalFile.attachments.forEach((Attachment attachment) {

			Widget wi = Card(
				margin: EdgeInsets.symmetric(vertical:10),
				elevation: 20,
				color: Colors.green[300],
				child:Column(
					children: [
						Card(
							color: Colors.green,
							elevation: 2,
							margin: EdgeInsets.all(2),
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
															attachment.user.fullName().toString(),
															style: TextStyle(
																fontWeight: FontWeight.w800,
																color: Colors.black
															),
														),
														Text(
															attachment.user.title.toString(),
															style: TextStyle(
																fontWeight: FontWeight.w300,
																color: Colors.black
															),
														),
														SizedBox(height: 5,),
														Text(DateFormat('yMMMMd').format(attachment.date) + ' ' + DateFormat('jm').format(attachment.date),
															style: TextStyle(fontSize: 10,color: Colors.black),
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
														icon:Icon(Icons.delete,color: Colors.black,),
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
													color: Colors.blue,
													onPressed: (){
														showSelectDialog(attachment);
													},
													child:Row(
													children: [
														Icon(Icons.add, color: Colors.white),
														Text('add ', style: TextStyle(color: Colors.white),),
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
		Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ARView(image: fileName,)));
		//OpenFile.open(fileName);
	}

	Future<bool> isDownloaded(AttachFile file) async {
		String path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
		path = path.toLowerCase();
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
		{
			leading = CachedNetworkImage(
				httpHeaders: Globals.headers(),
				imageUrl: file.url,
				placeholder: (context, url) => CircularProgressIndicator(),
				errorWidget: (context, url, error) => Icon(Icons.error),
			);
		}
		if (!file.downloaded)
			isDownloaded(file).then((value) {
				if (value == true)
					setState(() {
						file.downloaded = true;
					});
			});
		return Card(
			color: Colors.green[200],
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
									child: CachedNetworkImage(
										httpHeaders: Globals.headers(),
										imageUrl: file.url,
										placeholder: (context, url) => CircularProgressIndicator(),
										errorWidget: (context, url, error) => Icon(Icons.error),
									)
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
				trailing:IconButton(
					onPressed: () async {
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
				),
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
															{
																openAttachment(pickedFile.path);
																uploadFile(pickedFile.path, id);
															}
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