import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/components/alertBox.dart';
import 'package:doctor/controller/createUser.dart';
import 'package:doctor/register.dart';
import 'package:doctor/screens/adminScreens/patientProfile.dart';
import 'package:flutter/material.dart';

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Patient List',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: AdminDrawer(),
      body: SafeArea(
          child: Stack(
        children: [
          StreamBuilder(
            stream: _firestore.collection('patients').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No patients'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return CircularProgressIndicator();
              }
              final patients = snapshot.data.docs;
              List<PatientTile> patientTiles = [];
              for (var data in patients) {
                patientTiles.add(PatientTile(
                  name: data.data()['username'],
                  email: data.data()['email'],
                  dob: data.data()['dateOBirth'],
                  height: data.data()['height'],
                  weight: data.data()['weight'],
                  disease: data.data()['disease'],
                  docId: data.id,
                  password: data.data()['password'],
                ));
              }
              return Column(
                children: patientTiles,
              );
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.0, vertical: 11.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Registrer()));
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xff0f2594),
                  radius: 30.0,
                  child: Icon(Icons.add, color: Colors.white, size: 30.0),
                ),
              ),
            ),
          )
        ],
      ),),
    );
  }
}

class PatientTile extends StatelessWidget {
  String name, email, dob, height, weight, disease,docId,password;
  CreateUser _user=CreateUser();

  PatientTile(
      {this.email,
      this.name,
      this.dob,
      this.height,
      this.weight,
      this.disease,
      this.docId,
      this.password
      });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientProfile(
                      name: name,
                      email: email,
                      height: height,
                      weight: weight,
                      dob: DateTime.parse(dob)
                          .toLocal()
                          .toString()
                          .split(' ')[0],
                      disease: disease,
                    )));
      },
      leading: CircleAvatar(
        radius: 35,
        child: Text(
          name[0],
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        backgroundColor: Color(0xff0f2594),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: Text(
        email,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      trailing: IconButton(icon: Icon(Icons.delete_outline),color: Colors.red,iconSize: 28.0,onPressed: ()async{
        bool check = await _user.deleteUser(docId, email, password);
        if(!check){
          AlertBoxes alert = AlertBoxes();
          alert.simpleAlertBox(context, Text('Something went wrong.'), Text('Please try again later.'), (){
            Navigator.pop(context);
          });
        }
      },),
    );

  }
}
