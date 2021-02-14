import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/components/adminExerciseCard.dart';
import 'package:doctor/components/alertBox.dart';
import 'package:doctor/controller/createUser.dart';
import 'package:doctor/screens/adminScreens/exerciseDetailsAndReviews.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:doctor/components/exerciseCard.dart';
import 'package:doctor/components/drawerItem.dart';
class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  FirebaseFirestore _firestore= FirebaseFirestore.instance;
  AlertBoxes _alert=AlertBoxes();
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
    print('called ');
    return Scaffold(
      drawer: AdminDrawer(),
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
                    background:  Image.asset(
                      'images/exercise.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SliverFixedExtentList(
                    delegate: SliverChildListDelegate([
                      StreamBuilder(
                        stream: _firestore.collection('exercises').snapshots(),
                          builder:(context,snapshot){
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
                            List<AdminExerciseCard> cards =[];
                            for(var exr in data)
                              {
                                cards.add(AdminExerciseCard(title: exr.data()['title'],description: exr.data()['description'],days: exr.data()['days'],startDate: exr.data()['startDate'],docId: exr.id));
                              }
                            return Column(
                              children: cards,
                            );
                          }
                      )
                    ]),
                    itemExtent: MediaQuery.of(context).size.height*0.7)
              ],
            )),
      ),
    );
  }
}
