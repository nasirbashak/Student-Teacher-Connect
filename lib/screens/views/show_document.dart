
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';


class DocumentView extends StatefulWidget {
  @override
  _DocumentViewState createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {

  PDFDocument document;

  @override
  Widget build(BuildContext context) {

    String url = ModalRoute.of(context).settings.arguments;

    view() async{
      document = await PDFDocument.fromURL(url);
      setState(() {

      });

    }

    Widget Loading(){
      view();
      if(document == null){
        return Text("Loading");
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Documents"),
      ),
      body: document == null ?
            Loading():
            PDFViewer(document: document),
    );
  }
}
