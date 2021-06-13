

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rljit_app/screens/storage/upload.dart';
import 'package:rljit_app/services/authenticate.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';



class Welcome extends StatefulWidget {


  final String title;

  Welcome({Key key, this.title}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton(
                onPressed: (){
                 dynamic user =  AuthService().signInAnnon();
                 if(user == null){
                    debugPrint("User result Null");
                 }else {
                   print("User result " + user.uid);
                 }
                },
                child: Text('Login'),
            ),
            FlatButton(
              onPressed: () async {

                var status = await Permission.storage.status;
                debugPrint("Permission.storage.status "+status.toString());
                Toast.show("Permission.storage.status "+status.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

                if (status.isRestricted) {
                  // We didn't ask for permission yet.
                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    var status = await Permission.storage.status;
                    debugPrint("Permission.storage.status "+status.toString());
                    Toast.show("Permission.storage.status "+status.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);


                  }else{
                    debugPrint("Permission.storage.status "+status.toString());
                    Toast.show("Permission.storage.status "+status.toString()+"Please provide the permissions", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);


                  }
                }
                else if(status.isGranted){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Upload()),
                  );
                }

              },
              child: Text('Register'),
            ),
            FlatButton(
              onPressed: () {

                /*

                final CollectionReference mainReference = Firestore.instance
                    .collection('files');

                var data = {
                  "PDF": 'str2',
                };

                mainReference.document('4'+"-YEAR-"+'7').collection("CS").add(data).then((value) {
                  print("User Added");
                  final CollectionReference mainReference = Firestore.instance
                      .collection('files');
                  mainReference.document("4-YEAR-7").collection('CS').getDocuments().then((querySnapshot){

                    querySnapshot.documents.forEach((element) {
                      print(element.data);
                    });

                  });

                } )
                    .catchError((error) => print("Failed to add user: $error"));




                 */
              },
              child: Text('Admission'),
            )

          ],
        ),
      ),
    );
  }
}
