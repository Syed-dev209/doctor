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
    // String text = Provider.of<UserDetails>(context).getUserName??'Khattak';
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      drawer: widget.admin ? AdminDrawer() : Draweritem(),
      body: SafeArea(
        child: SingleChildScrollView(child: Consumer<UserDetails>(
          builder: (context, data, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(
                child: Container(
                  height: 500.0,
                  child: Stack(
                    fit: StackFit.loose,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                            elevation: 10,
                            child: Container(
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        data.getUserName,
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          showAlertDialog(context, username);
                                        },
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 31.0,
                                        width: 300,
                                        child: Divider(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        data.getEmail,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black38),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        data.getWeight,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black38),
                                      ),

                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        data.getHeight,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black38),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        data.getDisease,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black38),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 130.0),
                        child: Center(
                          child: Container(
                            width: 110.0,
                            height: 120.0,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                    radius: 55.0,
                                    backgroundImage: imagePicked
                                        ? FileImage(selectedImage)
                                        : NetworkImage(
                                            'http://www.pngmart.com/files/7/Red-Smoke-Transparent-Images-PNG.png')
                                    //  backgroundColor: Colors.white,

                                    ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: GestureDetector(
                                      onTap: () async {
                                        _pickImage = PickImage();
                                        final image =
                                            await _pickImage.chooseImage();
                                        setState(() {
                                          imagePicked = true;
                                          selectedImage = image;
                                        });
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
