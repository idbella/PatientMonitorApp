

import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/LoginPage.dart';
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

  @override
  Widget build(BuildContext context) {
    print('building splash');
    Requests.get(Globals.url + '/api/profile')
      .then((value) => {
        print('check : ' + value.statusCode.toString()),
          if (value.statusCode == 200){
            Globals.logged = true,
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminHomePage())),
          }
          else
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage(title:'login'))),

        }
      ).catchError((err)=>{print('check error : ' + err.toString())});


    return Scaffold(
			backgroundColor:Color.fromARGB(255, 0, 168, 255),
			body:Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('please wait...')],
        )
      )
    );
  }
}