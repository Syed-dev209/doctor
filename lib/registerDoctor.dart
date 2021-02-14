import 'package:doctor/components/alertBox.dart';
import 'package:doctor/controller/createDoctor.dart';
import 'package:doctor/singIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterDoctor extends StatefulWidget {
  @override
  _RegisterDoctorState createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {
  GlobalKey<FormState> _key=GlobalKey<FormState>();
  TextEditingController _username=TextEditingController();
  TextEditingController _password=TextEditingController();
  TextEditingController _email=TextEditingController();
  bool password =true;
  bool confirmPassword =true;
  CreateDoctor _create;
  AlertBoxes _alert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Registration'),
        centerTitle: true,
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
                        SizedBox(height: 40.0,),

                        RaisedButton(
                            padding:
                            EdgeInsets.symmetric(horizontal: 110, vertical: 20),
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white, fontSize: 19.0),
                            ),
                            color: Color(0xff674cfb),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                            onPressed: () async{
                              if(_key.currentState.validate())
                              {
                                _alert=AlertBoxes();
                                final progress=ProgressHUD.of(context);
                                progress.showWithText('Loading...');
                                _create=CreateDoctor();
                                bool check = await _create.RegisterDoctor(_username.text, _password.text, _email.text);
                                if(check){
                                  progress.dismiss();
                                  _alert.simpleAlertBox(context, Text('CONGRATULATIONS'), Text('You have been registered as a Doctor.'), (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                                  });
                                }
                                else{
                                  _alert.simpleAlertBox(context, Text('ERROR'), Text('Something went wrong.'), (){
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
