
import 'package:PatientMonitorMobileApp/DateTextField.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/views/BottomMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:PatientMonitorMobileApp/StyledTextView.dart';
import 'package:PatientMonitorMobileApp/Requests/requests.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';

class EditPatientPage extends StatefulWidget{

	EditPatientPage({Key key}) : super(key: key);
	
	
	@override
	State<StatefulWidget> createState() => EditPatientPageState();
		
	}
	
  enum Genre { male, female }

class EditPatientPageState extends State<EditPatientPage> {


  Genre _selected = Genre.male;
  Patient patient;
  void extractArgs(){

    if (patient != null)
      return;
    patient = ModalRoute.of(context).settings.arguments;
    print('edit patient ' + patient.id.toString());
    if (patient == null)
      return;
    emailController.text = patient.user.email.toString();
    phoneController.text = patient.user.phone.toString();
    fnameController.text = patient.user.firstName.toString();
    lnameController.text = patient.user.lastName.toString();
  
    postalCodeController.text = patient.postalCode.toString();
    cityController.text = patient.city.toString();
    _country = Country.ALL.firstWhere((country) => country.name == patient.country);
    cinController.text = patient.cin.toString();
    date = patient.birthdate;
  }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Country _country = Country.MA;

	TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cinController = TextEditingController();

  DateTime date = DateTime.now();

  @override
	Widget build(BuildContext context) {

    if (patient == null)
      extractArgs();
  
		return
    Scaffold(
		 bottomNavigationBar: BottomMenu(selectedIndex: 0),
			backgroundColor:Globals.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 64, 115, 158),
        title: Text('Add new Patient'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Icon(Icons.person, size:120,color: Color.fromARGB(255, 25, 42, 86)),
            Divider(height: 20,),
            SizedBox(height: 20,),
            textField(hint:'enter email', icon:Icon(Icons.mail), label: 'email', controller: emailController),
            SizedBox(height: 20,),
            textField(
              suffix: GestureDetector(
                child: Icon(Icons.refresh, size: 20,),
                onTap: (){
                  passController.text = getRandomString(5).toString();
                }
              ),
              hint:'enter password',
              icon:Icon(Icons.lock),
              label: 'password',
              controller: passController
            ),
            SizedBox(height: 20,),
            textField(hint:'enter first name', icon:Icon(Icons.person), label: 'first name', controller: fnameController),
            SizedBox(height: 20,),
            textField(hint:'enter last name', icon:Icon(Icons.person), label: 'last name', controller: lnameController),
            SizedBox(height: 20,),
            textField(hint:'enter phone number', icon:Icon(Icons.phone), label: 'phone number', controller: phoneController),
            SizedBox(height: 20,),
            textField(hint:'enter CIN', icon:Icon(Icons.portrait), label: 'CIN', controller: cinController),
            SizedBox(height: 20),
            MyTextFieldDatePicker(
              labelText: "BirthDate",
              prefixIcon: Icon(Icons.date_range),
              suffixIcon: Icon(Icons.arrow_drop_down),
              lastDate: DateTime.now(),
              firstDate: DateTime(1910),
              initialDate: date,
              onDateChanged: (selectedDate) {
                date = selectedDate;
              },
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              decoration:
              BoxDecoration(
                border: Border.all(),
                borderRadius:BorderRadius.all(Radius.circular(20)),
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesome.user, color: Colors.grey,),
                      //VerticalDivider(),
                      Text('Sexe :'),
                    ]
                  ),
                  Row(
                    children: [
                      Radio(value: Genre.male, groupValue: _selected,
                        onChanged: (value){
                          print('sel = ' + _selected.toString());
                          setState(() {
                            _selected = value;
                          });
                        }
                      ),
                      Icon(FontAwesome.male),
                      Text('male'),
                      VerticalDivider(),
                      Radio(value: Genre.female, groupValue: _selected, onChanged: (value){
                        print('sel = ' + _selected.toString());
                        setState(() {
                          _selected = value;
                        });
                      }),
                      Icon(FontAwesome.female),
                      Text('female'),
                    ],
                  ),
                ]
              ),
            ),
            SizedBox(height: 20,),
            textField(hint:'Address', icon:Icon(Icons.map), label: 'address', controller: addressController),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: 
                  textField(
                    hint:'City',
                    label: 'City',
                    controller: cityController
                  )
                ),
                SizedBox(width: 20,),
                Flexible(child: 
                  textField(
                    hint:'Postal Code',
                    label: 'Postal Code',
                    controller: postalCodeController
                  ),
                )
              ]
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(15),
              decoration:
              BoxDecoration(
                border: Border.all(),
                borderRadius:BorderRadius.all(Radius.circular(20)),
              ),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home),
                      VerticalDivider(),
                      Text('Country : '),
                  ]
                  ),
                  CountryPicker(
                    onChanged: (Country country) {
                      setState(() {
                        _country = country;
                      });
                    },
                    selectedCountry: _country,
                  ),
                ]
              ),
            ),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text('save', style: TextStyle(color: Color.fromARGB(255, 245, 246, 250)),),
              onPressed: () {
                var body = {
                      'email': emailController.text,
                      'first_name':fnameController.text,
                      'last_name':lnameController.text,
                      'phone':phoneController.text,
                      'password':passController.text,
                      'cin':cinController.text,
                      'birthday':DateFormat('yyyy-MM-dd').format(date),
                      'sexe':_selected == Genre.female ? '1' : '0',
                      'address':addressController.text,
                      'country':_country.name,
                      'postalcode':postalCodeController.text,
                      'city':cityController.text
                    };
                body.removeWhere((key,val)=>key=='email'&&patient.user.email == val.toString());
                print('req body = '+ body.toString());
                Requests.post(
                  Globals.url + '/api/patients/' + patient.id.toString(), 
                		body: body
                ).then((value) {
                  print(value.content().toString());
                  if (value.statusCode == 200)
                  {
                    Globals.patientsList = List();
                    Navigator.of(context).pop();
                    print('success');
                  }
                  else
                    print(value.statusCode.toString());
                }).catchError((e){print(e.toString());});
              },
              color: Color.fromARGB(255, 25, 42, 86),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            )
          ]
        )
        ),
      )
		);
	}
}