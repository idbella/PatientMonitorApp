
import 'package:PatientMonitorMobileApp/controllers/adminController.dart';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:PatientMonitorMobileApp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';

class UsersList extends StatefulWidget{
  
  UsersList(this.role);

  final int role;

  @override
  State<StatefulWidget> createState() => UsersListState(role);

}

class UsersListState extends State<UsersList>{

  UsersListState(this.role);

  final int role;

  @override
  Widget build(BuildContext context) {

    List<User> users = Globals.usersList.where((element) => role == element.role).toList();

    refreshUserList(context, setState);

    return
    ListView.builder
    (
      itemCount: users.length,
      itemBuilder: (BuildContext ctx, int index) {
        return
        Card(
        child:ListTile(
            onTap: () {
              Navigator.of(context)
              .pushNamed('edit', arguments:users[index])
              .whenComplete(() => refreshUserList(context, setState, true));
            },
            leading: Icon(Icons.person, size:70,color: Color.fromARGB(255, 113, 128, 147),),
            title: Text(users[index].firstName + ' ' + users[index].lastName),
            subtitle: Column(
              children:[
                Divider(height: 8,),
               Row(
                children: [
                  Icon(Icons.email, size: 15,),
                  VerticalDivider(width: 5,),
                  Text(users[index].email),
                ]
              ),
              SizedBox(height: 5,),
              Row(
                children: [
                  Icon(Icons.phone, size: 15,),
                  VerticalDivider(width: 5,),
                  Text(users[index].phone.toString()),
                ]
              )
            ]),
            isThreeLine: true,
            trailing: IconButton(
              iconSize: 25,
              icon: Icon(Icons.delete,
                color: Color.fromARGB(255, 194, 54, 22),
              ),
              onPressed: (){
                showAlertDialog(context, users[index]);
              }),
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
          Globals.usersList.removeWhere((element) => element.id == user.id);
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