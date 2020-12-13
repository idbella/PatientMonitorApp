
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
		passwordController.text = '******';
	}

	User user				= Globals.user;
	bool changePassword	= false;

	TextEditingController emailController = TextEditingController();
	TextEditingController fnameController = TextEditingController();
	TextEditingController lnameController = TextEditingController();
	TextEditingController phoneController = TextEditingController();
	TextEditingController titleController = TextEditingController();
	TextEditingController passwordController = TextEditingController();

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
												textField(hint:'enter last name', icon:Icon(Icons.person), label: 'last name', controller: lnameController),
												SizedBox(height: 20,),
												textField(hint:'speciality', icon:Icon(Icons.description), label: 'speciality', controller: titleController),
												SizedBox(height: 20,),
												textField(hint:'enter phone number', icon:Icon(Icons.phone), label: 'phone number', controller: phoneController),
												SizedBox(height: 20,),
												Stack(
													children: <Widget>[
														Container(
															width: double.infinity,
															height: 120,
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
																child: FlatButton(
																	onPressed: ()=>onChangePasswordClicked(!changePassword),
																	child:Row(
																		children:[
																			SizedBox(
																				width: 30,
																				child:Checkbox(
																					value: changePassword,
																					onChanged:onChangePasswordClicked
																				),
																			),
																			Text(
																				'Change Password',
																				style: TextStyle(color: Colors.black, fontSize: 14),
																			)	
																		]
																	)
																)
															)
														),
														Padding(
															padding: EdgeInsets.symmetric(horizontal:10,vertical: 50),
															child:textField(obscure: true,readOnly: !changePassword,hint:'password', icon:Icon(Icons.vpn_key), label: 'password', controller: passwordController),
														),
													],
												),
												RaisedButton(
													child: Text(
														'save', 
														style: TextStyle(
															color: Color.fromARGB(255, 245, 246, 250)
														),
													),
													onPressed: ()=>editUser(),
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
	void onChangePasswordClicked(value)
	{
		if (value)
			passwordController.text = '';
		else
			passwordController.text = '******';
		setState(() => changePassword = value);
	}
	String check(){
		if (emailController.text.length <= 0)
			return 'email';
		if (titleController.text.length <= 0)
			return 'speciality';
		if (fnameController.text.length <= 0)
			return 'first name';
		if (lnameController.text.length <= 0)
			return 'last name';
		if (phoneController.text.length <= 0)
			return 'phone number';
		if (changePassword && passwordController.text.length <= 0)
			return 'password';
		return null;
	}
	void editUser()
	{
		String field;
		if ((field = check()) != null)
		{
			Globals.showAlertDialog(context, 'Missing fields', '$field is required');
			return;
		}
		var body = {
			'email': emailController.text,
			'first_name':fnameController.text,
			'last_name':lnameController.text,
			'phone':phoneController.text,
			'password':passwordController.text,
			'title':titleController.text
		};
		if (!changePassword)
			body.removeWhere((key,val)=>key=='password');
		body.removeWhere((key,val)=>key=='email' && user.email == val.toString());
		print(body.toString());
		Requests.post(
			Globals.url + '/api/users/' + user.id.toString(), 
				body: body
		).then((value) {
			if (value.statusCode == 200)
			{
				Globals.user.email = emailController.text.toString();
				Globals.user.title = titleController.text.toString();
				Globals.user.firstName = fnameController.text.toString();
				Globals.user.lastName = lnameController.text.toString();
				setState(() {});
			}
			else
				Globals.showAlertDialog(context, 'error', value.content());
		}).catchError((e){
			Globals.showAlertDialog(context, 'error', e.toString());
		});
}
}
