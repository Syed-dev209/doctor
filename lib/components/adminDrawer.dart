import 'package:doctor/controller/createUser.dart';
import 'package:doctor/models/doctorDetails.dart';
import 'package:doctor/screens/adminScreens/addExercise.dart';
import 'package:doctor/screens/adminScreens/adminDashboard.dart';
import 'package:doctor/screens/adminScreens/patientList.dart';
import 'package:doctor/screens/profile.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: UserAccountsDrawerHeader(
                arrowColor: Theme.of(context).accentColor,
                accountName: Text(
                  Provider.of<DoctorDetails>(context,listen: false).getDoctorName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                      color: Colors.white),
                ),
                accountEmail: Text(Provider.of<DoctorDetails>(context,listen: false).getEmail,style: TextStyle(
                  fontSize: 19,
                  color: Colors.white
                ),),
                decoration: BoxDecoration(
                    color: Color(0xff674cfb),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(55.0),
                        topRight: Radius.circular(55.0))),
              ),
            ),

          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('DASHBOARD',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboard()));
            },
          ),
          ListTile(
            leading: Icon(Icons.all_inclusive_sharp),
            title: Text('Patient List',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PatientList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.face_unlock_sharp),
            title: Text('PROFILE',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile(admin: true,)));
            },
          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('ADD AN EXERCISE',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadVideo(edit: false,)));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('TERMS AND CONDITIONS',style: TextStyle(
              fontSize: 18,

            ),),
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('LOGOUT',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: ()async{
              CreateUser user= CreateUser();
              bool check =await user.logOut();
              if(check) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              }
            },
            // onTap: ()async{
            //   widget.isLoggedIn= await widget._login.googleSignOut();
            //   setState(() {
            //     if(!widget.isLoggedIn){
            //       Navigator.push(context, ScaleRoute(page: LoginPage()));
            //     }
            //   });
            //},
          ),
        ],
      ),
    );
  }
}
