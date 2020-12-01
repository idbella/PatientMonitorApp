import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';


  void refreshPatientsList(BuildContext context, Function setState, [bool reload=false,])
  {

   	List<dynamic> list;

		if (reload || Globals.patientsList == null)
		{
      	Globals.patientsList = null;
    
      	listPatients().then((value) {
				if (value.statusCode == 200)
				{
					list = value.json();
					if (list.isNotEmpty) {
						Globals.patientsList = List();
						list.forEach((element) {
							Patient patient = Patient.fromjson(element);
							Globals.patientsList.add(patient);
						});
						setState((){});
					}
				}
				else if (value.statusCode == 401)
					Navigator.pushReplacementNamed(context, 'login');
			})
      	.catchError((err){
				print('errr = ' + err.toString());
			});
   	}
	}

	Future<Response> listPatients()
	{
		return Requests.get(Globals.url.toString() + '/api/patients/');
	}
