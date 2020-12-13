import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';


	Future<ResponseX> listPatients()
	{
		return Requests.get(Globals.url.toString() + '/api/patients/');
	}
