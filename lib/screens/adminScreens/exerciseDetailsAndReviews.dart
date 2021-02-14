import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/components/videoPlayer.dart';
import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/screens/adminScreens/addExercise.dart';
import 'package:doctor/screens/adminScreens/exerciseDetails.dart';
import 'package:doctor/screens/adminScreens/exerciseList.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseDetailsAndReview extends StatefulWidget {
  @override
  _ExerciseDetailsAndReviewState createState() =>
      _ExerciseDetailsAndReviewState();
}

class _ExerciseDetailsAndReviewState extends State<ExerciseDetailsAndReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details and Reviews'),
        centerTitle: true,
      ),
      drawer: AdminDrawer(),
      body: WillPopScope(
        onWillPop: ()async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadVideo(edit: false,)));
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Consumer<ExerciseDescription>(
                  builder: (context, data, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.getExerciseDetails['title'],
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              tooltip: 'Edit Exercise Description',
                                icon: Icon(Icons.edit_sharp,color: Theme.of(context).primaryColor,)
                                , onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadVideo(edit: true,)));
                            })
                          ],
                        ),
                        Divider(
                          color:Theme.of(context).primaryColor,
                          thickness: 2.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('Description',style: TextStyle(
                          fontSize: 18.0
                        ),),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          data.getExerciseDetails['description'],
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text('Total Weeks',style: TextStyle(
                            fontSize: 18.0
                        ),),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '${int.parse(data.getExerciseDetails['days']) / 7}',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.15,),
                        Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 35.0, vertical: 12.0),
                            color: Theme.of(context).primaryColor,
                            child: Text(
                              'View Exercises',
                              style:
                                  TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0
                                  ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminExerciseList(docId: data.getDocId,)));
                            },
                          ),
                        )
                      ],
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
