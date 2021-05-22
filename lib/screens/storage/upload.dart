
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rljit_app/models/file.dart';
import 'package:rljit_app/screens/views/view.dart';
import 'package:toast/toast.dart';


class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {

  final navTabs = [
    FirstPage(),
    SecondPage(),
  ];

  int _currentIndex = 0;
  Color _iconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Staff"),
        actions: [
          FlatButton.icon(onPressed: (){
            Toast.show(_currentIndex.toString(), context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => View()),
            );
          }, icon: Icon(Icons.slideshow), label: Text("View"))
        ],
      ),
      body: navTabs[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.blue,
        height: 45,
        index: _currentIndex,
        items: <Widget>[
          Icon(Icons.home,size:30,color:Colors.white,),
          Icon(Icons.search,size:30,color:Colors.white,),
        ],
        animationDuration: Duration(milliseconds: 500),
        animationCurve: Curves.fastOutSlowIn,
        onTap: (index){

          setState(() {
            _currentIndex = index;

          });
          debugPrint("Current nav index $index $_currentIndex $_iconColor");
        },
      ),
    );
  }
}




class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Modal> itemList=List();

  final CollectionReference mainReference = Firestore.instance
      .collection('files');

  final _formKey = GlobalKey<FormState>();

  bool _isStarted = false;
  bool _isEnded = false;
  bool _isError = false;

  int dropdownValue = 1;
  String dropdownSem = '1';
  String dropdownCycle = 'P';
  String dropdownBranch = 'CS';
  String subjectCode = '';
  String _fileName = '';
  String _fileDescription = '';
  List<String> _branchesList = ['CS','EEE','ECE','ME','CV','IS'];

  String completeData = '';

  List<String> _list = [];





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
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
                title: const Text('Upload files',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.lightBlue,
                ),),
                subtitle: Text(
                  'Fill the form, pick a file and upload.',
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enter subject Code :"),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (val){
                            setState(() {
                              subjectCode = val.toUpperCase();
                              if(dropdownValue == 1){
                                completeData = dropdownValue.toString() + "-"+dropdownCycle  + "-"+subjectCode;
                              }else{
                                completeData = dropdownValue.toString() + "-"+ dropdownSem + "-"+subjectCode;
                              }
                            });

                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enter File Description:"),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (val){
                            setState(() {
                              _fileDescription = val;
                            });

                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide some description';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Enter File Name:"),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (val){
                            setState(() {
                                _fileName = val.toUpperCase();
                              if(dropdownValue == 1){
                                completeData = dropdownValue.toString() + "-"+dropdownCycle  + "-"+subjectCode+"-"+dropdownBranch+"-"+_fileDescription;
                              }else{
                                completeData = dropdownValue.toString() + "-"+ dropdownSem + "-"+subjectCode+"-"+dropdownBranch+"-"+_fileDescription;
                              }
                            });

                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
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


                          getPdfAndUpload();
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // getPdfAndUpload();
          setState(() {
            _isEnded = true;
          });


        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future getPdfAndUpload()async{

    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }

    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: [ 'pdf', 'doc'],);
    String fileName = '${_fileName}.pdf';

    if(result != null) {
      File file = File(result.files.single.path);
      print(fileName);
      print('${file.readAsBytesSync()}');
      //Toast.show("Permission.storage.status "+'${file.readAsBytesSync()}'.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      savePdf(file.readAsBytesSync(), fileName,_fileDescription);

    } else {
      // User canceled the picker
      Toast.show("File pick cancelled", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }




  }

  Future savePdf(List<int> asset, String name, String description) async {



    StorageReference reference = FirebaseStorage.instance.ref();



    if(dropdownValue == 1){
      reference = reference.child(dropdownValue.toString()+"-YEAR").child(dropdownCycle).child(name);
      print("Storage reference name");
      print(reference.child(dropdownValue.toString()+"-YEAR").child(dropdownCycle).child(name).getPath());
    }else{
      reference = reference.child(dropdownValue.toString()+"-YEAR-"+dropdownSem).child(dropdownBranch).child(name);
      print("Storage reference name");
      print(reference.child(dropdownValue.toString()+"-YEAR-"+dropdownSem).child(dropdownBranch).child(name).getPath());

    }


    //StorageReference reference2 = FirebaseStorage.instance.ref();//.child("TEST").child(name);
    //reference2.child("4-YEAR-8").child("CS").child(name);
    //print(dropdownValue.toString()+"-YEAR-"+dropdownSem+"/"+dropdownBranch);

  // reference2 = reference2.child(dropdownValue.toString()+"-YEAR-"+dropdownSem).child(dropdownBranch).child(name);
    print("Storage reference name");
    print(reference.getPath());// .getPath().toString());


    StorageUploadTask uploadTask = reference.putData(asset);

    setState(() {
      _isStarted =  uploadTask.isInProgress;
      _isEnded = false;
      _isError = false;
    });

    print(_isStarted);
    print(_isEnded);
    print(_isError);


    bool b1 = uploadTask.isInProgress;
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    bool b2 = uploadTask.isComplete;
    print(url);
    documentFileUpload(url,description);
    return  url;
  }

  void documentFileUpload(String url, String description) {

    var data = {
      "PDF": url,
      "DESC": description,
      "CODE": subjectCode,
    };

    if(dropdownValue == 1){
      mainReference.document(dropdownValue.toString()+"-YEAR").collection(dropdownCycle).add(data)
          .then((value) {
            print("File uploaded");
            setState(() {
              _isEnded = true;
              completeData = "File uploaded successfully!";
            });

          })
          .catchError((error) {
            print("Failed to upload file: $error");
            setState(() {
              _isError = true;
              completeData = "Failed to upload file: $error";
            });

          });
    }else{
      mainReference.document(dropdownValue.toString()+"-YEAR-"+dropdownSem).collection(dropdownBranch).add(data)
          .then((value) {
            print("File uploaded");
            setState(() {
              _isEnded = true;
              completeData = "File uploaded successfully!";
            });
          })
          .catchError((error) {
            print("Failed to upload file: $error");
            setState(() {
              _isError = true;
              completeData = "Failed to upload file: $error";
            });
          });
    }


  }

  @override
  void initState() {

  }


}



class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  List<Modal> itemList=List();

  final CollectionReference mainReference = Firestore.instance
      .collection('timetable');

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
                title: const Text('Upload Timetable',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.lightBlue,
                  ),),
                subtitle: Text(
                  'Fill the form, pick a file and upload.',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Enter File Name:"),
                          SizedBox(width: 20,),
                          Expanded(
                            child: TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (val){
                                setState(() {
                                  _fileName = val.toUpperCase();
                                  if(dropdownValue == 1){
                                    completeData = dropdownValue.toString() + "-"+dropdownCycle  + "-"+subjectCode+"-"+dropdownBranch+"-"+_fileDescription;
                                  }else{
                                    completeData = dropdownValue.toString() + "-"+ dropdownSem + "-"+subjectCode+"-"+dropdownBranch+"-"+_fileDescription;
                                  }
                                });

                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
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


                              getPdfAndUpload();
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // getPdfAndUpload();
          setState(() {
            _isEnded = true;
          });

        },
        child: Icon(Icons.add,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
    );

  }


  Future getPdfAndUpload()async{

    var rng = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }

    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions: [ 'png','jpeg','jpg'],);
    String fileName = '${_fileName}.pdf';

    if(result != null) {
      File file = File(result.files.single.path);
      print(fileName);
      print('${file.readAsBytesSync()}');
      //Toast.show("Permission.storage.status "+'${file.readAsBytesSync()}'.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      savePdf(file.readAsBytesSync(), fileName);

    } else {
      // User canceled the picker
      Toast.show("File pick cancelled", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }




  }

  Future savePdf(List<int> asset, String name) async {



    StorageReference reference = FirebaseStorage.instance.ref();

    reference = reference.child("Time-Table").child(name);


    print("Storage reference name");
    print(reference.getPath());


    StorageUploadTask uploadTask = reference.putData(asset);

    setState(() {
      _isStarted =  uploadTask.isInProgress;
      _isEnded = false;
      _isError = false;
    });

    print(_isStarted);
    print(_isEnded);
    print(_isError);


    bool b1 = uploadTask.isInProgress;
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    bool b2 = uploadTask.isComplete;
    print(url);
    documentFileUpload(url);
    return  url;
  }

  void documentFileUpload(String url) {

    var data = {
      "TT": url,
    };

    if(dropdownValue == 1){
      //YEAR-CYCLE-SECTION
      mainReference.document(dropdownValue.toString()+"-"+dropdownCycle+"-"+dropdownSection).setData(data)
          .then((value) {
        print("File uploaded");
        setState(() {
          _isEnded = true;
          completeData = "File uploaded successfully!";
        });

      })
          .catchError((error) {
        print("Failed to upload file: $error");
        setState(() {
          _isError = true;
          completeData = "Failed to upload file: $error";
        });

      });
    }else{
      //YEAR-SEM-BRANCH-SEC
      mainReference.document(dropdownValue.toString()+"-"+dropdownSem+"-"+dropdownBranch+"-"+dropdownSection).setData(data)
          .then((value) {
        print("File uploaded");
        setState(() {
          _isEnded = true;
          completeData = "File uploaded successfully!";
        });
      })
          .catchError((error) {
        print("Failed to upload file: $error");
        setState(() {
          _isError = true;
          completeData = "Failed to upload file: $error";
        });
      });
    }


  }

}


String _bytesTransferred(StorageTaskSnapshot snapshot) {
  double res = snapshot.bytesTransferred / 1024.0;
  double res2 = snapshot.totalByteCount / 1024.0;
  return '${res.truncate().toString()}/${res2.truncate().toString()}';
}

Widget _uploadStatus(StorageUploadTask task) {
  return StreamBuilder(
    stream: task.events,
    builder: (BuildContext context, snapshot) {
      Widget subtitle;
      if (snapshot.hasData) {
        final StorageTaskEvent event = snapshot.data;
        final StorageTaskSnapshot snap = event.snapshot;
        subtitle = Text('${_bytesTransferred(snap)} KB sent');
      } else {
        subtitle = const Text('Starting...');
      }
      return ListTile(
        title: task.isComplete && task.isSuccessful
            ? Text(
          'Done',
          style: TextStyle(),
        )
            : Text(
          'Uploading',
          style: TextStyle(),
        ),
        subtitle: subtitle,
      );
    },
  );
}