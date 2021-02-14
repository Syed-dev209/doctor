import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/controller/exerciseController.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/screens/adminScreens/adminDashboard.dart';
import 'package:doctor/screens/adminScreens/uploadExercises.dart';
import 'package:flutter/material.dart';
import 'package:doctor/components/alertBox.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

class SelectPatients extends StatefulWidget {
  @override
  _SelectPatientsState createState() => _SelectPatientsState();
}

class _SelectPatientsState extends State<SelectPatients> {
  bool selected = false;
  AlertBoxes _alert;
  CreateExercise _create;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addPatients(context,String email){
    Provider.of<ExerciseDescription>(context,listen: false).setPatientsList(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: Text('Select Patients'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: AdminDrawer(),
      body: ProgressHUD(
        child: Builder(
          builder: (context){
            return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream:_firestore.collection('patients').snapshots(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            return Center(
                              child: Text('No patients'),
                            );
                          }
                          if(snapshot.connectionState==ConnectionState.waiting)
                          {
                            return CircularProgressIndicator();
                          }
                          if(snapshot.hasError){
                            return CircularProgressIndicator();
                          }
                          final patients= snapshot.data.docs;
                          List<PatientTile> patientTiles=[];
                          for(var data in patients)
                          {
                            patientTiles.add(PatientTile(name: data.data()['username'],email: data.data()['email'],));
                          }

                          return Column(
                            children: patientTiles,
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 55),
                            child: Text('Send Exercise'),
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22)),
                            onPressed: ()async {
                              _alert = AlertBoxes();
                              final progress = ProgressHUD.of(context);
                              _create = CreateExercise();
                              progress.showWithText(
                                  'Uploading\nPlease wait...');
                              bool check = await _create.uploadExercise(
                                  exerciseDetails:
                                  Provider.of<ExerciseDescription>(
                                      context,
                                      listen: false)
                                      .getExerciseDetails,
                                  exercises:
                                  Provider.of<ExerciseDescription>(
                                      context,
                                      listen: false)
                                      .getExercisesList,
                                  patientsEmails:
                                  Provider.of<ExerciseDescription>(
                                      context,
                                      listen: false)
                                      .getPatientsList);

                              if(check){
                                progress.dismiss();
                                _alert=AlertBoxes();
                                _alert.simpleAlertBox(context, Text('Congratulations'), Text('Exercise has been uploaded and send to patients.'), (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
                                });
                              }

                            }),
                      )

                    ],
                  ),
                )


            );
          },
        ),
      ),
    );
  }
}

class PatientTile extends StatefulWidget {
  String name,email;
  PatientTile({this.name,this.email});
  @override
  _PatientTileState createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  bool selected=false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        if(selected){
          Provider.of<ExerciseDescription>(context,listen: false).setPatientsList(
              widget.email);
        }
        else{
          Provider.of<ExerciseDescription>(context,listen: false).removePatient(widget.email);
        }
      },
      leading: CircleAvatar(
        radius: 35,
        child: Text(widget.name[0],style: TextStyle(fontSize: 18.0),),
        backgroundColor: Color(0xff674cfb),
      ),
      title: Text(widget.name),
      subtitle: Text(widget.email),
      trailing: selected
          ? Icon(Icons.check_circle, color: Color(0xff674cfb))
          : Container(
        height: 1,
        width: 1,
      ),
    );;
  }
}
