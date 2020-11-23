
import 'package:PatientMonitorMobileApp/controllers/Login.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:requests/requests.dart';

class InsurancePage extends StatefulWidget{

	InsurancePage({Key key}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() => InsurancePageState();
		
}

class InsurancePageState extends State<InsurancePage> {

	List<Insurance> inlist = List();

	int _selected;

	void getInurances(BuildContext context){

		if (Globals.insuarnces.isEmpty == false)
			return ;
		Requests.get(Globals.url + '/api/insurance').then((Response response){
			print('response = ' + response.content().toString());
			if (response.statusCode == 200)
			{
				List<dynamic> list = response.json();
				list.forEach((json) { 
					var insurance = Insurance.fromJson(json);
					Globals.insuarnces.add(insurance);
				});
				setState(() {
				  
				});
			}
			else
				print('error ' + response.content().toString());
		});
	}

	@override
	Widget build(BuildContext context) {

		authenticate('admin', 'admin').then((value) => 
			getInurances(context)
		);

		List<Widget> widgets = List();
		
		Globals.insuarnces.forEach((Insurance element) {
			widgets.add(getCard(element));
		});

		widgets.add(getCard(Insurance(-1, 'autre')));

		return
			Scaffold(
				body:SafeArea(
					child:Padding(
						padding: EdgeInsets.only(left:20,right:20,top:20),
						child:Column(children: widgets,)),
				)
			);
	}


	Widget getCard(Insurance element){
		return Card(
					child:
						ListTile(
							title:Row(
							children:[
								Radio(
									value: element.id,
									groupValue: _selected,
									onChanged: (value){
										setState(() {
											_selected = value;
										});
									}
								),
								Text(element.title.toString()),
							]
						)
					)
				);
	}
}
