
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';

class AddUserPage extends StatefulWidget{

	AddUserPage({Key key}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() => AddUserPageState();
		
	}
	
class AddUserPageState extends State<AddUserPage> {

	User user;

	int dropdownValue = Globals.accountTypes[0].id;
	TextEditingController emailController = TextEditingController();
	TextEditingController fnameController = TextEditingController();
	TextEditingController lnameController = TextEditingController();
	TextEditingController phoneController = TextEditingController();
	TextEditingController passController = TextEditingController();
	TextEditingController titleController = TextEditingController();

	@override
	Widget build(BuildContext context) {
    
    List<DropdownMenuItem<int>> c = Globals.accountTypes.map((value) {
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
        title: Text('Add new User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Image.asset('images/avatar.png', width: 150,),
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
              ]),
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
            ]),
            ),
            SizedBox(height: 20,),
            textField(hint:'enter email', icon:Icon(Icons.mail), label: 'email', controller: emailController),
				SizedBox(height: 20,),
				textField(hint:'title', icon:Icon(Icons.description), label: 'title', controller: titleController),
				SizedBox(height: 20,),
				textField(obscure: true, hint:'enter password', icon:Icon(Icons.lock), label: 'password', controller: passController),
            SizedBox(height: 20,),
            textField(hint:'enter first name', icon:Icon(Icons.person), label: 'first name', controller: fnameController),
            SizedBox(height: 20,),
            textField(hint:'enter last name', icon:Icon(Icons.person), label: 'last name', controller: lnameController),
            SizedBox(height: 20,),
            textField(hint:'enter phone number', icon:Icon(Icons.phone), label: 'phone number', controller: phoneController),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text('save', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
              onPressed: (){
                var body = {
                      'email': emailController.text,
                      'first_name':fnameController.text,
                      'last_name':lnameController.text,
                      'phone':phoneController.text,
                      'role':dropdownValue,
                      'password':passController.text,
							 'title':titleController.text.toString()
                    };

                Requests.post(
                  Globals.url + '/api/register/', 
                		body: body
                ).then((value) {
                  if (value.statusCode == 200)
                  {
                    Globals.usersList = List();
                    Navigator.of(context).pushReplacementNamed('admin');
                    print('success');
                  }
                  else
                    print(value.statusCode.toString());
                }).catchError((e){print(e.toString());});
              },
              color: Color.fromARGB(255, 25, 42, 86),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            )
            ],)
          ),
      )
		);
	}
}