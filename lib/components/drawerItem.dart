import 'package:doctor/controller/createUser.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:doctor/screens/allExercises.dart';
import 'package:doctor/screens/dashboard.dart';
import 'package:doctor/screens/profile.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Draweritem extends StatefulWidget {
  @override
  _DraweritemState createState() => _DraweritemState();
}

class _DraweritemState extends State<Draweritem> {
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
                arrowColor: Colors.white,
                accountName: Text(
                  Provider.of<UserDetails>(context,listen: false).getUserName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26.0,
                    color: Colors.white
                  ),
                ),
                accountEmail: Text(Provider.of<UserDetails>(context,listen: false).getEmail,style: TextStyle(
                  fontSize: 21,
                  color: Colors.white
                ),),
                decoration: BoxDecoration(
                    color: Color(0xff674cfb),
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.0),topRight: Radius.circular(50.0))
                ),
              ),
            ),

          ),
          ListTile(
            leading: Icon(Icons.home_filled),
            title: Text('DASHBOARD',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dashboard()));
            },
          ),
          ListTile(
            leading: Icon(Icons.all_inclusive_sharp),
            title: Text('ALL EXERCISES',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: (){
             Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllExercises()));
            },
          ),
          ListTile(
            leading: Icon(Icons.face_unlock_sharp),
            title: Text('PROFILE',style: TextStyle(
              fontSize: 18,

            ),),
            onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(admin: false,)));
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
