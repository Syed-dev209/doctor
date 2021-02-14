import 'package:doctor/models/exerciseDescriptionModel.dart';
import 'package:doctor/models/exerciseVideoModel.dart';
import 'package:doctor/screens/videoSection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientExerciseList extends StatefulWidget {
  String exerciseDocId;
  PatientExerciseList({this.exerciseDocId});
  @override
  _PatientExerciseListState createState() => _PatientExerciseListState();
}

class _PatientExerciseListState extends State<PatientExerciseList> {
  List<ExerciseNetworkVideo> exerciseList;
  List<String> completed=[];
  @override
  void initState() {
    // TODO: implement initState
    exerciseList=Provider.of<ExerciseDescription>(context,listen: false).getExerciseNetList;
    for(int i=0;i<exerciseList.length;i++){
      completed.add(exerciseList[i].completed);
    }
    print(completed);
    int i = completed.lastIndexOf('true');
    print('$i');
    if(exerciseList.length==1) {
      exerciseList[i].completed = 'true';
    }
    else{
      exerciseList[i + 1].completed = 'true';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Provider.of<ExerciseDescription>(context,listen: false).clearExerciseList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Exercises',style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: ListView.builder(
              itemCount: exerciseList.length,
              itemBuilder: (context,index){
              print(exerciseList[index].completed);
                return ExerciseListTile(exerciseData: exerciseList[index],docId:widget.exerciseDocId,last: index==exerciseList.length-1?true:false,);
              }
          ),
        ),
      ),
    );
  }
}

class ExerciseListTile extends StatelessWidget {

  ExerciseNetworkVideo exerciseData;
  String docId;
  bool last;
  ExerciseListTile({this.exerciseData,this.docId,this.last});

  // bool locked=exerciseData.completed=='true'?true:false;
  // print(exerciseData.completed);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        if(exerciseData.completed!='false') {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => VideoSection(exercise: exerciseData,exerciseDocId:docId,last: last,)));
        }
      },
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          color: Color(0xff674cfb),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(exerciseData.title[0],style: TextStyle(
            fontSize: 25.0,
            color: Colors.white
          ),),
        ),
      ),
      title: Text(exerciseData.title,style: TextStyle(
        fontSize: 19,
      ),),
      trailing: exerciseData.completed=='true'?Icon(Icons.arrow_forward_outlined,size: 30.0,color: Colors.green,):Icon(Icons.lock_outline_sharp,color: Colors.red,size: 30.0,)
    );
  }
}
