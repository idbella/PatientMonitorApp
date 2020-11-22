
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';

class AccountType{
  int id;
  String title;
  AccountType(this.id, this.title);
}

class Globals{
  static String url = 'http://10.30.248.2:8080';
  static List<User> usersList = List();
  static List<Patient> patientsList = List();
  static int adminId = 1;
  static int nurseId = 3;
  static int doctorId = 2;
  static int recepId = 5;
  static int patientId = 4;

  static Color backgroundColor = Color.fromARGB(255, 220, 221, 225);
  
  static List<AccountType> accountTypes = List.from(
    [
      AccountType(2,'doctor'),
      AccountType(3,'nurse'),
      AccountType(5,'receptionist'),
    ]
  );
}
