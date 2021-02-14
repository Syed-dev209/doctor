import 'package:flutter/cupertino.dart';

class DoctorDetails extends ChangeNotifier{
  String _email,_username,_docId;
  setDoctorDetails(String email,String name,String docId){
    _email=email;
    _username=name;
    _docId=_docId;
    notifyListeners();
  }
  get getEmail{return _email;}
  get getDoctorName{return _username;}
  get getDocId{return _docId; }

}