import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  String exerDocId;

  ReviewScreen({this.exerDocId});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reviews',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: StreamBuilder(
                stream: _firestore
                    .collection('exercises')
                    .doc(
                        Provider.of<ExerciseDescription>(context, listen: false)
                            .getDocId)
                    .collection('exerciseList')
                    .doc(widget.exerDocId)
                    .collection('reviews')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('No Reviews'),
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
                  final reviews = snapshot.data.docs;
                  List<ReviewCard> card = [];
                  for (var data in reviews) {
                    card.add(ReviewCard(
                      name: data.data()['sentBy'],
                      reps: data.data()['repsDone'],
                      rounds: data.data()['roundsDone'],
                      difficulty: data.data()['difficultyLevel'],
                      review: data.data()['review'],
                    ));
                  }

                  return Column(
                    children: card,
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  String name, reps, rounds, difficulty, review;

  ReviewCard({this.name, this.reps, this.rounds, this.difficulty, this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              name[0],
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
          title: Text(name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Number of Reps Done: $reps'),
              SizedBox(
                height: 5.0,
              ),
              Text('Number of Rounds completed: $rounds'),
              SizedBox(
                height: 5.0,
              ),
              Text('Difficulty Level Faced: $difficulty'),
              SizedBox(
                height: 5.0,
              ),
              Text(review)
            ],
          ),
        ),
      ),
    );
  }
}
