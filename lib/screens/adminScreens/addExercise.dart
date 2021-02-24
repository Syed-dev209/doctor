import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/components/datePicker.dart';
import 'package:doctor/controller/exerciseController.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/screens/adminScreens/adminDashboard.dart';
import 'package:doctor/screens/adminScreens/exerciseDetailsAndReviews.dart';
import 'package:doctor/screens/adminScreens/uploadExercises.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class UploadVideo extends StatefulWidget {
  bool edit;

  UploadVideo({this.edit});

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  DateTime selectedDate = DateTime.now();
  DatePickers _selectDates = DatePickers();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final required = MultiValidator(
      [RequiredValidator(errorText: '*You have to fill this field.')]);
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _weeks = TextEditingController();
  CreateExercise _exercise;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit) {
      selectedDate = DateTime.parse(
          Provider.of<ExerciseDescription>(context, listen: false)
              .getExerciseDetails['startDate']);
      _title.text = Provider.of<ExerciseDescription>(context, listen: false)
          .getExerciseDetails['title'];
      _description.text =
          Provider.of<ExerciseDescription>(context, listen: false)
              .getExerciseDetails['description'];
      _weeks.text = (int.parse(
                  Provider.of<ExerciseDescription>(context, listen: false)
                      .getExerciseDetails['days']) /
              7)
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add an Exercise'),
          centerTitle: true,
          //backgroundColor: Colors.white,
        ),
        drawer: AdminDrawer(),
        body: WillPopScope(
          onWillPop: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exercise Name',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              controller: _title,
                              validator: required,
                              decoration:
                                  InputDecoration(labelText: 'eg. Push Ups'),
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
                              controller: _description,
                              validator: required,
                              decoration: InputDecoration(
                                  labelText:
                                      'eg. Pushups helps you gain muscles'),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              'Number of weeks',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TextFormField(
                              controller: _weeks,
                              validator: required,
                              decoration: InputDecoration(labelText: 'eg. 1, 2'),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Text(
                              'Start Date',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4.0)),
                              child: FlatButton(
                                padding: EdgeInsets.symmetric(
                                  vertical: 7.0,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${selectedDate.toLocal()}".split(' ')[0],
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.black45,
                                    ),
                                  ],
                                ),
                                //color: Colors.white,
                                onPressed: () async {
                                  if (Platform.isAndroid) {
                                    DateTime picked = await _selectDates
                                        .selectDateAndroid(context);
                                    if (picked == null) {
                                      picked = DateTime.now();
                                    }
                                  } else if (Platform.isIOS) {
                                    DateTime picked = await _selectDates
                                        .selectDateIOS(context, (date) {
                                      setState(() {
                                        selectedDate = date;
                                      });
                                    });
                                    if (picked == null) {
                                      picked = DateTime.now();
                                    }
                                    setState(() {
                                      selectedDate = picked;
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            widget.edit
                                ? Center(
                                    child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 55, vertical: 20),
                                        child: Text(
                                          'Update Description',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        ),
                                        color: Color(0xff0f2594),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        onPressed: () async {
                                          if (_key.currentState.validate()) {
                                            _exercise = CreateExercise();
                                            final progress =
                                                ProgressHUD.of(context);
                                            int days = int.parse(_weeks.text) * 7;
                                            Provider.of<ExerciseDescription>(
                                                    context,
                                                    listen: false)
                                                .setExerciseDetails(
                                                    _title.text,
                                                    _description.text,
                                                    days.toString(),
                                                    selectedDate.toString());
                                            progress.showWithText('Updating...');
                                            bool check =
                                                await _exercise.updateDescription(
                                                    Provider.of<ExerciseDescription>(
                                                            context,
                                                            listen: false)
                                                        .getExerciseDetails,
                                                    Provider.of<ExerciseDescription>(
                                                            context,
                                                            listen: false)
                                                        .getDocId);

                                            if(check)
                                              {
                                                progress.dismiss();
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetailsAndReview()));
                                              }
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => UploadExercise()));
                                          }
                                        }),
                                  )
                                : Center(
                                    child: RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 55, vertical: 20),
                                        child: Text(
                                          'Proceed to add exercise',
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.white),
                                        ),
                                        color: Color(0xff0f2594),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        onPressed: () {
                                          if (_key.currentState.validate()) {
                                            int days = int.parse(_weeks.text) * 7;
                                            Provider.of<ExerciseDescription>(
                                                    context,
                                                    listen: false)
                                                .setExerciseDetails(
                                                    _title.text,
                                                    _description.text,
                                                    days.toString(),
                                                    selectedDate.toString());
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UploadExercise(edit: false,)));
                                          }
                                        }),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
