import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/exerciseCard.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/dashboard.dart';
import 'package:doctor/screens/exerciseListPatient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

class ExerciseDetails extends StatefulWidget {
  String docID;

  ExerciseDetails({this.docID});

  @override
  _ExerciseDetailsState createState() => _ExerciseDetailsState();
}

class _ExerciseDetailsState extends State<ExerciseDetails> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Details'),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
          return true;
        },
        child: ProgressHUD(
          child: Builder(
            builder: (context) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 15,
                        child: Container(
                          height: 230,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('images/training.jpg'))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 15,
                        child: Container(
                          height: 370,
                          width: width * 0.8,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Text(
                                  'Training Details',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  height: 13,
                                ),
                                listTile(
                                  title: 'Title',
                                  subtitle: Provider.of<ExerciseDescription>(
                                          context,
                                          listen: false)
                                      .getExerciseDetails['title'],
                                  trailing: Icon(Icons.info_outlined),
                                  leading: Icon(Icons.threesixty_outlined),
                                ),
                                listTile(
                                  title: 'Exercise Days',
                                  subtitle: Provider.of<ExerciseDescription>(
                                          context,
                                          listen: false)
                                      .getExerciseDetails['days'],
                                  trailing: Icon(Icons.info_outlined),
                                  leading: Icon(Icons.threesixty_outlined),
                                ),
                                listTile(
                                  title: 'Description',
                                  subtitle: Provider.of<ExerciseDescription>(
                                          context,
                                          listen: false)
                                      .getExerciseDetails['description'],
                                  trailing: Icon(Icons.info_outlined),
                                  leading: Icon(Icons.threesixty_outlined),
                                ),
                                RaisedButton(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 70, vertical: 11),
                                    color: Color(0xff0f2594),
                                    child: Text(
                                      'Start',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 19),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    onPressed: () async {
                                      print(widget.docID);
                                      final progress = ProgressHUD.of(context);
                                      progress.showWithText('Loading...');
                                      final exercises = await _firestore
                                          .collection('exercises')
                                          .doc(widget.docID)
                                          .collection('exerciseList')
                                          .get();

                                      Provider.of<ExerciseDescription>(context,
                                              listen: false)
                                          .clearExerciseList();

                                      for (var exer in exercises.docs) {
                                        String completed;
                                        String checkId;
                                        /////////////////////////////////////////////////
                                        final completeResult = await _firestore
                                            .collection('exercises')
                                            .doc(widget.docID)
                                            .collection('exerciseList')
                                            .doc(exer.id)
                                            .collection('patientsRecord')
                                            .where('name',
                                                isEqualTo:
                                                    Provider.of<UserDetails>(
                                                            context,
                                                            listen: false)
                                                        .getUserName).get();
                                        for(var compl in completeResult.docs)
                                          {
                                            checkId=compl.id;
                                          }
                                        if(checkId==null){
                                          completed='false';
                                        }
                                        else{
                                          completed='true';
                                        }

                                        //////////////////////////////////////////////
                                        Provider.of<ExerciseDescription>(context,
                                                listen: false)
                                            .setNetworkExercise(
                                                ExerciseNetworkVideo(
                                                  completed: completed,
                                                    video:
                                                        exer.data()['videoUrl'],
                                                    title: exer.data()['title'],
                                                    description: exer
                                                        .data()['description'],
                                                    numOfReps:
                                                        exer.data()['numOfReps'],
                                                    numOfRounds: exer
                                                        .data()['numOfRounds'],
                                                    time: exer.data()['time'],
                                                    docId: exer.id));
                                      }
                                      progress.dismiss();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PatientExerciseList(
                                                    exerciseDocId: widget.docID,
                                                  )));
                                    })
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
