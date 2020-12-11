
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class EditUserPage extends StatefulWidget{

	EditUserPage({Key key}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() => EditUserPageState();
		
	}
	
class EditUserPageState extends State<EditUserPage> {

  void extractArgs(){
		if (user != null)
		return;
		user = ModalRoute.of(context).settings.arguments;
		if (user == null)
		return;
		emailController.text = user.email.toString();
		phoneController.text = user.phone.toString();
		fnameController.text = user.firstName.toString();
		lnameController.text = user.lastName.toString();
		titleController.text = user.title.toString();
		dropdownValue = user.role;
	}

	User user;

  int dropdownValue;
	TextEditingController emailController = TextEditingController();
	TextEditingController fnameController = TextEditingController();
	TextEditingController lnameController = TextEditingController();
	TextEditingController phoneController = TextEditingController();
	TextEditingController titleController = TextEditingController();

  @override
	Widget build(BuildContext context) {
   	
		if (user == null)
      	extractArgs();

   	List<DropdownMenuItem<int>> c;
		c = Globals.accountTypes.map((value) {
			return DropdownMenuItem<int>(
				value: value.id,
				child: Row(children: [
					Icon(Icons.person),
					Text(value.title.toString())
				],),
			);
		}).toList();
	
		return Scaffold(
			backgroundColor:Globals.backgroundColor,
			appBar: AppBar(
				backgroundColor: Color.fromARGB(255, 64, 115, 158),
				title: Text('Edit User'),
			),
			body: SingleChildScrollView(
				child: Padding(
					padding: EdgeInsets.all(20),
					child: Column(
						children: [
							Image.asset('images/avatar.png'),
							Divider(height: 30,),
							Container(
								padding: EdgeInsets.only(top:5,bottom: 5,right: 20,left: 10),
								decoration:
								BoxDecoration(
									border: Border.all(),
									borderRadius:BorderRadius.all(Radius.circular(20)),
								),
								child:Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									children: [
										Row(
											children: [
												Icon(Icons.settings),
												VerticalDivider(),
												Text('account type : '),
											]
										),
										DropdownButton<int>(
											value: dropdownValue,
											icon: Icon(Icons.arrow_downward),
											iconSize: 24,
											elevation: 16,
											style: TextStyle(color: Colors.deepPurple),
											onChanged: (int newValue) {
												setState(() {
												dropdownValue = newValue;
												});
											},
											items: c,
										),
									]
								),
							),
							SizedBox(height: 20,),
							textField(hint:'Email', icon:Icon(Icons.mail), label: 'Email', controller: emailController),
							SizedBox(height: 20,),
							textField(hint:'First name', icon:Icon(Icons.person), label: 'First name', controller: fnameController),
							SizedBox(height: 20,),
							textField(hint:'Last name', icon:Icon(Icons.person), label: 'Last name', controller: lnameController),
							SizedBox(height: 20,),
							textField(hint:'Speciality', icon:Icon(Icons.description), label: 'Speciality', controller: titleController),
							SizedBox(height: 20,),
							textField(hint:'Phone number', icon:Icon(Icons.phone), label: 'Phone number', controller: phoneController),
							SizedBox(height: 20,),
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
			)
		);
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
			'role':dropdownValue
		};
		body.removeWhere((key,val)=>key=='email' && user.email == val.toString());
		Requests.post(
			Globals.url + '/api/admin/users/' + user.id.toString(), 
				body: body
		).then((value) {
			if (value.statusCode == 200)
				print('success');
			else
				print(value.statusCode.toString());
				Globals.usersList = List();
				Navigator.of(context).pushReplacementNamed('admin');
		}).catchError((e){print(e.toString());});
	}
}
