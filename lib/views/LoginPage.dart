

import 'package:PatientMonitorMobileApp/Clipper.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/controllers/Login.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/views/Admin/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:requests/requests.dart';

class LoginPage extends StatefulWidget{
  final bool checkLogin;
  LoginPage({this.title,Key key,this.checkLogin = true}) : super(key: key);

  final String title;

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
		emailTextController.text = 'recep';
		passwordTextController.text = 'admin';
	}

	void connect(BuildContext context){
		Requests.get(Globals.url + '/api/profile')
		.then((value) {
			print('check : ' + value.statusCode.toString());
			var status = value.statusCode;
			if (status == 200){
				Globals.getInsurances();
				var json = value.json();
				Globals.user = User.fromjson(json);
				if (json['role'] == Globals.adminId)
					Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
				else if (json['role'] == Globals.recepId)
					Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecepHomePage()));
			}
			else {
				setState(() {
				  showLoginPage = true;
				});
			}
		})
		.catchError((err){
			print('check error : ' + err.toString());
			setState(() {
				errorString = 'network Error please verify you internet connection';
				errorVisibility = true;
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
										SizedBox(height: 50,),
										Text(errorString),
										SizedBox(height: 50,),
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
								fontWeight: FontWeight.w500
							),
						),
						SizedBox(height: 30,),
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
						SizedBox(height: 25,),
						FlatButton(
							child: Text(
								'Connexion',
								style: TextStyle(
									color: Color.fromARGB(255, 245, 246, 250),
									fontSize: 18
								),
							),
							padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
							onPressed: disableButton ? null : loginButtonOnClick,
							color: Colors.blue,
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
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
			print(value.statusCode);
			if (value.statusCode == 404){
				setState(() {
					showError = true;
					errorString = "email/password invalid : " + value.statusCode.toString();
				});
			}
			else if (value.statusCode == 200){
				Globals.getInsurances();
				pr.hide();
				var json = value.json();
				Globals.user = User.fromjson(json);
				if (json['role'] == Globals.adminId)
					Navigator.pushReplacement(
						context,
						MaterialPageRoute(builder: (context) => AdminHomePage())
					);
				else if (json['role'] == Globals.recepId)
					Navigator.pushReplacement(
						context,
						MaterialPageRoute(builder: (context) => RecepHomePage())
					);
			}
		})
		.catchError((e) => print(e))
		.then((value) => {
			setState(() {
				disableButton = false;
			}),
			pr.hide()
		});
	}
}
