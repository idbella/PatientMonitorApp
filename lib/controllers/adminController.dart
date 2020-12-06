import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';


  void refreshUserList(BuildContext context, Function setState, [bool reload=false])
  {

    List<dynamic> list;

    if (reload || Globals.usersList.isEmpty)
    {
      Globals.usersList = List();
    
      listUsers().then((value) {

        print('code4 = ' + value.statusCode.toString());
        if (value.statusCode == 200)
        {
          list = value.json();
          list.forEach((element) {
            User user = User.fromjson(element);
            Globals.usersList.add(user);
          });
			 if (setState != null)
          	setState((){});
        }
        else if (value.statusCode == 401)
          Navigator.pushNamed(context, 'login');
      })
      .catchError((err)=>print('err = ' + err.toString()))
      .then((value) {

      });
    }
  }
  
Future<ResponseX> listUsers()
{
  return Requests.get(Globals.url.toString() + '/api/admin/users/');
}

Future<SharedPreferences> logout(){
	Globals.patientsList = null;
	Globals.usersList  = List();
	Globals.user = null;
	Globals.token = null;
	return SharedPreferences.getInstance();
}
