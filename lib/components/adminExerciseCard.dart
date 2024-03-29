import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/adminScreens/exerciseDetailsAndReviews.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';
import '../controller/exerciseController.dart';
import '../controller/exerciseController.dart';
import 'alertBox.dart';
import 'alertBox.dart';

class AdminExerciseCard extends StatefulWidget {
  String title, description, startDate, days, docId, completed;
  AdminExerciseCard({this.title,this.description,this.startDate,this.days,this.docId});

  @override
  _AdminExerciseCardState createState() => _AdminExerciseCardState();
}

class _AdminExerciseCardState extends State<AdminExerciseCard> {
CreateExercise _exercise=CreateExercise();
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    DateTime date=DateTime.parse(widget.startDate);
    return ProgressHUD(child: Builder(
      builder: (context)
      {
        return GestureDetector(
          onLongPress: ()async{
            AlertBoxes alert = AlertBoxes();
            print(widget.docId);
            alert.simpleAlertBox(context, Text('Do you want to delete this exercise?'), Text('Press Ok to delete'), ()async{
              final progress = ProgressHUD.of(context);
              //progress.showWithText('Deleting...');
              bool check = await _exercise.deleteExercise(widget.docId);
              if(check){
               // progress.dismiss();
                Navigator.pop(context);
              }
              else{
                //progress.dismiss();
              }
            });

          },
          onTap: (){
            Provider.of<ExerciseDescription>(context,listen:false).setExerciseDetails(widget.title, widget.description, widget.days, widget.startDate);
            Provider.of<ExerciseDescription>(context,listen: false).setExerciseDocId(widget.docId);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetailsAndReview()));
          } ,
          child: Card(
            elevation: 5.0,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 220.0,
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                decoration: BoxDecoration(
                    color: Color(0XFF404040),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Workout',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 29.0,
                                fontWeight: FontWeight.bold),
                          ),
                          // Chip(
                          //     backgroundColor: widget.completed == 'true'
                          //         ? Colors.greenAccent
                          //         : Colors.redAccent,
                          //     label: Text(
                          //       widget.completed=='true'?'Completed':'Incomplete',
                          //       style: TextStyle(
                          //           color: Color(0XFF404040),
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 19),
                          //     ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 28.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Expanded(
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date:- ${date.toLocal().toString().split(' ')[0]}',
                            style: TextStyle(color: Colors.white, fontSize: 22.0),
                          ),
                          Chip(
                            backgroundColor: Color(0xff0f2594),
                            label: Text(
                              'Check',
                              style: TextStyle(color: Colors.white),
                            ),
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        );
      },
    ));
  }
}

