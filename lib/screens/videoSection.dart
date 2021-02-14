import 'package:better_player/better_player.dart';
import 'package:doctor/controller/exerciseController.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/screens/dashboard.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:doctor/screens/exerciseListPatient.dart';
import 'package:flutter/material.dart';
import 'package:doctor/components/dropdown.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoSection extends StatefulWidget {
  ExerciseNetworkVideo exercise;
  String exerciseDocId;
  bool last;
  VideoSection({this.exercise,this.exerciseDocId,this.last});
  @override
  _VideoSectionState createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  DropDowns _selectDropDown = DropDowns();
  CreateExercise _create;

  Future<void> submitReview(context,String reps,String rounds,String difficulty,String feedback)async{
    _create=CreateExercise();
    bool check = await _create.submitReview(context, widget.exerciseDocId, widget.exercise.docId, reps, rounds, feedback, difficulty);
    if(widget.last)
      {
      bool updated= await _create.updateCompletion(context);
      }
    if(check)
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetails(docID: widget.exercise.docId,)));
      }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.exerciseDocId);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BetterPlayer.network(
                widget.exercise.video,
                betterPlayerConfiguration: BetterPlayerConfiguration(
                    aspectRatio: 1.5,
                    looping: true,
                    //autoPlay: true,
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  'Tip',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(widget.exercise.description,
                  style: TextStyle(
                      fontSize: 19.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  'Number of Reps',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(widget.exercise.numOfReps,
                  style: TextStyle(
                      fontSize: 19.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(
                  'Number of Rounds',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Text(widget.exercise.numOfRounds,
                  style: TextStyle(
                      fontSize: 19.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black38),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Center(
                child: RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 55),
                    child: Text('Finish',style: TextStyle(
                      fontSize: 18,
                        color: Colors.white
                    ),),
                    color: Color(0xff674cfb),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                      //  barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          TextEditingController _feedback=TextEditingController();
                          List<String> reps=[];
                          String selectedReps='1';
                          List<String> rounds=[];
                          String selectedRounds='1';
                          for(int i=0;i<int.parse(widget.exercise.numOfReps);i++)
                          {
                            int a = i+1;
                            reps.add(a.toString());
                            print(reps);
                          }
                          for(int i=0;i<int.parse(widget.exercise.numOfRounds);i++)
                          {
                            int a = i+1;
                            rounds.add(a.toString());
                            print(rounds);
                          }
                          return StatefulBuilder(
                              builder: (context,setState){
                            return AlertDialog(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('How did it go?'),
                                  Text('I completed'),
                                ],
                              ),
                              content: Container(
                                height: 500,
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children: [
                                                Text('Reps'),
                                                SizedBox(height: 4.0,),
                                                Platform.isAndroid
                                                    ? Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 23.0),
                                                    child: _selectDropDown
                                                        .dropDownAndroid(
                                                        reps, selectedReps,
                                                            (newValue) {
                                                          setState(() {
                                                            selectedReps = newValue;
                                                          });
                                                        }),
                                                  ),
                                                )
                                                    : Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 23.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                      children: [
                                                        TextButton(
                                                          child: Text(
                                                            selectedReps,
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black45,
                                                                fontSize: 16.0),
                                                          ),
                                                          onPressed: () {
                                                            _selectDropDown
                                                                .showPicker(
                                                                context, reps,
                                                                    (newValue) {
                                                                  setState(() {
                                                                    selectedReps =
                                                                        newValue;
                                                                  });
                                                                });
                                                          },
                                                        ),
                                                        Divider(
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children: [
                                                Text('Reps'),
                                                SizedBox(height: 4.0,),
                                                Platform.isAndroid
                                                    ? Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 23.0),
                                                    child: _selectDropDown
                                                        .dropDownAndroid(
                                                        rounds, selectedRounds,
                                                            (newValue) {
                                                          setState(() {
                                                            selectedRounds = newValue;
                                                          });
                                                        }),
                                                  ),
                                                )
                                                    : Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 23.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.stretch,
                                                      children: [
                                                        TextButton(
                                                          child: Text(
                                                            selectedRounds,
                                                            style: TextStyle(
                                                                color: Colors.black45,
                                                                fontSize: 16.0),
                                                          ),
                                                          onPressed: () {
                                                            _selectDropDown.showPicker(
                                                                context, rounds,
                                                                    (newValue) {
                                                                  setState(() {
                                                                    selectedRounds =
                                                                        newValue;
                                                                  });
                                                                });
                                                          },
                                                        ),
                                                        Divider(
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10.0,),
                                    Expanded(
                                      child: TextField(
                                        controller: _feedback,
                                        decoration:
                                        InputDecoration(hintText: 'Feedback'),
                                      ),
                                    ),
                                    Text('Difficulty level'),
                                    SizedBox(height: 4.0,),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          DifficultyButtons('0', 'No Pain', FaIcon(FontAwesomeIcons.smile), Color(0XFF6fc113), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '0',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('1', 'Faint Pain', FaIcon(FontAwesomeIcons.meh), Color(0XFFbecb18), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '1',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('2', ' ', FaIcon(FontAwesomeIcons.frown), Color(0XFFf8d31c),()async{
                                            await submitReview(context, selectedReps, selectedRounds, '2',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('3', ' ', FaIcon(FontAwesomeIcons.frown), Color(0XFFf7c71f), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '3',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('4', 'Moderate', FaIcon(FontAwesomeIcons.frown), Color(0XFFf8bc1e), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '4',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('5', ' ', FaIcon(FontAwesomeIcons.frown), Color(0XFFf8bc1e), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '5',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 4.0,),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          DifficultyButtons('6', ' ', FaIcon(FontAwesomeIcons.frown), Color(0XFFf1a022), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '6',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('7', 'Severe', FaIcon(FontAwesomeIcons.meh), Color(0XFFe27b1d), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '7',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('8', ' ', FaIcon(FontAwesomeIcons.frown), Color(0XFFd3591c), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '8',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('9', 'Angry', FaIcon(FontAwesomeIcons.frown), Color(0XFFc43618), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '9',_feedback.text);
                                          }),
                                          SizedBox(width: 1,),
                                          DifficultyButtons('10', 'Alert', FaIcon(FontAwesomeIcons.frown), Color(0XFFad0214), ()async{
                                            await submitReview(context, selectedReps, selectedRounds, '10  ',_feedback.text);
                                          }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            );
                          });
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget DifficultyButtons(String value,String label,FaIcon icon,Color colour,Function onPressed){
      return Expanded(
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            height: 150.0,
            color: colour,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: icon),
                Expanded(
                  child: Text(value,style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0
                  ),),
                ),
                Expanded(
                  child: Text(label,style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0
                  ),),
                )
              ],
            ),
          ),
        ),
      );
  }
}

