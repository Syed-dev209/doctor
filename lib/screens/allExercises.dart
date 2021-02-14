import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/drawerItem.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:flutter/material.dart';
import 'package:doctor/components/exerciseCard.dart';
import 'package:provider/provider.dart';

class AllExercises extends StatefulWidget {
  @override
  _AllExercisesState createState() => _AllExercisesState();
}

class _AllExercisesState extends State<AllExercises> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createExercise(String exerciseDocId) async {
    final data =
        await _firestore.collection('exercises').doc(exerciseDocId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Exercises',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: Draweritem(),
      body: SafeArea(
          child: SingleChildScrollView(
        child: StreamBuilder(
          stream: _firestore
              .collection('patients')
              .doc(Provider.of<UserDetails>(context).getDocId)
              .collection('exercises')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('No Exercises'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return CircularProgressIndicator();
            }
            final data = snapshot.data.docs;
            List<ExerciseCard> card = [];
            for (var details in data) {
              if(details.data()['completed']=='true') {
                card.add(ExerciseCard(
                  docId: details.id,
                  completed: details.data()['completed'],
                ));
              }
            }
            // for(var d in data){
            //   print(d.id);
            // }
            // print('now returned');
            return Column(
              children: card,
            );
          },
        ),
      )),
    );
  }
}
