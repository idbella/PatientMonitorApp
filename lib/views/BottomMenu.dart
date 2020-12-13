
import 'package:PatientMonitorMobileApp/globals.dart';
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
		String page;
		if (Globals.user.role == Globals.adminId)
			page = 'admin';
		else if (Globals.user.role == Globals.recepId)
			page = 'recep';
		else if (Globals.user.role == Globals.doctorId)
			page = 'listpatients';
		else if (Globals.user.role == Globals.nurseId)
			page = 'listpatients';
		if (ModalRoute.of(context).settings.name != page)
			Navigator.pushNamed(context, page);
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
				{
					if (ModalRoute.of(context).settings.name != 'listpatients')
						Navigator.pushNamed(context, 'listpatients');
				}
				else if (index == 2)
				{
					if (ModalRoute.of(context).settings.name != 'profile')
						Navigator.pushNamed(context, 'profile');
				}

			},
		);
  }
}