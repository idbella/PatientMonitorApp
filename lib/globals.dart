
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';

class AccountType{
  int id;
  String title;
  AccountType(this.id, this.title);
}

class Globals{
  static String url;
  static var data;
  static bool logged;
  static List<User> usersList;
  static List<Patient> patientsList;

  static Color backgroundColor = Color.fromARGB(255, 245, 246, 250);
  
  static List<AccountType> accountTypes = List.from(
    [
      AccountType(2,'doctor'),
      AccountType(3,'nurse'),
      AccountType(5,'receptionist'),
    ]
  );
}
