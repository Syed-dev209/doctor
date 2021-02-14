import 'dart:io';
import 'package:doctor/models/userDetails.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class CreateExercise {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> uploadExercise(
      {Map<String, String> exerciseDetails, List<ExerciseVideo> exercises, List<
          String> patientsEmails}) async {
    try {
      print(exercises);
      print(patientsEmails);
      DocumentReference ref = await _firestore.collection('exercises').add(
          exerciseDetails);
      String docId = ref.id;

      for (int i = 0; i < exercises.length; i++) {
        await _addExercise(exercises[i], docId);
      }

      for (int i = 0; i < patientsEmails.length; i++) {
        await _addPatients(patientsEmails[i], docId);
        await _sendToPatients(patientsEmails[i], docId);
      }
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> updateDescription(Map<String,String> exerciseDetails,String docId)async{
    try{
      await _firestore.collection('exercises').doc(docId).update(exerciseDetails);
      return true;
    }
    catch(e){
      return false;
    }
  }
  Future<bool> updateCompletion(context)async{
    try{
      await _firestore.collection('patients').doc(Provider.of<UserDetails>(context,listen: false).getDocId).collection('exercises').doc(Provider.of<UserDetails>(context,listen: false).getUserExeDocId).update({
        'completed':'true',
        'completionDate':DateTime.now().toString(),
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<bool> updateExerciseDescriptionWithVideo({ExerciseNetworkVideo exer, String docId,File video})async{
    try {
      await _deleteVideo(toDelete: exer.video);
      String url = await _uploadExerciseVideo(video);
      await _firestore.collection('exercises').doc(docId).collection('exerciseList').doc(exer.docId).update({
        'videoUrl': url,
        'title': exer.title,
        'description': exer.description,
        'time': exer.time,
        'numOfReps': exer.numOfReps,
        'numOfRounds': exer.numOfRounds
      });
      return true;
    }
    catch(e){
      return false;
    }
  }
  Future<bool> updateExerciseDescriptionWithoutVideo({ExerciseNetworkVideo exer, String docId})async{
    try {
      await _firestore.collection('exercises').doc(docId).collection('exerciseList').doc(exer.docId).update({
        'videoUrl': exer.video,
        'title': exer.title,
        'description': exer.description,
        'time': exer.time,
        'numOfReps': exer.numOfReps,
        'numOfRounds': exer.numOfRounds
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<void> _sendToPatients(String email,String exrDocId) async {
    String patId;
    final user = await _firestore.collection('patients').where('email',isEqualTo: email).get();
    for(var data in user.docs)
      {
        patId=data.id;
      }
    await _firestore.collection('patients').doc(patId).collection('exercises').add({
      'exerciseDocID':exrDocId,
      'completed':'false',
      'completionDate':'none'
    });

  }

  Future<void> _addPatients(String email,String docID) async {
    await _firestore.collection('exercises').doc(docID).collection('patients').add({
      'email':email,
      'completed':'false',
      'completionDate':'none'
    });

  }

  Future<void> _addExercise(ExerciseVideo exer, String docId) async {
    String videoUrl = await _uploadExerciseVideo(exer.video);
    print(videoUrl);
    await _firestore.collection('exercises').doc(docId).collection(
        'exerciseList').doc().set({
      'videoUrl': videoUrl,
      'title': exer.title,
      'description': exer.description,
      'time': exer.time,
      'numOfReps': exer.numOfReps,
      'numOfRounds': exer.numOfRounds
    });
  }

  Future<String> _uploadExerciseVideo(File video) async {
    String url = '';
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref('exerciseVideos/${Path.basename(video.path)}');
    await storageReference.putFile(video);
    url = await storageReference.getDownloadURL();
    return url;
  }

  Future<void> _deleteVideo({String toDelete})async{
    firebase_storage.Reference photoRef= firebase_storage.FirebaseStorage.instance.refFromURL(toDelete);
    await photoRef.delete();
  }

  Future<bool> submitReview(context,String mainDocId,String exerDocId,String reps,String rounds,String feedback,String difficulty)async{
    try {
      print(mainDocId);
      print(exerDocId);
      await _firestore.collection('exercises').doc(mainDocId).collection(
          'exerciseList').doc(exerDocId).collection('reviews').doc().set({
        'sentBy': Provider
            .of<UserDetails>(context, listen: false)
            .getUserName,
        'review': feedback,
        'repsDone': reps,
        'roundsDone': rounds,
        'difficultyLevel': difficulty
      });
      await _firestore.collection('exercises').doc(mainDocId).collection('exerciseList').doc(exerDocId).collection('patientsRecord').doc().set({
        'name':Provider.of<UserDetails>(context,listen: false).getUserName,
        'date':DateTime.now().toString()
      });
      return true;
    }
    catch(e){
      return false;
    }
  }
}