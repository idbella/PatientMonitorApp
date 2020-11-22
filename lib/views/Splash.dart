

import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
import 'package:PatientMonitorMobileApp/views/RecepHomePage.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class SplashPage extends StatefulWidget{
  static bool displayed = false;
  SplashPage({this.title,Key key}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => SplashPageState();

}

class SplashPageState extends State<SplashPage>{

  String errorString = '';
  bool errorVisibility = false;

  void connect(BuildContext context){
    Requests.get(Globals.url + '/api/profile')
    .then((value) {
      print('check : ' + value.statusCode.toString());
      var status = value.statusCode;
      if (status == 200){
        var json = value.json();
          if (json['role'] == Globals.adminId)
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHomePage()));
          else if (json['role'] == Globals.recepId)
          {
            print('switch to recep page');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RecepHomePage()));
          }
      }
      else
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage(title:'login')));
      }
    )
    .catchError((err){
        
        print('check error : ' + err.toString());
        setState(() {
          errorString = err.toString();
          errorVisibility = true;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (errorVisibility == false)
      connect(context);

    return Scaffold(
			backgroundColor:Globals.backgroundColor,
			body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('please wait...'),
            Visibility(
              visible: errorVisibility,
              child: Column(
                children:[
                Text('network Erro please verify you internet connection'),
                Text(errorString),
                RaisedButton(
                  child: Text('Retry', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
                  onPressed: (){
                    setState(() {
                      errorVisibility = false;
                    });
                    //connect(context);
                    },
                  color: Color.fromARGB(255, 25, 42, 86),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  )
                ]
              )
            )
          ],
        )
      )
    );
  }
}