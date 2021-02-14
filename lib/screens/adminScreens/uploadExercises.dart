import 'dart:io';
import 'package:doctor/components/alertBox.dart';
import 'package:doctor/components/videoPlayer.dart';
import 'package:doctor/controller/exerciseController.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/screens/adminScreens/addExercise.dart';
import 'package:doctor/screens/adminScreens/exerciseList.dart';
import 'package:doctor/screens/adminScreens/selectPartients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadExercise extends StatefulWidget {
  bool edit;
  ExerciseNetworkVideo exerData;

  UploadExercise({this.edit, this.exerData});

  @override
  _UploadExerciseState createState() => _UploadExerciseState();
}

class _UploadExerciseState extends State<UploadExercise> {
  File _video;

  final picker = ImagePicker();

  bool videoPicked = false;
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _numOFReps = TextEditingController();
  TextEditingController _numOfRounds = TextEditingController();
  TextEditingController _time = TextEditingController();
  String videoUrl = '';
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  CreateExercise _create;
  AlertBoxes _alert;
  bool changed = false;

  Future<void> _getVideo() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);
    // final video=File(pickedFile.path);
    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        videoPicked = true;
        changed = true;
      } else {
        print('No video selected.');
      }
    });
  }

  addExerciseDetails(context) {
    ExerciseVideo exercise = ExerciseVideo(
        title: _title.text,
        description: _description.text,
        time: _time.text,
        numOfReps: _numOFReps.text,
        numOfRounds: _numOfRounds.text,
        video: _video);
    Provider.of<ExerciseDescription>(context, listen: false)
        .setExercises(exercise);
  }

  final _validator = MultiValidator(
      [RequiredValidator(errorText: '*This is a required field')]);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      videoPicked = true;
      videoUrl = widget.exerData.video;
      _title.text = widget.exerData.title;
      _description.text = widget.exerData.description;
      _numOfRounds.text = widget.exerData.numOfRounds;
      _numOFReps.text = widget.exerData.numOfReps;
      _time.text = widget.exerData.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UploadVideo(
                        edit: false,
                      )));
          return true;
        },
        child: ProgressHUD(
          child: Builder(
            builder: (context) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          !videoPicked
                              ? GestureDetector(
                                  onTap: () async {
                                    await _getVideo();
                                  },
                                  child: Container(
                                    height: 200.0,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.ondemand_video_outlined,
                                            size: 28.0,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          Text(
                                            'Upload a video',
                                            style: TextStyle(
                                                fontSize: 19,
                                                color: Theme.of(context)
                                                    .accentColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : !changed
                                  ? VideoPlayer(
                                      url: videoUrl,
                                      networkUrl: true,
                                    )
                                  : VideoPlayer(
                                      url: _video.path,
                                      networkUrl: false,
                                    ),

                          // BetterPlayer.file(
                          //         _video.path,
                          //         betterPlayerConfiguration:
                          //             BetterPlayerConfiguration(
                          //           aspectRatio: 1.5,
                          //           looping: true,
                          //           //autoPlay: true,
                          //           fit: BoxFit.contain,
                          //           autoDispose: true,
                          //         ),
                          //       ),
                          videoPicked
                              ? Center(
                                  child: RaisedButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 55),
                                      child: Text(
                                        'Change Video',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      onPressed: () async {
                                        await _getVideo();
                                      }),
                                )
                              : Container(),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Exercise Title',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _title,
                            validator: _validator,
                            decoration: InputDecoration(
                              labelText: 'Define exercise and tips',
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Exercise Description',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _description,
                            validator: _validator,
                            decoration: InputDecoration(
                              labelText: 'Define exercise and tips',
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Number of Reps',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _numOFReps,
                            validator: _validator,
                            decoration: InputDecoration(labelText: 'eg. 12'),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Number of Rounds',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _numOfRounds,
                            validator: _validator,
                            decoration:
                                InputDecoration(labelText: 'eg. 1, 2, 3'),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            'Exercise Time',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          TextFormField(
                            controller: _time,
                            validator: _validator,
                            keyboardType: TextInputType.number,
                            decoration:
                                InputDecoration(labelText: 'eg. 15 minutes'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          widget.edit
                              ? Center(
                                  child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 55, vertical: 20),
                                      child: Text(
                                        'Update exercise',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      onPressed: () async {
                                        if (_key.currentState.validate()) {
                                          _create = CreateExercise();
                                          final progress =
                                              ProgressHUD.of(context);
                                          if (changed) {
                                            ExerciseNetworkVideo obj =
                                                ExerciseNetworkVideo(
                                                    video:
                                                        widget.exerData.video,
                                                    title: _title.text,
                                                    description:
                                                        _description.text,
                                                    numOfReps: _numOFReps.text,
                                                    numOfRounds:
                                                        _numOfRounds.text,
                                                    time: _time.text,
                                                    docId:
                                                        widget.exerData.docId);
                                            progress
                                                .showWithText('Updating...');
                                            bool check = await _create
                                                .updateExerciseDescriptionWithVideo(
                                                    exer: obj,
                                                    docId: Provider.of<
                                                                ExerciseDescription>(
                                                            context,
                                                            listen: false)
                                                        .getDocId,
                                                    video: _video);
                                            if (check) {
                                              progress.dismiss();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminExerciseList(
                                                              docId: Provider.of<
                                                                          ExerciseDescription>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getDocId)));
                                            }
                                          } else {
                                            ExerciseNetworkVideo obj =
                                                ExerciseNetworkVideo(
                                                    video:
                                                        widget.exerData.video,
                                                    title: _title.text,
                                                    description:
                                                        _description.text,
                                                    numOfReps: _numOFReps.text,
                                                    numOfRounds:
                                                        _numOfRounds.text,
                                                    time: _time.text,
                                                    docId:
                                                        widget.exerData.docId);
                                            progress
                                                .showWithText('Updating...');
                                            bool check = await _create
                                                .updateExerciseDescriptionWithoutVideo(
                                                    exer: obj,
                                                    docId: Provider.of<
                                                                ExerciseDescription>(
                                                            context,
                                                            listen: false)
                                                        .getDocId);
                                            if (check) {
                                              progress.dismiss();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminExerciseList(
                                                              docId: Provider.of<
                                                                          ExerciseDescription>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getDocId)));
                                            }
                                          }
                                          // addExerciseDetails(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             UploadExercise()));
                                        }
                                      }),
                                )
                              : Container(),

                          !widget.edit
                              ? Center(
                                  child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 55, vertical: 20),
                                      child: Text(
                                        'Add next exercise',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      onPressed: () {
                                        if (_key.currentState.validate()) {
                                          addExerciseDetails(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UploadExercise(
                                                        edit: false,
                                                      )));
                                        }
                                      }),
                                )
                              : Container(),
                          SizedBox(
                            height: 20.0,
                          ),
                          !widget.edit
                              ? Center(
                                  child: RaisedButton(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 55, vertical: 20),
                                      child: Text(
                                        'Proceed to select patients',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(22)),
                                      onPressed: () async {
                                        if (_key.currentState.validate()) {
                                          addExerciseDetails(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectPatients()));
                                        }
                                      }),
                                )
                              : Container()
                        ],
                      ),
                    ),
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
