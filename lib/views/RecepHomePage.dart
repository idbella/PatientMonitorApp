

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/views/PatientsListView.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RecepHomePage extends StatefulWidget{

	RecepHomePage({Key key, this.title}) : super(key: key);
	
	final String title;
	
	@override
	State<StatefulWidget> createState() => RecepHomePageState();
		
	}
	
class RecepHomePageState extends State<RecepHomePage> {
  
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
              Navigator.of(context).pushNamed('add').whenComplete(() {
                setState(() {
                  
                });
              });
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
                  ],
                ),
                title: Text('Manage Users'),
              ),
              body: TabBarView(
                children: [
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

    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}