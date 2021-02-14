import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/screens/adminScreens/exerciseDetails.dart';
import 'package:flutter/material.dart';

class AdminExerciseList extends StatefulWidget {
  String docId;

  AdminExerciseList({this.docId});

  @override
  _AdminExerciseListState createState() => _AdminExerciseListState();
}

class _AdminExerciseListState extends State<AdminExerciseList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: _firestore.collection('exercises')
                    .doc(widget.docId)
                    .collection('exerciseList')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('No texts');
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator()
                    );
                  }
                  final list = snapshot.data.docs;
                  List<ExerciseListTile> tiles = [];
                  for (var data in list) {
                    ExerciseNetworkVideo obj = ExerciseNetworkVideo(
                        video: data.data()['videoUrl'],
                        title: data.data()['title'],
                        description: data.data()['description'],
                        time: data.data()['time'],
                        numOfRounds: data.data()['numOfRounds'],
                        numOfReps: data.data()['numOfReps'],
                      docId: data.id
                    );
                    tiles.add(ExerciseListTile(exerciseData: obj,docId: widget.docId,));
                  }
                  return Column(
                    children: tiles,
                  );
                },
              ),
            )
        ),
      ),
    );
  }
}

class ExerciseListTile extends StatelessWidget {
  ExerciseNetworkVideo exerciseData;
  String docId;

  ExerciseListTile({this.exerciseData, this.docId});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetailsAdmin(exerciseData: exerciseData,docId: docId,)));
        },
        leading: Container(
          height: 50.0,
          width: 50.0,
          decoration: BoxDecoration(
            color: Color(0xff674cfb),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(exerciseData.title[0], style: TextStyle(
                fontSize: 25.0,
                color: Colors.white
            ),),
          ),
        ),
        title: Text(exerciseData.title, style: TextStyle(
          fontSize: 19,
        ),),
        trailing: Icon(
          Icons.arrow_forward_outlined, size: 30.0, color: Colors.green,)
    );
  }
}