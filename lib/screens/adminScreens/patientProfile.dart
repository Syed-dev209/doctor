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
                Text('Email',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                ),),
                Text(email,style: TextStyle(
                    fontSize: 22.0
                ),
                ),
                SizedBox(height: 9.0,),
                Text('Date of Birth',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                ),),
                Text(dob,style: TextStyle(
                    fontSize: 22.0
                ),
                ),
                SizedBox(height: 9.0,),
                Text('Height',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                ),),
                Text(height,style: TextStyle(
                    fontSize: 22.0
                ),
                ),
                SizedBox(height: 9.0,),
                Text('Weight',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                ),),
                Text(weight,style: TextStyle(
                    fontSize: 22.0
                ),
                ),
                SizedBox(height: 9.0,),
                Text('Disease',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                ),),
                Text(disease,style: TextStyle(
                    fontSize: 22.0
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
