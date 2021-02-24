import 'package:doctor/components/alertBox.dart';
import 'package:flutter/material.dart';
import 'components/datePicker.dart';
import 'dart:io' show Platform;
import 'singIn.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'controller/createUser.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
class Registrer extends StatefulWidget {
  @override
  _RegistrerState createState() => _RegistrerState();
}

class _RegistrerState extends State<Registrer> {
  bool password =true;
  bool confirmPassword =true;
  DatePickers _selectDates = DatePickers();
  DateTime selectedDate= DateTime.now();
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  TextEditingController _username=TextEditingController();
  TextEditingController _password=TextEditingController();
  TextEditingController _weight=TextEditingController();
  TextEditingController _height=TextEditingController();
  TextEditingController _disease=TextEditingController();
  TextEditingController _email=TextEditingController();
  CreateUser _createUser;
  AlertBoxes _alertBoxes;
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Patient Registration',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context)
          {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                  child: Form(
                    key: _key,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        TextFormField(
                          controller: _username,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),

                          ]),
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.pregnant_woman_outlined,color: Colors.black,),
                              hintText: 'Username',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required field'),
                            EmailValidator(errorText: 'This is not a valid Email')
                          ]),
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.black87,
                              ),
                              hintText: 'Email',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _password,
                          keyboardType: TextInputType.visiblePassword,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),
                            LengthRangeValidator(min: 8, max: 10, errorText: 'Your password should be in the range of 8-10')
                          ]),
                          obscureText: password,
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      password=!password;
                                    });
                                  },
                                  icon: password? Icon(Icons.visibility_sharp,
                                    color: Colors.black87,):Icon(Icons.visibility_off_sharp,
                                    color: Colors.black87,)
                              ),
                              prefixIcon: Icon(Icons.lock_outline_sharp,color: Colors.black,),
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),
                            LengthRangeValidator(min: 8, max: 10, errorText: 'Your password should be in the range of 8-10')
                          ]),
                          obscureText: password,
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: (){
                                    setState(() {
                                      confirmPassword=!confirmPassword;
                                    });
                                  },
                                  icon:confirmPassword? Icon(Icons.visibility_sharp,
                                    color: Colors.black87,):Icon(Icons.visibility_off_sharp,
                                    color: Colors.black87,)
                              ),
                              prefixIcon: Icon(Icons.lock_outline_sharp,color: Colors.black,),
                              hintText: 'Confirm Password',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(4.0)
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(
                              vertical: 7.0,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${selectedDate.toLocal()}".split(' ')[0],
                                  style:
                                  TextStyle(color: Colors.black45, fontSize: 16.0),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                            //color: Colors.white,
                            onPressed: () async {
                              if (Platform.isAndroid) {
                                DateTime picked =
                                await _selectDates.selectDateAndroid(context);
                                if (picked == null) {
                                  picked = DateTime.now();
                                }
                              } else if (Platform.isIOS) {
                                DateTime picked =
                                await _selectDates.selectDateIOS(context, (date) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                });
                                if (picked == null) {
                                  picked = DateTime.now();
                                }
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _height,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),

                          ]),
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.height,color: Colors.black,),
                              hintText: 'Height',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _weight,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),

                          ]),
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.pregnant_woman_outlined,color: Colors.black,),
                              hintText: 'Weight',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _disease,
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'This is a Required  field'),

                          ]),
                          cursorColor: Colors.black87,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.medical_services_outlined,color: Colors.black,),
                              hintText: 'Disease',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black87)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                                borderRadius: BorderRadius.circular(15.0),
                              )),
                        ),
                        SizedBox(height: deviceHeight * 0.2),
                        RaisedButton(
                            padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                            color: Color(0xff0f2594),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                            onPressed: () async{
                              if(_key.currentState.validate())
                              {
                                final progress=ProgressHUD.of(context);
                                progress.showWithText('Loading...');
                                _createUser=CreateUser();
                                bool check = await _createUser.RegisterPatient(_username.text, _password.text, _height.text, _email.text, selectedDate.toString(), _weight.text, _disease.text);
                                if(check){
                                  progress.dismiss();
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                                }
                                else{
                                  _alertBoxes=AlertBoxes();
                                  progress.dismiss();
                                  _alertBoxes.simpleAlertBox(context, Text('Something went wrong'), Text('Please try again later'), (){
                                    Navigator.pop(context);
                                  });
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
