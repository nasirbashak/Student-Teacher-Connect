import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rljit_app/screens/views/view_notes.dart';
import 'package:rljit_app/screens/views/view_timetable.dart';
import 'package:toast/toast.dart';


class ViewWrapper extends StatefulWidget {
  const ViewWrapper({Key key}) : super(key: key);

  @override
  _ViewWrapperState createState() => _ViewWrapperState();
}

class _ViewWrapperState extends State<ViewWrapper> {


  final navTabs = [
    ViewNotes(),
    ViewTimetable()
  ];

  int _currentIndex = 0;
  Color _iconColor = Colors.black;
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Student"),
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
