

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentsView extends StatefulWidget {
  @override
  _AppointmentsViewState createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('Appointments'),
			),
			body: SfCalendar(
				dataSource: _getCalendarDataSource(),
				view: CalendarView.month,
				monthViewSettings: MonthViewSettings(showAgenda: true),
			)
		);
  }

	_AppointmentDataSource _getCalendarDataSource() {
		List<Appointment> appointments = <Appointment>[];
		appointments.add(Appointment(
			startTime: DateTime.now(),
			endTime: DateTime.now().add(Duration(minutes: 10)),
			subject: 'Meeting',
			color: Colors.blue,
			startTimeZone: '',
			endTimeZone: '',
		));
  		return _AppointmentDataSource(appointments);
	}
}
class _AppointmentDataSource extends CalendarDataSource {
	_AppointmentDataSource(List<Appointment> source){
		appointments = source; 
	}
}