import 'dart:io';
class   ExerciseVideo{
  File video;
  String title,description,numOfReps,numOfRounds,time;
  ExerciseVideo({this.video,this.title,this.description,this.numOfReps,this.numOfRounds,this.time});
}

class ExerciseNetworkVideo{
  String video;
  String title,description,numOfReps,numOfRounds,time,docId,completed;
  ExerciseNetworkVideo({this.video,this.title,this.description,this.numOfReps,this.numOfRounds,this.time,this.docId,this.completed});
}