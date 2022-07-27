import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poetry_publisher/constraint.dart';
import 'package:poetry_publisher/main.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signnin extends StatefulWidget {
  signnin({Key? key}) : super(key: key);

  @override
  State<signnin> createState() => _signninState();
}

class _signninState extends State<signnin> {
  var name = TextEditingController();

  var password = TextEditingController();

  var email = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _imagee = im;
    });
  }

  Uint8List? _imagee;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: kcolor,
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      _imagee != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_imagee!),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://i.stack.imgur.com/l60Hf.png'),
                              backgroundColor: Colors.red,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 18.0, top: 30, bottom: 30),
                    child: usernaem(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        name: email,
                        hintText: "xyz@gmail.com",
                        labelText: "Enter your Email",
                        prefixIcon: Icons.mail),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 18.0),
                    child: usernaem(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        name: name,
                        hintText: "Talha",
                        labelText: "Enter your Name",
                        prefixIcon: Icons.person),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 18.0, top: 30, bottom: 20),
                    child: user_pass(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "* Required";
                        } else if (value.length < 6) {
                          return "Password should be atleast 6 characters";
                        } else if (value.length > 15) {
                          return "Password should not be greater than 15 characters";
                        } else {
                          return null;
                        }
                      },
                      name: password,
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_imagee == null) {
                              Get.snackbar("Field required", "Select an image");
                            }

                            try {
                              // if (photoUrl == null) {
                              //   Get.snackbar("title", "message");
                              // }
                              ;
                              if (formkey.currentState!.validate()) {
                                EasyLoading.show(status: 'loading...');

                                String photoUrl = await StorageMethods()
                                    .uploadImageToStorage(
                                        'profilePics', _imagee!, false);
                                UserCredential user = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                //   .then((value) async {
                                // print(value.user?.uid.toString());
                                FirebaseFirestore.instance
                                    .collection("user")
                                    .doc(user.user?.uid)
                                    .set({
                                  "email": email.text.trim(),
                                  "password": password.text..trim(),
                                  "uid": user.user?.uid.trim(),
                                  "displayName": name.text..trim(),
                                  "photoUrl": "photoUrl".toString()
                                });
                                // SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                // prefs.setString(
                                //     'email', 'useremail@gmail.com');

                                // var auth = await FirebaseAuth
                                //     .instance.currentUser;

                                // print("${value.user?.email}  credential");
                                // value.additionalUserInfo?.username;
                                // });
                                EasyLoading.dismiss();
                                Get.to(login());
                              }
                              // : print("object");
                            } catch (e) {
                              EasyLoading.dismiss();
                              Get.snackbar("Error", e.toString());
                            }
                          },
                          child: Text("Sign in"))),
                  TextButton(
                      onPressed: () {
                        Get.to(login());
                      },
                      child: Text("Already have an account? "))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    // creating location to our firebase storage
    // try {} catch (e) {}
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    // if(isPost) {
    // String id = const Uuid().v1();
    // ref = ref.child();
    // }

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

class usernaem extends StatelessWidget {
  var validator;

  var onTap;

  var hintText;

  var labelText;

  IconData? prefixIcon;

  usernaem({
    Key? key,
    this.prefixIcon,
    this.hintText,
    this.labelText,
    this.onTap,
    this.validator,
    this.name,
  }) : super(key: key);

  final TextEditingController? name;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onTap: onTap,
      controller: name,
      decoration: InputDecoration(
        hintText: hintText,
        // helperText: '',
        labelText: labelText,

        fillColor: Color.fromARGB(255, 182, 222, 255),
        filled: true,
        hoverColor: Color.fromARGB(255, 0, 140, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        icon: Icon(
          Icons.circle,
          size: 13,
        ),
        prefixIcon: Icon(prefixIcon),
        // suffixIcon: Icon(Icons.nam),
      ),
    );
  }
}

class user_pass extends StatefulWidget {
  var validator;
  user_pass({
    Key? key,
    this.validator,
    required this.name,
  }) : super(key: key);

  final TextEditingController name;

  @override
  State<user_pass> createState() => _user_passState();
}

class _user_passState extends State<user_pass> {
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => setState(() {
        _passwordVisible = !_passwordVisible;
      }),
      validator: widget.validator,
      controller: widget.name,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        hintText: 'abc123',
        // helperText: '',
        labelText: 'Enter Your password',
        fillColor: Color.fromARGB(255, 182, 222, 255),
        filled: true,
        hoverColor: Color.fromARGB(255, 0, 140, 255),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        icon: Icon(
          Icons.circle,
          size: 13,
        ),
        prefixIcon: Icon(Icons.lock),
        suffixIcon:
            Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }
}
