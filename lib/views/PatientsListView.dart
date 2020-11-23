
import 'package:PatientMonitorMobileApp/controllers/RecepController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/patient.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class PatientsListView extends StatefulWidget{
  
  PatientsListView();

  @override
  State<StatefulWidget> createState() => PatientsListViewState();

}

class PatientsListViewState extends State<PatientsListView>{

  PatientsListViewState();

  @override
  Widget build(BuildContext context) {

    List<Patient> patients = Globals.patientsList;

    //refreshPatientsList(context, setState);

    return
    ListView.builder
    (
      itemCount: patients.length,
      itemBuilder: (BuildContext ctx, int index) {
        return
        Card(
        child:ListTile(
            onTap: () {
              Navigator.of(context)
              .pushNamed('editpatient', arguments:patients[index]);
            },
            leading: Icon(Icons.person, size:70,color: Color.fromARGB(255, 113, 128, 147),),
            title: Text(patients[index].user.firstName.toString() + ' ' + patients[index].user.lastName.toString()),
            subtitle: Column(
              children:[
                Divider(height: 8,),
               Row(
                children: [
                  Icon(Icons.email, size: 15,),
                  VerticalDivider(width: 5,),
                  Flexible(child:
                    Text(patients[index].user.email.toString(), overflow: TextOverflow.ellipsis,),
                  )
                ]
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.phone, size: 15,),
                  VerticalDivider(width: 5,),
                  Flexible(child:
                    Text(patients[index].user.phone.toString(), overflow: TextOverflow.ellipsis,),
                  )
                ]
              )
            ]),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(
                  iconSize: 25,
                  icon: Icon(Icons.edit,
                    color: Color.fromARGB(255, 64, 115, 158),
                  ),
                  onPressed: (){
                    Navigator.of(context)
                    .pushNamed('editpatient', arguments:patients[index]);
                  }
                ),
                IconButton(
                  iconSize: 25,
                  icon: Icon(Icons.delete,
                    color: Color.fromARGB(255, 194, 54, 22),
                  ),
                  onPressed: (){
                    showAlertDialog(context, patients[index].user);
                  }
                ),
              ]
            )
          )
        );
      }
    );
  }

  showAlertDialog(BuildContext context, User user) {

  // set up the button
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    }
  );
  Widget okButton = FlatButton(
    child: Text("Delete"),
    onPressed: () {
      Requests.delete(Globals.url + '/api/admin/users/' + user.id.toString())
      .then((value) {
        if (value.statusCode == 200)
        {
          Navigator.of(context).pop();
          Globals.patientsList.removeWhere((element) => element.user.id == user.id);
          setState(() {
          });
          print('success');
        }
        else
          print(value.statusCode.toString());
      }).catchError((e){
        print(e.toString());
      });
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm"),
    content: Text("Delete user " + user.lastName),
    actions: [
      cancelButton,
      okButton
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  }

}