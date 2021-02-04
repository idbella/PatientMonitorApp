import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/insurance.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';

class InsurancePage extends StatefulWidget{

	InsurancePage({Key key}) : super(key: key);
	
	@override
	State<StatefulWidget> createState() => InsurancePageState();
		
}

class InsurancePageState extends State<InsurancePage> {

	List<Insurance> inlist = List();
	TextEditingController doctorController = TextEditingController();

	InsurancePageState(){
				if (Globals.insuarnces.length > 0)
					_selected = Globals.insuarnces.first.id;
	}
	int _selected;
	int dropdownValue = 0;
	@override
	Widget build(BuildContext context) {

		List<Widget> widgets = List();
		
		Globals.insuarnces.forEach((Insurance element) {
			widgets.add(getCard(element));
		});

		List<DropdownMenuItem<int>> list = Globals.fileTypes.map((value) {
			return DropdownMenuItem<int>(
				value: value.id,
				child: Row(
					children: [
						Icon(Icons.description),
						SizedBox(width: 10,),
						Text(value.title.toString())
					]
				),
			);
		}).toList();

		return
			Scaffold(
				bottomNavigationBar: BottomMenu(selectedIndex: 1),
				backgroundColor:Globals.backgroundColor,
      		body: SingleChildScrollView(
      			child: Stack(children: [
						Container(
							height: 270,
							width: MediaQuery.of(context).size.width,
							decoration: BoxDecoration(
								image: DecorationImage(
									image: AssetImage('images/insurance.jpg'),
									fit:BoxFit.fitWidth
								)
							),
						),
						Positioned(
							left:15,
							top: 140,
							child: Container(
								width: 120.0,
								height: 120.0,
								decoration: BoxDecoration(
									image: DecorationImage(
										image: Image.asset('images/avatar.png').image,
										fit: BoxFit.cover,
									),
									borderRadius: BorderRadius.all(Radius.circular(60.0)),
									border: Border.all(
										color: Colors.blue,
										width: 7.0,
									),
								),
							),
						),
						Padding(
							padding: EdgeInsets.all(20),
							child:Column(
								children: [
									SizedBox(height: 260,),
									Padding(
										padding: EdgeInsets.symmetric(horizontal:20),
										child:Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children:[
											Text('type de dossier : '),
											DropdownButton<int>(
												value: dropdownValue,
												icon: Icon(Icons.arrow_downward),
												iconSize: 24,
												elevation: 16,
												style: TextStyle(color: Colors.deepPurple),
												onChanged: (int newValue) {
													setState(() {
													dropdownValue = newValue;
													});
												},
												items: list,
											),
										]
										),
									),
									Text(
										'Insurance type',
										style: TextStyle(
											fontSize: 24,
											fontWeight: FontWeight.w600
										),
									),
									SizedBox(height: 20,),
									Column(children: widgets,),

									SizedBox(height: 30,),
            					Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: [
											RaisedButton(
												child: Text('back', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
												onPressed: (){Navigator.of(context).pop();},
												color: Color.fromARGB(255, 25, 42, 86),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
											),
											SizedBox(width: 40,),
											RaisedButton(
												child: Text('next', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
												onPressed: next,
												color: Color.fromARGB(255, 25, 42, 86),
												shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
											)
										]
									),
								]
      					)
      				),
					]
				)
      	)
		);
	}


	Widget getCard(Insurance element){
		return
			Card(
				child: ListTile(
					onTap: (){
						setState(() {
							_selected = element.id;
						});
					},
					title:Column(
						children:[
							Row(
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
							),
							Visibility(
								visible: _selected == element.id && element.editable,
								child: Column(
									children:[
										textField(
											label: element.title.toString(),
											hint: element.title.toString(),
											maxlines: null,
											inputtype: TextInputType.multiline,
											controller: element.controller
										),
										SizedBox(height: 10,)
									]
								)
							)
						]
					)
				)
			);
	}

	void next(){
		Map<String,dynamic> body = {
			'insurance_type':_selected,
			'type':dropdownValue.toString()
		};
		Insurance insurance = Globals.insuarnces.where((element) => element.id == _selected).first;
		if (insurance.editable)
			body['insurance'] = insurance.controller.text.toString();
		Map<String,dynamic> patientInfo = ModalRoute.of(context).settings.arguments;

		var args = patientInfo['args'];
		body = {...args,...body};
		Navigator.of(context).pushNamed('staff', arguments: {'args':body});
	}
}
