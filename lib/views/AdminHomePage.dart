
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/views/UsersListView.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';

class AdminHomePage extends StatefulWidget{

	AdminHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => AdminHomePageState();
		
	}
	
class AdminHomePageState extends State<AdminHomePage> {
  
  ProgressDialog pr;

  void logoutButton(){
    logout().then((value) {
      if (value.statusCode == 200)
        print('logged out');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(checkLogin: false,)));
      }
    ).catchError((err){
      print(err.toString());
    });
  }

	@override
	Widget build(BuildContext context) {

		return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton:Padding(
        padding: EdgeInsets.only(bottom: 40,right: 10),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 68, 189, 50),
          onPressed: (){
            Navigator.of(context).pushNamed('adduser');
          },
        )
      ),
      backgroundColor:Color.fromARGB(255, 0, 168, 255),
      body:DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Globals.backgroundColor,
          appBar: AppBar(
            actions: [
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: logoutButton,)
            ],
            backgroundColor: Color.fromARGB(255, 64, 115, 158),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.person), text: 'doctors',),
                Tab(icon: Icon(Icons.person), text: 'nurses',),
                Tab(icon: Icon(Icons.person), text: 'receptionists',)
              ],
            ),
            title: Text('Manage Users'),
          ),
          body: TabBarView(
            children: [
              UsersList(2),
              UsersList(3),
              UsersList(5)
            ],
          ),
        ),
      ),
    );
	}

  void showAlertDialog(BuildContext context) {
    // set up the button

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Loading"),
      content: Text("Please wait..."),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}