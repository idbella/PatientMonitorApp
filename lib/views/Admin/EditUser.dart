
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:requests/requests.dart';

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
    dropdownValue = user.role;
  }

	User user;

  int dropdownValue;
	TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
							textField(hint:'enter email', icon:Icon(Icons.mail), label: 'email', controller: emailController),
							SizedBox(height: 20,),
							textField(hint:'enter first name', icon:Icon(Icons.person), label: 'first name', controller: fnameController),
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
								},
								color: Colors.green,
								shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
							)
						]
					)
				),
			)
		);
	}
}
