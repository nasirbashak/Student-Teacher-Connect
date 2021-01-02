
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rljit_app/models/file.dart';
import 'package:toast/toast.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Modal> itemList=List();

  final CollectionReference mainReference = Firestore.instance
      .collection('files');

  final _formKey = GlobalKey<FormState>();

  int dropdownValue = 1;
  String dropdownSem = '1';
  String dropdownCycle = 'P';
  String dropdownBranch = 'CS';
  String subjectCode = '';
  String _fileName = '';
  List<String> _branchesList = ['CS','EEE','ECE','ME','CV','IS'];

  String completeData = '';

  List<String> _list = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Staff"),
        actions: [
          FlatButton.icon(onPressed: (){

          }, icon: Icon(Icons.slideshow), label: Text("View"))
        ],
      ),
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
              color: Colors.amber,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20.0,),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Select Year"),
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
                  SizedBox(height: 20.0,),
                  dropdownValue == 1?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Select Cycle"),
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
                      Text("Select Sem"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Select Branch"),
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
                      Text("Enter File Name:"),
                      SizedBox(width: 20,),
                      Expanded(
                        child: TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          onChanged: (val){
                            setState(() {
                                _fileName = val.toUpperCase();
                              if(dropdownValue == 1){
                                completeData = dropdownValue.toString() + "-"+dropdownCycle  + "-"+subjectCode+"-"+dropdownBranch;
                              }else{
                                completeData = dropdownValue.toString() + "-"+ dropdownSem + "-"+subjectCode+"-"+dropdownBranch;
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
                  Text(completeData),
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
                      child: Text('Upload'),
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
          getPdfAndUpload();


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
      Toast.show("Permission.storage.status "+'${file.readAsBytesSync()}'.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

      savePdf(file.readAsBytesSync(), fileName);

    } else {
      // User canceled the picker
      Toast.show("File pick cancelled", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

    }




  }

  Future savePdf(List<int> asset, String name) async {


    /*
    StorageReference reference = FirebaseStorage.instance.ref();



    if(dropdownValue == 1){
      reference.child(dropdownValue.toString()+"-YEAR").child(dropdownCycle).child(name);
      print("Storage reference name");
      print(reference.child(dropdownValue.toString()+"-YEAR").child(dropdownCycle).child(name).getPath());
    }else{
      reference.child(dropdownValue.toString()+"-YEAR-"+dropdownSem).child(dropdownBranch).child(name);
      print("Storage reference name");
      print(reference.child(dropdownValue.toString()+"-YEAR-"+dropdownSem).child(dropdownBranch).child(name).getPath());

    }


     */





    //reference.child(name);

    StorageReference reference = FirebaseStorage.instance.ref().child(name);

    print(reference.getPath().toString());


    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(url);
    documentFileUpload(url);
    return  url;
  }
  void documentFileUpload(String str) {

    var data = {
      "PDF": str,
    };

    if(dropdownValue == 1){
      mainReference.document(dropdownValue.toString()+"-YEAR").collection(dropdownCycle).add(data).then((value) => print("File uploaded"))
          .catchError((error) => print("Failed to upload file: $error"));
    }else{
      mainReference.document(dropdownValue.toString()+"-YEAR-"+dropdownSem).collection(dropdownBranch).add(data).then((value) => print("File uploaded"))
          .catchError((error) => print("Failed to upload file: $error"));
    }


  }

  @override
  void initState() {

  }


}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}



/*
itemList.length==0?Text("Loading"):
      ListView.builder(
        itemCount:itemList.length,
        itemBuilder: (context,index){
          return Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: GestureDetector(
                onTap: (){
                  String passData=itemList[index].link;
                  /*
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context)=>ViewPdf(),
                          settings: RouteSettings(
                          )
                      )
                  );

                   */
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        height: 140,
                        child: Card(
                          margin: EdgeInsets.all(18),
                          elevation: 7.0,
                          child: Center(
                            child: Text(itemList[index].name+" "+(index+1).toString()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        },
      ),
 */