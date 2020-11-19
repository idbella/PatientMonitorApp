
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/views/UsersListView.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AdminHomePage extends StatefulWidget{

	AdminHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => AdminHomePageState();
		
	}
	
class AdminHomePageState extends State<AdminHomePage> {
  
  ProgressDialog pr;

	@override
	Widget build(BuildContext context) {

		return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton:
        Padding(
          padding: EdgeInsets.only(bottom: 40,right: 10),
          child:
            FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 68, 189, 50),
            onPressed: (){
              Navigator.of(context).pushNamed('add');
            },
            )
          ),
          backgroundColor:Color.fromARGB(255, 0, 168, 255),
          body:DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
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
          drawer:
          Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Update the state of the app.
                    // ...
                  },
                ),
              ],
            ),
          )

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