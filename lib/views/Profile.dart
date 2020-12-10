
import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:PatientMonitorMobileApp/views/Drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class Profile extends StatefulWidget{

	Profile({Key key}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() => ProfileState();
		
	}
	
class ProfileState extends State<Profile> {


	ProfileState(){
		emailController.text = user.email.toString();
   	phoneController.text = user.phone.toString();
   	fnameController.text = user.firstName.toString();
   	lnameController.text = user.lastName.toString();
		titleController.text = user.title.toString();
	}

	User user = Globals.user;

	TextEditingController emailController = TextEditingController();
	TextEditingController fnameController = TextEditingController();
	TextEditingController lnameController = TextEditingController();
	TextEditingController phoneController = TextEditingController();
	TextEditingController titleController = TextEditingController();

  @override
	Widget build(BuildContext context) {
	
		return Scaffold(
			bottomNavigationBar: BottomMenu(selectedIndex: 2),
			drawer: UserDrawer(),
			backgroundColor:Globals.backgroundColor,
			body:Builder(
				builder:(context){
					return SafeArea(
						child:SingleChildScrollView(
							child: Stack(
								children: [
									ClipPath(
										child:Container(
											height: 230,
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
									Positioned(
										top:20,
										right: 20,
										child:IconButton(
											icon: Icon(Icons.menu),
											onPressed: (){
												Scaffold.of(context).openDrawer();
											}
										),
									),
									Padding(
										padding: EdgeInsets.all(20),
										child: Column(
											mainAxisAlignment: MainAxisAlignment.center,
											crossAxisAlignment: CrossAxisAlignment.center,
											children: [
												SizedBox(height: 10,),
												Row(
													children: [
														CircleAvatar(
															radius: 50,
															backgroundImage:Image.asset(Globals.user.role == Globals.doctorId ? 'images/doctor.jpg' : 'images/avatar.png').image,
														),
														SizedBox(width: 10,),
														Column(
															mainAxisAlignment: MainAxisAlignment.center,
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Divider(height: 8,),
																Text(
																	user.lastName.toString() + ' ' + user.firstName.toString(),
																	style: TextStyle(
																		fontSize: 16,
																		fontWeight: FontWeight.w500
																	),
																),
																Text(
																	user.title.toString(),
																	style: TextStyle(
																		fontSize: 15,
																		//fontWeight: FontWeight.w200
																	),
																	overflow: TextOverflow.ellipsis,
																),
																SizedBox(height: 5,),
																Text(user.email.toString()),
																SizedBox(height: 5,),
																Text(user.phone.toString())
															]
														)
													]
												),
												SizedBox(height: 50,),
												Divider(height: 30,),
												SizedBox(height: 20,),
												textField(hint:'enter email', icon:Icon(Icons.mail), label: 'email', controller: emailController),
												SizedBox(height: 20,),
												textField(hint:'enter first name', icon:Icon(Icons.person), label: 'first name', controller: fnameController),
												SizedBox(height: 20,),
												textField(hint:'enter title', icon:Icon(Icons.description), label: 'title', controller: titleController),
												SizedBox(height: 20,),
												textField(hint:'enter last name', icon:Icon(Icons.person), label: 'last name', controller: lnameController),
												SizedBox(height: 20,),
												textField(hint:'enter phone number', icon:Icon(Icons.phone), label: 'phone number', controller: phoneController),
												SizedBox(height: 20,),
												RaisedButton(
													child: Text(
														'save', 
														style: TextStyle(
															color: Color.fromARGB(255, 245, 246, 250)
														),
													),
													onPressed: (){
														var body = {
																'email': emailController.text,
																'first_name':fnameController.text,
																'last_name':lnameController.text,
																'phone':phoneController.text,
															};
														body.removeWhere((key,val)=>key=='email' && user.email == val.toString());
														Requests.post(
															Globals.url + '/api/user/users/' + user.id.toString(), 
																body: body
														).then((value) {
															if (value.statusCode == 200)
															{
																Globals.user.email = emailController.text.toString();
																Globals.user.title = titleController.text.toString();
																Globals.user.firstName = fnameController.text.toString();
																Globals.user.lastName = lnameController.text.toString();
																setState(() {
																  
																});
															}
														}).catchError((e){print(e.toString());});
													},
													color: Colors.green,
													shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
												)
											]
										)
									),
								]
							)
						)
					);
				}
			)
		);
	}
}
