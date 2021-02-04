

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/controllers/Login.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/Admin/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Reception/ListPatients.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  final bool checkLogin;
  LoginPage({Key key,this.checkLogin = true}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState(this.checkLogin);

}

class LoginPageState extends State<LoginPage>{

	String	errorString			= '';
	bool		errorVisibility	= false;
	bool		showLoginPage		= false;
	bool		showError			= true;
	bool		disableButton		= false;
	bool		checkLogin			= true;

	TextEditingController emailTextController		= TextEditingController();
	TextEditingController passwordTextController	= TextEditingController();

	LoginPageState(this.checkLogin){
		if (checkLogin == false)
			showLoginPage = true;
		emailTextController.text = 'doctor';
		passwordTextController.text = 'admin';//'kECnFjHN';
	}
	void signIn()
	{
		Requests.get(Globals.url + '/api/profile')
		.then((value) {
			print('check : ' + value.content().toString());
			var status = value.statusCode;
			if (status == 200){
				var json = value.json();
				authenticated(json);
			}
			else {
				Globals.token = null;
				SharedPreferences.getInstance().then((value){
					value.remove('token');
					setState(() {
						showLoginPage = true;
					});
				});
			}
		})
		.catchError((err){
			print('server = ' + Globals.url.toString());
			print('check error : ' + err.toString());
			setState(() {
				errorString = 'network Error please verify your internet connection';
				errorVisibility = true;
			});
		});
	}

	void connect(BuildContext context){

		Globals.storageGet('token').then((value) {
			Globals.token = value;
			print('value = ' + value);
			signIn();
		}).catchError((e){
			setState(() {
				showLoginPage = true;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		
		if (checkLogin){
			connect(context);
			checkLogin = false;
		}

   	return Scaffold(
			backgroundColor:Color.fromARGB(255, 0xd1,0xee,0xfe),
		   body: SafeArea(
				child:SingleChildScrollView(
					child:Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							ClipPath(
								child:Container(
									height: 300,
									width: MediaQuery.of(context).size.width,
									decoration: BoxDecoration(
										image: DecorationImage(
											image: AssetImage('images/splash.jpg'),
											fit:BoxFit.fill 
										)
									),
								),
								clipper: ImageClipper(),
							),
							SizedBox(),
							Visibility(
								visible: !errorVisibility && !showLoginPage,
								child:Column(
									children:[
										SizedBox(height: 50,),
										Text('please wait...',
										style: TextStyle(
											color: Color.fromARGB(255, 25, 42, 86),
											fontSize: 30
										),
									)]
								)
							),
							Visibility(
								visible: errorVisibility,
								child: Column(
									children:[
										SizedBox(height: showLoginPage?0:50,),
										Row(
											mainAxisAlignment: MainAxisAlignment.center,
											children: [
												Icon(Icons.info,color: Colors.red,),
												SizedBox(width: 5,),
												Text(
													errorString,
													style: TextStyle(
														color: Colors.red,
														fontSize: 15,
														fontWeight: FontWeight.w300
													)
												),
											]
										),
										SizedBox(height: showLoginPage?0:50,),
										Visibility(
											visible: !showLoginPage,
											child: RaisedButton(
												child: Text('Retry', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
												onPressed: (){
													setState(() {
														errorVisibility = false;
													});
													connect(context);
												},
												color: Color.fromARGB(255, 25, 42, 86),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
											)
										)
									]
								)
							),
							Visibility(
								visible: showLoginPage,
								child: Padding(
									padding: EdgeInsets.all(30),
									child:getLoginPage(context))
							)
						],
					)
				)
			)
   	);
	}

	Widget getLoginPage(BuildContext context){

		if (pr == null)
		{
			pr = ProgressDialog(context);
			pr.style(
				message: 'Signing in...',
				borderRadius: 1.0,
				backgroundColor: Color.fromARGB(255, 220, 221, 225),
				progressWidget: CircularProgressIndicator(),
				elevation: 10.0,
				insetAnimCurve: Curves.easeInOut,
				progress: 0.0,
				maxProgress: 100.0,
				progressTextStyle: TextStyle(
					color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
				messageTextStyle: TextStyle(
					color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600)
			);
		}
	  	return (
			Center(
				child:Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>
					[
						Text(
							'Authenticate',
							style: TextStyle(
								color: Color.fromARGB(255, 25, 42, 86),
								fontSize: 32,
								fontWeight: FontWeight.w400
							),
						),
						SizedBox(height: 50,),
						textField(
							hint:'email',
							label:'email',
							icon: Icon(Icons.email,color: Color.fromARGB(255, 25, 42, 86)),
							controller: emailTextController
						),
						SizedBox(height: 30,),
						textField(
							obscure: true,
							hint:'password',
							label:'password',
							controller: passwordTextController,
							icon: Icon(Icons.vpn_key)
						),
						SizedBox(height: 40,),
						FlatButton(
							child: Text(
								'Login',
								style: TextStyle(
									color: Color.fromARGB(255, 245, 246, 250),
									fontSize: 18
								),
							),
							padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
							onPressed: disableButton ? null : loginButtonOnClick,
							color: Colors.blue,
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
						),
						SizedBox(height: 20,),
						FlatButton(
							onPressed: (){print('ok');},
							child:Text(
								'Forgot Password ?',
								style: TextStyle(
									fontSize: 14,
									fontWeight: FontWeight.w300
								),
							)
						)
					],
				),
			)
		);
	}

	ProgressDialog pr;

	void loginButtonOnClick(){

		String email = emailTextController.text;
		String password = passwordTextController.text;

		setState(() {
			disableButton = true;
			showError = false;
		});

		pr.show();
		authenticate(email, password)
		.then((value) {
			pr.hide();
			print(value.statusCode);
			if (value.statusCode == 404){
				setState(() {
					errorVisibility = true;
					errorString = "Error : invalid email or password";
				});
			}
			else if (value.statusCode == 200){
				
				var json = value.json();
				SharedPreferences.getInstance()
					.then((prefs){
						Globals.token = json['token'];
						prefs.setString('token', json['token'])
							.then((value){
								authenticated(json);
							});
					});
			}
		})
		.catchError((e) {
			pr.hide();
			Globals.showAlertDialog(context, 'error', e.toString());
		})
		.then((value){
			pr.hide();
			setState(() {
				disableButton = false;
			});
		});
	}

	void authenticated(json)
	{
		Globals.init();
		
		Globals.user = User.fromjson(json);
		StatefulWidget page;
		if (json['role'] == Globals.adminId)
			page = AdminHomePage();
		else if (json['role'] == Globals.recepId)
			page = RecepHomePage();
		else if (json['role'] == Globals.doctorId)
			page = ListPatientsPage();
		else if (json['role'] == Globals.nurseId)
			page = ListPatientsPage();
		Navigator.pushAndRemoveUntil(context,
			MaterialPageRoute(builder: (BuildContext context) => page),
			(Route<dynamic> route) => false,
		);
	}
}
