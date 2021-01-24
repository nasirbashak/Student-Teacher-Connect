import 'package:firebase_auth/firebase_auth.dart';
import 'package:rljit_app/models/users.dart';
import 'package:rljit_app/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _createUserFromFB(FirebaseUser user, String name, String usn){

    return user!= null ? User(uid:user.uid,name: name,usn: usn) : null;
  }



  //sign in annonimously
  Future signInAnnon() async{

    try{
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return user;
    }catch(e){
      print(e.toString());
      return null;

    }
  }

  Future registerWithEmaillAndPassword(String email, String password, String name, String usn) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      DatabaseService _database = DatabaseService(uid:user.uid);

      user!= null ? _database.createUserData(name, usn, email): print("null");

      return _createUserFromFB(user,name,usn);
    }catch(e){
      print(e.toString());
      return e.toString();
    }
  }

  Future signInwithEmailandPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

     // DatabaseService _database = DatabaseService(uid:user.uid);

      //dynamic _user =   _database.getUserData();

      return User(uid: user.uid);

    }catch(e){
      print(e.toString());
      return e.toString();

    }
  }




}

  /*



  //auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _createUserFromFB(user));
        .map(_createUserFromFB);
  }

  //sign in annonimously
  Future signInAnnon() async{

    try{
      AuthResult result =  await _auth.signInAnonymously();
      FirebaseUser user = result.user;

      return _createUserFromFB(user);
    }catch(e){
      print(e.toString());
      return null;

    }
  }

  //signin with email and password
  Future signInwithEmailandPassword(String email,String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      return _createUserFromFB(user);

    }catch(e){
      print(e.toString());
      return null;

    }
  }

  /*
  //register
  Future registerWithEmaillAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      DatabaseService _database = DatabaseService(uid:user.uid);
      _database.updateUserData('0', 'New Brew Crew Member', 100);
      return _createUserFromFB(user);
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  */


  //sign out
  Future signout() async{

    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());

      return null;
    }


  }

}

   */