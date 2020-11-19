
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:PatientMonitorMobileApp/controllers/Login.dart';
import 'package:PatientMonitorMobileApp/views/AdminHomePage.dart';

class LoginPage extends StatefulWidget {
	LoginPage({Key key, this.title}) : super(key: key);

	final String title;

	@override
	LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

	ProgressDialog pr;

	bool showError = true;
	String errorString = '';
	bool disableButton = false;

	TextEditingController emailTextController = TextEditingController();
	TextEditingController passwordTextController = TextEditingController();

	void loginButtonOnClick(){

		String email = emailTextController.text;
		String password = passwordTextController.text;

		setState(() {
			disableButton = true;
			showError = false;
		});

		pr.show();
		authenticate(email, password)
			.then((value) => {
				print(value.statusCode),
				if (value.statusCode == 404){
					setState(() {
						showError = true;
						errorString = "email/password invalid : " + value.statusCode.toString();
					})
				}
        else if (value.statusCode == 200 || value.statusCode == 401){
          pr.hide(),
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminHomePage()))
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

	@override
	Widget build(BuildContext context) {
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
		return Scaffold(
			backgroundColor:Color.fromARGB(255, 0, 168, 255),
			appBar: AppBar(
				title: Text(widget.title),
				backgroundColor: Color.fromARGB(255, 64, 115, 158),
			),
			body:
			SingleChildScrollView(
				child:Padding(
					padding: EdgeInsets.all(40),
					child: Center(
						child:Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: <Widget>[
							Icon(Icons.person, size: 200,color: Color.fromARGB(255, 47, 54, 64),),
							SizedBox(height: 40,),
							Theme(
							data:  ThemeData(
								primaryColor: Color.fromARGB(255, 225, 177, 44),
								primaryColorDark: Colors.red,
							),
							child:  TextField(
								controller: emailTextController,
								decoration:  InputDecoration(
										border:  OutlineInputBorder(
											borderRadius: BorderRadius.all(Radius.circular(20)),
											borderSide:  BorderSide(color: Colors.teal)),
										hintText: 'enter your email',
										labelText: 'email',
										prefixIcon: const Icon(
											Icons.person,
											color: Color.fromARGB(255, 25, 42, 86),
										),
										prefixText: ' ',
										suffixStyle: const TextStyle(color: Colors.green)),
							),
						),
						SizedBox(height: 40,),
						Theme(
							data:  ThemeData(
								primaryColor: Color.fromARGB(255, 68, 189, 50),
								primaryColorDark: Colors.red,
							),
							child:  TextField(
								controller: passwordTextController,
								obscureText: true,
								decoration:  InputDecoration(
										border:  OutlineInputBorder(
											borderRadius: BorderRadius.all(Radius.circular(20)),
											borderSide:  BorderSide(
												color: Color.fromARGB(255, 39, 60, 117),
												width: 20)),
										hintText: 'enter your password',
										labelText: 'password',
										prefixIcon: const Icon(
											Icons.vpn_key,
											color: Color.fromARGB(255, 25, 42, 86),
										),
										prefixText: ' ',
										suffixStyle: const TextStyle(color: Colors.green)),
							),
						),
						Padding(
							padding: EdgeInsets.only(top:30,bottom: 30),
							child: showError ? Text(
									errorString, 
									style: TextStyle(
										color: Color.fromARGB(255, 232, 65, 24)
									)
								) : null,
						),
						RaisedButton(
							child: Text('Connexion', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
							onPressed: disableButton ? null : loginButtonOnClick,
							color: Color.fromARGB(255, 25, 42, 86),
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
							)
						],
					),
				)
				),
			)
		);
	}
}
