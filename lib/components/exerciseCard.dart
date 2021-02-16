import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  String  docId, completed;
  ExerciseCard({this.docId,this.completed});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  String title, description, startDate, days;
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  DateTime date=DateTime.now();
  bool loaded=false;
  var getId,data;
  fillData()async{
    print(widget.docId);
    getId= await _firestore.collection('patients').doc(Provider.of<UserDetails>(context,listen: false).getDocId).collection('exercises').doc(widget.docId).get();
    data = await _firestore.collection('exercises').doc(getId.data()['exerciseDocID']).get();
    print(data.data()['title']);
    title=data.data()['title'];
    description=data.data()['description'];
    days= data.data()['days'];
    startDate=data.data()['startDate'];

    date=DateTime.parse(startDate);
    setState(() {
      loaded=true;
    });
  }

  void asyncCall()async{
    await fillData();
  }
@override
  void initState(){
    // TODO: implement initState
    super.initState();
    asyncCall();
  }


  @override
  Widget build(BuildContext context){
    return loaded?GestureDetector(
      onTap: (){
        Provider.of<ExerciseDescription>(context,listen: false).setExerciseDetails(title,description, days, startDate);
        Provider.of<UserDetails>(context,listen: false).setUserExeDocId(widget.docId);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetails(docID: data.id,)));
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
                      Chip(
                          backgroundColor: widget.completed == 'true'
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          label: Text(
                            widget.completed=='true'?'Completed':'Incomplete',
                            style: TextStyle(
                                color: Color(0XFF404040),
                                fontWeight: FontWeight.bold,
                                fontSize: 19),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 28.0,
                ),
                Expanded(
                  child: Text(
                    title,
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
                    description,
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
                        backgroundColor: Color(0xff674cfb),
                        label: Text(
                          'Start',
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
    ):
        Container(
          height: 300.0,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              )
          ),
        );
  }
}

class listTile extends StatelessWidget {
  listTile({this.title, this.subtitle, this.leading, this.trailing});
  final String title;
  final String subtitle;
  final Icon leading;
  final Icon trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 17,
        ),
      ),
      trailing: trailing,
      leading: leading,
    );
  }
}
