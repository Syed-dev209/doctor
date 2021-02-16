import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserDetails extends ChangeNotifier{
  String _email;
  String _docId,_username,_height,_weight,_dob,_disease,_userExerDocId;

  setUserDetails(String email,String username,String height,String weight,String dob,String disease,String docId){
    _email=email;
    _username=username;
    _height=height;
    _weight=weight;
    _dob=dob;
    _disease=disease;
    _docId=docId;
    print(_dob);
    notifyListeners();
  }
  setUserExeDocId(String docId){
    _userExerDocId=docId;
    notifyListeners();
  }

  setDoctorDetails(String email,String username,String docId){
    _email=email;
    _username=username;
    _docId=_docId;
    notifyListeners();
  }
  get getDocId{return _docId;}
  get getEmail{return _email;}
  get getUserName{return _username;}
  get getWeight{return _weight;}
  get getHeight{return _height;}
  get getDOB{return _dob;}
  get getDisease{return _disease;}
  get getUserExeDocId{return _userExerDocId;}

}