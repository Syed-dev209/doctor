import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/drawerItem.dart';
import 'package:doctor/components/exerciseCard.dart';
import 'package:doctor/controller/createUser.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/exerciseDetails.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  FirebaseFirestore _firestore=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    Future<bool> onWillPopGoToLogIn() {
      CreateUser _user=CreateUser();
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Confirm Exit?',
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
          content: new Text(
              'Do you wish to Logout ?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () async{
                bool check = await _user.logOut();
                if(check){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                }
              },
              child:
              new Text('Yes', style: new TextStyle(fontSize: 18.0)),
            ),
            new FlatButton(
              onPressed: () => Navigator.pop(context), // this line dismisses the dialog
              child: new Text('No', style: new TextStyle(fontSize: 18.0)),
            )
          ],
        ),
      ) ??
          false;
    }
    return Scaffold(
      drawer: Draweritem(),
      body: WillPopScope(
        onWillPop: onWillPopGoToLogIn,
        child: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverAppBar(
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              backgroundColor: Theme.of(context).accentColor,
              centerTitle: true,
              //snap: true,
              floating: true,
              //pinned: true,
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: Image.asset(
                  'images/exercise.jpg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SliverFixedExtentList(
                delegate: SliverChildListDelegate([
                  // ExerciseCard(onPressed: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ExerciseDetails()));
                  // },),
                  StreamBuilder(
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
                        if (details.data()['completed'] != 'true') {
                          card.add(
                              ExerciseCard(
                            docId: details.id,
                            completed: details.data()['completed'],
                          ));
                        }
                      }
                      return Column(
                        children: card,
                      );
                    },
                  )

                ]),
                itemExtent: MediaQuery.of(context).size.height*0.7)
          ],
        )),
      ),
    );
  }
}
