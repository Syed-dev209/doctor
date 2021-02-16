import 'package:doctor/components/alertBox.dart';
import 'package:doctor/controller/createUser.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email= TextEditingController();
  TextEditingController _password= TextEditingController();
  bool password =true;
  GlobalKey<FormState> _key= GlobalKey<FormState>();
  CreateUser _createUser;
  AlertBoxes _alertBoxes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Forgot Password', style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black87),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context){
            return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
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
                          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                          RaisedButton(
                              padding:
                              EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                              child: Text(
                                'Change',
                                style: TextStyle(color: Colors.white, fontSize: 20.0),
                              ),
                              color: Color(0xff674cfb),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19),
                              ),
                              onPressed: () async{
                                if(_key.currentState.validate())
                                {
                                  final progress=ProgressHUD.of(context);
                                  progress.showWithText('Updating...');
                                  _createUser=CreateUser();
                                  bool check= await _createUser.changePassword( _email.text);
                                  if(check){
                                    progress.dismiss();
                                    _alertBoxes=AlertBoxes();
                                    _alertBoxes.simpleAlertBox(context, Text('Email send successfully'), Text('Password reset email has been send to your given email.'), (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                                    });

                                  }
                                  else{
                                    _alertBoxes=AlertBoxes();
                                    progress.dismiss();
                                    _alertBoxes.simpleAlertBox(context, Text('Something went wrong'), Text('Please try again later or check you have used correct email address.'), (){
                                      Navigator.pop(context);
                                    });
                                  }
                                }
                              }
                            )
                        ],
                      ),
                    ),
                  ),
                )
            );
          },
        ),
      ),
    );
  }
}
