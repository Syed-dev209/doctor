import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:flutter/cupertino.dart';

class ExerciseDescription extends ChangeNotifier {
  Map<String, String> _exerciseDetails;
  List<ExerciseVideo> exerciseList = [];
  List<String> patients = [];
  List<ExerciseNetworkVideo> networkExerciseList = [];
  String _docId;

  setExerciseDetails(
      String title, String description, String days, String startDate) {
    _exerciseDetails = {
      'title': title,
      'description': description,
      'days': days,
      'startDate': startDate
    };
    notifyListeners();
  }
  clearExerciseList(){
    networkExerciseList.clear();
    notifyListeners();
  }

  setExerciseDocId(String docId) {
    _docId = docId;
    notifyListeners();
  }

  setExercises(ExerciseVideo exerciseVideo) {
    exerciseList.add(exerciseVideo);
    notifyListeners();
  }

  setNetworkExercise(ExerciseNetworkVideo exerciseVideo) {
    networkExerciseList.add(exerciseVideo);
    notifyListeners();
  }

  setPatientsList(String email) {
    patients.add(email);
    notifyListeners();
  }

  removePatient(String email) {
    patients.removeWhere((element) => element == email);
    notifyListeners();
  }

  get getPatientsList {
    return patients;
  }

  get getExerciseDetails {
    return _exerciseDetails;
  }

  get getExercisesList {
    return exerciseList;
  }

  get getExerciseNetList {
    return networkExerciseList;
  }

  get getDocId{return _docId;}
}
