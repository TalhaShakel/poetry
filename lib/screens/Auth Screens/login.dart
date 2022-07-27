import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/ruff.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/signing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class login extends StatelessWidget {
  var Email = TextEditingController();

  var name = TextEditingController();

  var password = TextEditingController();

  login({
    Key? key,
  }) : super(key: key);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: 18.0,
                    top: MediaQuery.of(context).size.height * 0.35,
                    bottom: 30),
                child: usernaem(
                    validator: (value) {
                      if (value.isEmpty) {
                        return "* Required";
                      } else
                        return null;
                    },
                    name: Email,
                    hintText: "xyz@gmail.com",
                    labelText: "Enter your Email",
                    prefixIcon: Icons.mail),
              ),
              Padding(
                padding: EdgeInsets.only(right: 18.0, top: 0, bottom: 20),
                child: user_pass(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "* Required";
                    } else if (value.length < 6) {
                      return "Password should be atleast 6 characters";
                    } else if (value.length > 15) {
                      return "Password should not be greater than 15 characters";
                    } else
                      return null;
                  },
                  name: password,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          try {
                            EasyLoading.show(status: 'loading...');
                            var auth = FirebaseAuth.instance;
                            await auth
                                .signInWithEmailAndPassword(
                                    email: Email.text, password: password.text)
                                .then((value) async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              prefs.setString(
                                  'email', '${auth.currentUser!.email}');
                            }).then((value) {
                              EasyLoading.dismiss();
                              Get.to(ruff());
                            });
                            //   fontSize: 16.0);
                          } catch (e) {
                            EasyLoading.dismiss();
                            Get.snackbar(
                              "Error",
                              e.toString(),
                            );
                          }
                        }
                      },
                      child: Text("Login"))),
              TextButton(
                  onPressed: () {
                    Get.to(signnin());
                  },
                  child: Text("Create an account? "))
            ],
          ),
        ),
      ),
    );
  }
}
