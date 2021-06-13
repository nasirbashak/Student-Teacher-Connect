import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rljit_app/models/file.dart';
import 'package:rljit_app/screens/views/show_document.dart';
import 'package:toast/toast.dart';

class ViewTimetable extends StatefulWidget {
  const ViewTimetable({Key key}) : super(key: key);

  @override
  _ViewTimetableState createState() => _ViewTimetableState();
}

class _ViewTimetableState extends State<ViewTimetable> {

  final CollectionReference mainReference = Firestore.instance
      .collection('timetable');



  List<Model> itemList=List();

  List<Document> documentsList=List();

  bool _searchStarted = false;


  final _formKey = GlobalKey<FormState>();

  bool _isStarted = false;
  bool _isEnded = false;
  bool _isError = false;

  int dropdownValue = 1;
  String dropdownSem = '1';
  String dropdownCycle = 'P';
  String dropdownBranch = 'CS';
  String dropdownSection = 'A';
  String subjectCode = '';
  String _fileName = '';
  String _fileDescription = '';
  List<String> _branchesList = ['CS','EEE','ECE','ME','CV','IS'];

  String completeData = '';

  List<String> _list = [];
  List<String> _sectionlist = ['A','B','C','D','E','F'];



  getData(){

    documentsList.clear();
    final CollectionReference mainReference = Firestore.instance
        .collection('timetable');

    if(dropdownValue == 1){
      mainReference.document(dropdownValue.toString()+"-"+dropdownCycle+"-"+dropdownSection).get().then((querySnapshot){

          String link = querySnapshot.data['TT'].toString();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DocumentView(),
                  settings: RouteSettings(
                      arguments: link
                  )
              )
          );



        setState(() {
          _searchStarted = false;
          print(link);
        });
      });

    }else{
      mainReference.document(dropdownValue.toString()+"-"+dropdownSem+"-"+dropdownBranch+"-"+dropdownSection).get().then((querySnapshot){


        String link = querySnapshot.data['TT'].toString();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DocumentView(),
                settings: RouteSettings(
                    arguments: link
                )
            )
        );


        setState(() {
          _searchStarted = false;
          print(link);
        });

      });

    }


/*
       mainReference.document("1-P-A").get().then((querySnapshot){

        print("Data"+querySnapshot.data.toString());

        Navigator.push(context,
              MaterialPageRoute(builder: (context) => DocumentView(),
                  settings: RouteSettings(
                      arguments: "link"
                  )
              )
          );

      });

 */












  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 0.8,
              shadowColor: Colors.black,
              child: ListTile(
                onLongPress: (){
                  Toast.show("Upload", context);
                },
                leading: Icon(Icons.arrow_circle_up),
                title: const Text('View Timetable',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.lightBlue,
                  ),),
                subtitle: Text(
                  'Fill the form, pick a file to view',
                  style: TextStyle(color: Colors.black.withOpacity(.6)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 45.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Select Year :"),
                          DropdownButton<int>(

                            value: dropdownValue,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (int newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                //dropdownSem = (int.parse(dropdownValue)+1).toString();
                                if(dropdownValue == 1){
                                  dropdownSection = 'A';
                                  _sectionlist = ['A','B','C','D','E','F'];
                                }else if(dropdownValue>1){
                                  dropdownSection = 'A';
                                  _sectionlist = ['A','B'];
                                }

                                if(dropdownValue == 2){
                                  _list.clear();
                                  _list.addAll(['3','4']);
                                  dropdownSem = '3';

                                }else if(dropdownValue == 3){
                                  _list.clear();
                                  _list.add('5');
                                  _list.add('6');
                                  dropdownSem = '5';
                                }else if(dropdownValue == 4){
                                  _list.clear();
                                  _list.add('7');
                                  _list.add('8');
                                  dropdownSem = '7';
                                }

                                Toast.show(dropdownValue.toString() +"-"+_list.toString() , context);
                              });
                            },
                            items: <int>[1, 2, 3, 4]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(

                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      dropdownValue == 1?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Select Cycle :"),
                          DropdownButton<String>(

                            value: dropdownCycle,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownCycle = newValue;
                                Toast.show(dropdownCycle.toString(), context);
                              });
                            },
                            items: <String>['P','C']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(

                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ):
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Select Sem :"),
                          DropdownButton<String>(

                            value: dropdownSem,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownSem = newValue;
                                Toast.show(dropdownSem.toString(), context);
                              });
                            },
                            items: _list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      dropdownValue == 1?
                      Container(color: Colors.deepOrange,):
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Select Branch :"),
                          DropdownButton<String>(

                            value: dropdownBranch,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownBranch = newValue;
                                Toast.show(dropdownBranch.toString(), context);
                              });
                            },
                            items: _branchesList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Select Section :"),
                          DropdownButton<String>(

                            value: dropdownSection,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownSection = newValue;
                                Toast.show(dropdownSection.toString(), context);
                              });
                            },
                            items: _sectionlist
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0,),

                      SizedBox(height: 20.0,),
                      Text(
                        completeData,
                        style: TextStyle(
                          color: _isError? Colors.red :Colors.green,
                        ),),
                      _isStarted & !_isEnded  & !_isError?
                      Container(
                          color: Colors.lightBlue,
                          child: Center(
                            child: Loading(indicator:  BallPulseIndicator(), size: 100.0,color: Colors.pink),
                          )):
                      Container(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.

                              getData();
                             // getPdfAndUpload();
                            }
                          },
                          child: Text('Choose and Upload'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
