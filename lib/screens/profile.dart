import 'package:doctor/components/adminDrawer.dart';
import 'package:doctor/components/drawerItem.dart';
import 'package:doctor/models/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:doctor/components/pickImage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class Profile extends StatefulWidget {
  bool admin;

  Profile({this.admin});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController username = TextEditingController(text: 'Shaikh');
  bool showSpinner = false, imagePicked = false;
  File selectedImage;
  PickImage _pickImage;
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  String text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = username.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        //backgroundColor: Colors.white,
      ),
      drawer: widget.admin ? AdminDrawer() : Draweritem(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<UserDetails>(
          builder: (context, data, child) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Details',style: TextStyle(
                    fontSize: 30.0,
                  ),),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2,
                  ),
                  SizedBox(height: 5.0,),
                  Text('Username',style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black26
                  ),),
                  Text(data.getUserName,style: TextStyle(
                    fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),

                  Text('Email',style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black26
                  ),),
                  Text(data.getEmail,style: TextStyle(
                      fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),
                  Text('Date of Birth',style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black26
                  ),),
                  Text(DateTime.parse(data.getDOB).toLocal().toString().split(' ')[0],style: TextStyle(
                      fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),
                  Text('Weight',style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black26
                  ),),
                  Text(data.getWeight,style: TextStyle(
                      fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),
                  Text('Height',style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black26
                  ),),
                  Text(data.getHeight,style: TextStyle(
                      fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),
                  Text('Disease',style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black26
                  ),),
                  Text(data.getDisease,style: TextStyle(
                      fontSize: 22.0
                  ),
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),
            );
          },
        )),
      ),
    );
  }

  showAlertDialog(BuildContext context, TextEditingController controller) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        // Provider.of<UserDetails>(context, listen: false)
        //     .setUsername(controller.text);
        setState(() {
          text = username.text;
        });

        Navigator.pop(context, controller);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: TextField(controller: controller),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
