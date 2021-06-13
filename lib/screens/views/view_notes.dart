
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rljit_app/models/file.dart';
import 'package:rljit_app/screens/views/show_document.dart';
import 'package:rljit_app/screens/views/view_timetable.dart';
import 'package:toast/toast.dart';


class ViewNotes extends StatefulWidget {
  @override
  _ViewNotesState createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {


  final CollectionReference mainReference = Firestore.instance
      .collection('files');


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
  String subjectCode = '';
  String _fileName = '';
  String _fileDescription = '';
  List<String> _branchesList = ['CS','EEE','ECE','ME','CV','IS'];

  String completeData = '';

  List<String> _list = [];




  getData(){

      documentsList.clear();
      final CollectionReference mainReference = Firestore.instance
          .collection('files');

      if(dropdownValue == 1){
        mainReference.document(dropdownValue.toString()+"-YEAR").collection(dropdownCycle).getDocuments()
            .then((querySnapshot){

          querySnapshot.documents.forEach((doc) {
            //print(doc.data);
            documentsList.add(
                Document(
                    subjectCode: doc['CODE'] ?? 'CODE',
                    description : doc['DESC'],
                    url:doc['PDF']
                ));
          });
          setState(() {
            _searchStarted = false;
            documentsList.forEach((doc) {
              print("Document");
              print(doc.subjectCode);
            });
          });
        });

      }else{
        mainReference.document(dropdownValue.toString()+"-YEAR-"+dropdownSem).collection(dropdownBranch).getDocuments()
            .then((querySnapshot){

          querySnapshot.documents.forEach((doc) {
            //print(doc.data);
            documentsList.add(
                Document(
                    subjectCode: doc['CODE'] ?? 'CODE',
                    description : doc['DESC'],
                    url:doc['PDF']
                ));
          });

          setState(() {
            _searchStarted = false;
            documentsList.forEach((doc) {
              print("Document");
              print(doc.subjectCode);
            });
          });

        });

      }


      /*
       mainReference.document("4-YEAR-7").collection('CS').getDocuments().then((querySnapshot){

        querySnapshot.documents.forEach((doc) {
          //print(doc.data);
          documentsList.add(
              Document(
                subjectCode: doc['CODE'] ?? 'CODE',
                description : doc['DESC'],
                url:doc['PDF']
              ));
        });
        documentsList.forEach((doc) {
          print("Document");
          print(doc.subjectCode);
        });

      });

       */








  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,

      body: Column(
        children: [
          Card(
            elevation: 0.8,
            shadowColor: Colors.black,
            child: ListTile(
              onLongPress: (){
                Toast.show("Select", context);
              },
              leading: Icon(Icons.arrow_circle_up),
              title: const Text('View files',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.lightBlue,
                ),),
              subtitle: Text(
                'Fill the form, pick a file to view.',
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
                            FocusScope.of(context).unfocus();
                            setState(() {
                              _searchStarted = true;
                            });
                            //getPdfAndUpload();
                            getData();

                          }
                        },
                        child: Text('Search'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          (documentsList.length == 0) &( _searchStarted == true) ?
          Container(
              color: Colors.lightBlue,
              child: Center(
                child: Loading(indicator:  BallPulseIndicator(), size: 50.0,color: Colors.pink),
              )):
              Expanded(
                child: ListView.builder(
                  itemCount: documentsList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return Card(
                        child: ListTile(
                          onTap: (){

                            String url = documentsList[index].url;
                            Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => DocumentView(),
                            settings: RouteSettings(
                              arguments: url
                            )
                            )
                            );


                          },
                          //trailing: Text(documentsList[index].url),
                          title: Text(documentsList[index].subjectCode),
                          subtitle: Text(documentsList[index].description),
                        ),
                      );
                    }),
              ),

        ],
      ),

    );
  }
}
