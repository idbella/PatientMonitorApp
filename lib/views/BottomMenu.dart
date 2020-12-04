
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/views/Admin/AdminHomePage.dart';
import 'package:PatientMonitorMobileApp/views/Reception/ListPatients.dart';
import 'package:PatientMonitorMobileApp/views/Reception/RecepHomePage.dart';
import 'package:PatientMonitorMobileApp/views/doctor/DoctorHomePage.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatefulWidget {
	final selectedIndex;
	const BottomMenu({Key key, this.selectedIndex}) : super(key: key);
	@override
	_BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {

	void goHome()
	{
		StatefulWidget page;
		if (Globals.user.role == Globals.adminId)
			page = AdminHomePage();
		else if (Globals.user.role == Globals.recepId)
			page = RecepHomePage();
		else if (Globals.user.role == Globals.doctorId)
			page = DoctorHomePage();
		else if (Globals.user.role == Globals.nurseId)
			page = DoctorHomePage();
		Navigator.push(
			context,
			MaterialPageRoute(builder: (context) => page)
		);
	}

  @override
  Widget build(BuildContext context) {
	 return BottomNavigationBar(
			items: const <BottomNavigationBarItem>[
			BottomNavigationBarItem(
				icon: Icon(Icons.home),
				label: 'Home',
			),
			BottomNavigationBarItem(
				icon: Icon(Icons.people),
				label: 'Patients',
			),
			BottomNavigationBarItem(
				icon: Icon(Icons.person),
				label: 'Profile',
			),
			],
			currentIndex: widget.selectedIndex,
			selectedItemColor: Colors.amber[800],
			onTap:(index){
				if (index == 0)
					goHome();
				else if (index == 1)
					Navigator.push(
						context,
						MaterialPageRoute(builder: (context) => ListPatientsPage())
					);
			},
		);
  }
}