import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rljit_app/models/users.dart';
import 'package:rljit_app/screens/authentication/Widget/bezierContainer.dart';
import 'package:rljit_app/screens/authentication/loginPage.dart';
import 'package:rljit_app/services/authenticate.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  List<String> _usnList = [];
  String _name = "";
  String _usn;
  String _email;
  String _password;
  int _index = -1;

  final AuthService _authService  = new AuthService();




  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryFieldName(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (data){
                _name = data;
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _entryFieldUsn(String title, {bool isPassword = false}) {
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (data){
                setState(() {
                  _usn = data.toUpperCase();
                  if(data.length ==10){
                    Toast.show("Max length", context);
                      _index = _usnList.indexOf(_usn);
                      print("Search Index = "+_index.toString());
                  }else if(data.length<10){
                    _index = -1;
                  }
                });

              },
              obscureText: isPassword,
              maxLength: 10,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)
          ),
          _index!=-1?Text(
            "USN already exists!",
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold, fontSize: 15),
          ):Container(),
        ],
      ),
    );
  }

  Widget _entryFieldEmail(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (data){
                _email = data;
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _entryFieldPassword(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (data){
                _password = data;
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () async {

       // Toast.show("Submit ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
        /*
        print("NAME :"+_name.toString());
        print("USN :"+_usn.toString());
        print("EMAIL :"+_email.toString());
        print("PASSWORD :"+_password.toString());

        print("NAME :"+_name.length.toString());
        print("USN :"+_usn.length.toString());
        print("EMAIL :"+_email.length.toString());
        print("PASSWORD :"+_password.length.toString());

         */

        if(_name == null || _name.length == 0){
          Toast.show("Error : Empty name ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_usn == null || _usn.length == 0){
          Toast.show("Error : Empty usn ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_email == null || _email.length == 0){
          Toast.show("Error : Empty email ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_password == null || _password.length == 0){
          Toast.show("Error : Empty password ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_usn.length < 10){
          Toast.show("Error : USN length", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
        }else if(_password.length < 8){
          Toast.show("Error : Password length", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
        }else{

        // dynamic result =  _authService.registerWithEmaillAndPassword(_email, _password, _name, _usn);


         try {

           dynamic result  = await _authService.registerWithEmaillAndPassword(_email, _password, _name, _usn);
           print(result);
           if(result is User) {
             print("inside login email and pass Result.uid = " + result.uid);
             Toast.show(result.uid, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => LoginPage()),
             );

           }else if(result is String){
             print("inside login email and pass Result.uid != "+ result.split(",")[1]);
             Toast.show(result.split(",")[1], context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
           }
         } catch (e) {
           print("inside login email and pass Exception"+e.toString());
           Toast.show(e.toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

         }





        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                //#B5E0D3 #62CBE7
                colors: [Color(0xffb5e0d3), Color(0xff62cbe7)])),
        child: Text(
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  // #62CBE7
                  color: Color(0xff62cbe7),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'C',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            // #62CBE7
            color: Color(0xff62cbe7),
          ),
          children: [
            TextSpan(
              text: 'on',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'nect',
              style: TextStyle(color: Color(0xff62cbe7), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldName("Name"),
        _entryFieldUsn("University Serial Number"),
        _entryFieldEmail("Email id"),
        _entryFieldPassword("Password", isPassword: true),
      ],
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final CollectionReference _collectionReference = Firestore.instance
        .collection('usns');
    _usnList = [];

    print("USNs");
    _collectionReference.getDocuments().then((document) {
      //print("USN :"+document.toString());
      document.documents.forEach((element) {
        //print("USN :"+element.data["usn"]);
        _usnList.add(element.data["usn"]);

      });
      _usnList.forEach((element) {
        print("USN :"+element);
      });
      print("USN List length :"+_usnList.length.toString());
    });

  }

  @override
  Widget build(BuildContext context) {


    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              left: -MediaQuery.of(context).size.width * .52,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height *.01),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
