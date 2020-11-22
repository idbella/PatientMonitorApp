import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';


  void refreshPatientsList(BuildContext context, Function setState, [bool reload=false,])
  {

    List<dynamic> list;

    if (reload || Globals.patientsList.isEmpty)
    {
      Globals.patientsList = List();
    
      listPatients().then((value) {

        print('code = ' + value.statusCode.toString());
        if (value.statusCode == 200)
        {
          list = value.json();
          list.forEach((element) {
            Patient patient = Patient.fromjson(element);
            Globals.patientsList.add(patient);
            setState((){});
          });
        }
        else if (value.statusCode == 401)
          Navigator.pushNamed(context, 'login');
      })
      .catchError((err)=>print('errr = ' + err.toString()));
    }
  }
  
Future<Response> listPatients()
{
  return Requests.get(Globals.url.toString() + '/api/patients/');
}
