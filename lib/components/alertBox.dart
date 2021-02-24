import 'package:doctor/controller/createUser.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertBoxes{
  Future<Widget> simpleAlertBox(context,Text title,Text description,Function onPressed){
    return showDialog(
        context: context,
    builder: (context){
      return AlertDialog(
        title: title,
        content: description,
        actions: [
          TextButton(onPressed: onPressed, child: Text('Ok',style: TextStyle(color: Colors.black),))
        ],
      );
    });
  }

  Future<Widget> ButtonAlertBox({context,String btn1txt,String btn2txt,Function btn1OnPressed,Function btn2OnPressed}){
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('REGISTER AS:'),
            content: Container(
              height: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(btn1txt,style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                    ),),
                    color: Color(0xff0f2594),
                    onPressed: btn1OnPressed,
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                      child: Text(btn2txt,style: TextStyle(
                        color:Color(0xff0f2594),
                          fontSize: 18.0
                      ),),
                      onPressed: btn2OnPressed
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Back',style: TextStyle(color: Colors.black),))
            ],
          );
        });
  }




}