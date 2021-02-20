import 'package:flutter/material.dart';

class PatientProfile extends StatelessWidget {
  String name,email,height,weight,dob,disease;
  PatientProfile({this.name,this.email,this.height,this.weight,this.dob,this.disease});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details',style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Color(0xff674cfb),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold
                ),
                ),
                SizedBox(height: 15.0,),
                Text('Email:- '+email),
                SizedBox(height: 5.0,),
                Text('Date of Birth:- '+dob),
                SizedBox(height: 5.0,),
                Text('Height:- '+height),
                SizedBox(height: 5.0,),
                Text('Weight:- '+weight),
                SizedBox(height: 5.0,),
                Text('Disease:- '+disease)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
