import 'package:doctor/models/doctorDetails.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CreateDoctor {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> logInDoctor(context,String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await getDoctor(context, email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkDoctor(String email)async{
    try {
      String id;
      final user = await _firestore.collection('doctors').where('email', isEqualTo: email).get();
      for(var data  in user.docs)
      {
        id=data.id;
      }
      if (id!=null) {
        print('exist');
        return true;
      }
      else {
        print('nor exist');
        return false;
      }
    }
    catch(e){
      print('exit with error');
      return false;
    }
  }


  Future<bool> RegisterDoctor(String username, String pass, String email) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        await _firestore.collection('doctors').doc().set({
          'email': email,
          'username': username,
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }


  getDoctor(context,String Checkemail)async{
    String username ,email,docId;
    final user = await _firestore.collection('doctors').where('email', isEqualTo: Checkemail).get();
    for(var data  in user.docs)
    {
      docId=data.id;
      email=data.data()['email'];
      username=data.data()['username'];
    }
    Provider.of<DoctorDetails>(context,listen: false).setDoctorDetails(email,username,docId);
  }
}
