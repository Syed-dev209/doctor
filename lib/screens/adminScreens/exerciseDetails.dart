import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/videoPlayer.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/screens/adminScreens/reviewScreen.dart';
import 'package:doctor/screens/adminScreens/uploadExercises.dart';
import 'package:flutter/material.dart';

class ExerciseDetailsAdmin extends StatefulWidget {
  ExerciseNetworkVideo exerciseData;
  String docId;

  ExerciseDetailsAdmin({this.exerciseData, this.docId});

  @override
  _ExerciseDetailsAdminState createState() => _ExerciseDetailsAdminState();
}

class _ExerciseDetailsAdminState extends State<ExerciseDetailsAdmin> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Details',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VideoPlayer(
                  url: widget.exerciseData.video,
                  networkUrl: true,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text(
                  widget.exerciseData.title??' ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  )
                  ),
                    IconButton(
                      tooltip: 'Edit Exercise Details',
                        icon: Icon(Icons.edit_sharp,color: Theme.of(context).primaryColor,),
                        onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadExercise(edit: true,exerData: widget.exerciseData,)));
                        })
                    ],
                ),
                Divider(
                  color: Color(0xff0f2594),
                  thickness: 2,
                ),
                Text('Description',style: TextStyle(
                    fontSize: 18.0
                ),),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  widget.exerciseData.description??' ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Time',style: TextStyle(
                    fontSize: 18.0
                ),),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  widget.exerciseData.time??' ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text('Reps',style: TextStyle(
                    fontSize: 18.0
                ),),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  widget.exerciseData.numOfReps??' ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text('Rounds',style: TextStyle(
                    fontSize: 18.0
                ),),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  widget.exerciseData.numOfRounds??' ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
                Divider(
                  color:Color(0xff0f2594),
                  thickness: 2,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Patients completed this exercise',
                  style: TextStyle(fontSize: 24.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                StreamBuilder(
                    stream: _firestore
                        .collection('exercises')
                        .doc(widget.docId)
                        .collection('exerciseList')
                        .doc(widget.exerciseData.docId)
                        .collection('patientsRecord')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('No patients'),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final patients = snapshot.data.docs;
                      List<PatientTile> tiles = [];
                      for (var pati in patients) {
                        tiles.add(PatientTile(
                          name: pati.data()['name'],
                          date: pati.data()['date'],
                        ));
                      }
                      return Column(
                        children: tiles,
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(Icons.rate_review),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'View Reviews',
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReviewScreen(exerDocId: widget.exerciseData.docId,)));


        },
      ),
    );
  }
}

class PatientTile extends StatelessWidget {
  String name;
String date;
  PatientTile({this.name,this.date});

  @override
  Widget build(BuildContext context) {
    DateTime dated= DateTime.parse(date);
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundColor: Color(0xff674cfb),
        child: Text(name[0]),
      ),
      title: Text(name),
      subtitle: Text('Dated:- ${dated.toLocal().toString().split(' ')[0]}'),
    );
  }
}
