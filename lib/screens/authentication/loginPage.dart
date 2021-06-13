import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:rljit_app/models/users.dart';
import 'package:rljit_app/screens/authentication/signup.dart';
import 'package:rljit_app/screens/storage/upload.dart';
import 'package:rljit_app/screens/views/viewWrapper.dart';
import 'package:rljit_app/screens/views/view_notes.dart';
import 'package:rljit_app/services/authenticate.dart';
import 'package:toast/toast.dart';

import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email;
  String _password;
  bool _student = false;

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

  Widget _studentTeacherSelection(){
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: LiteRollingSwitch(
        value: true,
        textOn: 'Student',
        textOff: 'Teacher',
        colorOn: Colors.deepOrange,
        colorOff: Colors.blueGrey,
        iconOn: Icons.lightbulb_outline,
        iconOff: Icons.person,
        onChanged: (bool state) {
          _student = !_student;
          print('Selected ${(_student) ? 'Student' : 'Teacher'}');
        },
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
      onTap: ()async {

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

        if(_email == null || _email.length == 0){
          Toast.show("Error : Empty email ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_password == null || _password.length == 0){
          Toast.show("Error : Empty password ", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

        }else if(_password.length < 8){
          Toast.show("Error : Password length", context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);
        }else{

          // dynamic result =  _authService.registerWithEmaillAndPassword(_email, _password, _name, _usn);


          try {

            dynamic result  =  await _authService.signInwithEmailandPassword(_email, _password);
            print(result);
            if(result is User) {
              print("inside login email and pass Result.uid = " + result.uid);
              Toast.show(result.uid, context, duration: Toast.LENGTH_LONG, gravity:  Toast.TOP);

              if(_student){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewWrapper()),
                );

              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Upload()),
                );

              }



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
                colors: [Color(0xffb5e0d3), Color(0xff62cbe7)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
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
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'on',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'nect',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryFieldName("Email id"),
        _entryFieldPassword("Password", isPassword: true),
      ],
    );
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
                top: -height * .15,
                left: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _studentTeacherSelection(),
                    SizedBox(height: 20,),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
                    /*
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),

                     */
                    SizedBox(height: height * .055),
                    _createAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
      ),
    ));
  }
}
