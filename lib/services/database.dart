import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});



}

  /*

  final CollectionReference _collectionReference = Firestore.instance
      .collection('brew');


  final CollectionReference _collectionReferenceCategories = Firestore.instance
      .collection('items');





  List<Category> _convertToCategoryList(QuerySnapshot snapshot){

    /*
      print(cat.documentID);
      //print(cat.data);
      print(cat.data.keys.first);
      print(cat.data[cat.data.keys.first]['img']);
      print(cat.data[cat.data.keys.first]['name']);
     */


    return snapshot.documents.map((doc) {
      return Category(
        doc.documentID ?? 'no title',
        doc.data[doc.data.keys.first]['name'] ?? 'no name',
        doc.data[doc.data.keys.first]['img'] ?? 'https://',
      );
    }).toList();
  }


  //get users and data
  Stream<List<Category>> get categories{

    return _collectionReferenceCategories.snapshots().map(_convertToCategoryList);
  }

  //get categories list
  Stream<QuerySnapshot> get categories2{
    return _collectionReferenceCategories.snapshots();
  }



}

   */