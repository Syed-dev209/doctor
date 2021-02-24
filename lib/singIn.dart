import 'package:doctor/components/alertBox.dart';
import 'package:doctor/controller/createDoctor.dart';
import 'package:doctor/register.dart';
import 'package:doctor/registerDoctor.dart';
import 'package:doctor/screens/adminScreens/adminDashboard.dart';
import 'package:doctor/screens/dashboard.dart';
import 'package:doctor/screens/forgotPassword.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'controller/createUser.dart';
import 'service/pushNotificationService.dart';
import 'service/pushNotificationService.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

//#fbeb58 yellow
//Color(0XFF535a60) black
class _SignInState extends State<SignIn> {
  bool hidepass = true;
  bool admin = true;
  bool user = true;
  int val = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  CreateUser _createuser;
  AlertBoxes _alertBoxes;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    Future<bool> exitWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Confirm Exit?',
              style: new TextStyle(color: Colors.black, fontSize: 20.0)),
          content: new Text(
              'Are you sure you want to exit the app? Tap \'Yes\' to exit \'No\' to cancel.'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                // this line exits the app.
                SystemChannels.platform
                    .invokeMethod('SystemNavigator.pop');
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: WillPopScope(
          onWillPop: exitWillPop,
          child: ProgressHUD(
            child: Builder(
              builder: (context) {
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
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'This is a required field'),
                                EmailValidator(
                                    errorText: 'This is not a Valid Email')
                              ]),
                              cursorColor: Colors.black38,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.black87,
                                  ),
                                  hintText: 'Email',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black87)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _passController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'This is a required field'),
                                LengthRangeValidator(
                                    min: 8,
                                    max: 10,
                                    errorText:
                                        'Your Password should be in the range of 8-10')
                              ]),
                              cursorColor: Colors.black87,
                              obscureText: hidepass,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: showpass,
                                    icon: hidepass
                                        ? Icon(
                                            Icons.visibility_sharp,
                                            color: Colors.black,
                                          )
                                        : Icon(
                                            Icons.visibility_off_sharp,
                                            color: Colors.black,
                                          ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black87,
                                  ),
                                  hintText: 'Password',
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black87)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black87)),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87),
                                    borderRadius: BorderRadius.circular(15.0),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                                    }),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 0,
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        val = value;
                                      });
                                    }),
                                Text(
                                  'Log in as an admin',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: val,
                                    onChanged: (value) {
                                      setState(() {
                                        val = value;
                                      });
                                    }),
                                Text(
                                  'Log in as a patient',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: deviceHeight * 0.32),
                            RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 110, vertical: 20),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 19.0),
                                ),
                                color: Color(0xff0f2594),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                onPressed: () async {
                                  if (_key.currentState.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    _createuser = CreateUser();
                                    if (val == 1) {
                                      ///patient
                                      progress.showWithText('Logging in...');
                                      bool exist = await _createuser
                                          .checkUser(_emailController.text);
                                      if (exist) {
                                        bool check = await _createuser.logInUser(
                                            context,
                                            _emailController.text,
                                            _passController.text);
                                        if (check) {
                                          progress.dismiss();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Dashboard()));
                                        } else {
                                          progress.dismiss();
                                          _alertBoxes = AlertBoxes();
                                          _alertBoxes.simpleAlertBox(
                                              context,
                                              Text('ERROR'),
                                              Text(
                                                  'Something went wrong.\nMake sure you entered correct details.'),
                                              () {
                                            Navigator.pop(context);
                                          });
                                        }
                                      } else {
                                        progress.dismiss();
                                        _alertBoxes = AlertBoxes();
                                        _alertBoxes.simpleAlertBox(
                                            context,
                                            Text('NOT A MEMBER'),
                                            Text(
                                                'You are not registered as a Patient.'),
                                            () {
                                          Navigator.pop(context);
                                        });
                                      }
                                    } else {
                                      ///admin
                                      CreateDoctor _doc = CreateDoctor();
                                      final progress = ProgressHUD.of(context);
                                      progress.showWithText('Logging in...');
                                      bool exist = await _doc
                                          .checkDoctor(_emailController.text);
                                      if (exist) {
                                        bool check = await _doc.logInDoctor(
                                            context,
                                            _emailController.text,
                                            _passController.text);
                                        if (check) {
                                          progress.dismiss();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashboard()));
                                        } else {
                                          progress.dismiss();
                                          _alertBoxes = AlertBoxes();
                                          _alertBoxes.simpleAlertBox(
                                              context,
                                              Text('ERROR'),
                                              Text(
                                                  'Something went wrong.\nMake sure you entered correct details.'),
                                              () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                                          });
                                        }
                                      } else {
                                        progress.dismiss();
                                        _alertBoxes = AlertBoxes();
                                        _alertBoxes.simpleAlertBox(
                                            context,
                                            Text('NOT A MEMBER'),
                                            Text(
                                                'You are not registered as a Doctor.'),
                                            () {
                                          Navigator.pop(context);
                                        });
                                      }
                                    }
                                  }
                                }),
                            SizedBox(
                              width: 250,
                              height: 25,
                              child: Divider(
                                color: Colors.black87,
                              ),
                            ),
                            TextButton(
                                child: Text(
                                  'Don\'t have an account? Sign Up',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                ),
                                onPressed: () {
                                  _alertBoxes = AlertBoxes();
                                  _alertBoxes.ButtonAlertBox(
                                      context: context,
                                      btn1txt: 'Register as Doctor',
                                      btn2txt: 'Register as Patient',
                                      btn1OnPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterDoctor()));
                                      },
                                      btn2OnPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Registrer()));
                                      });
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }

  void showpass() {
    setState(() {
      if (hidepass == true) {
        hidepass = false;
      } else {
        hidepass = true;
      }
    });
  }
}
