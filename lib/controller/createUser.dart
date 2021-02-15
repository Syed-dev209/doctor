  import 'package:doctor/models/userDetails.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
  import 'package:provider/provider.dart';

  class CreateUser {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    FirebaseMessaging fcm= FirebaseMessaging();

    Future<bool> logInUser(context,String email, String password) async {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        await getPatient(context, email);
        return true;
      } catch (e) {
        return false;
      }
    }

    Future<bool> checkUser(String email)async{
      try {
        String id;
        final user = await _firestore.collection('patients').where('email', isEqualTo: email).get();
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
    Future<bool> RegisterPatient(String username, String pass, String height, String email, String dOB, String weight, String disease) async {
      try {
        final fcmToken=await fcm.getToken(); //Token get
        await _auth
            .createUserWithEmailAndPassword(email: email, password: pass)
            .then((value) async {
          await _firestore.collection('patients').doc().set({
            'email': email,
            'dateOBirth': dOB,
            'disease': disease,
            'height': height,
            'username': username,
            'weight': weight,
            'token':fcmToken
          });
        });
        return true;
      } catch (e) {
        return false;
      }
    }


    Future<bool> logOut()async{
      await _auth.signOut();
      return true;
    }

    Future<bool> RegisterDoctor(String username, String pass,  String email) async {
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

    getPatient(context,String Checkemail)async{
      String username ,height,weight,disease,dob,email,docId;
      final user = await _firestore.collection('patients').where('email', isEqualTo: Checkemail).get();
      for(var data  in user.docs)
        {
          docId=data.id;
          email=data.data()['email'];
          height=data.data()['height'];
          weight=data.data()['weight'];
          disease=data.data()['disease'];
          dob=data.data()['dob'];
          username=data.data()['username'];
        }
      Provider.of<UserDetails>(context,listen: false).setUserDetails(email, username, height,weight,dob,disease,docId);
    }
  }
