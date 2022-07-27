import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/ruff.dart';
import 'package:poetry_publisher/screens/widgets/profile_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatelessWidget {
  late String name, email, photoUrl;

  profile({
    Key? key,
    required this.name,
    required this.email,
    required this.photoUrl,
  }) : super(key: key);
  userprofile() async {
    final userData = await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print(userData.data());

    userData.data();
  }

  @override
  Widget build(BuildContext context) {
    var name1 = TextEditingController();
    var email1 = TextEditingController();
    name1.text = name;
    email1.text = email;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(78.0),
                child: Container(
                  width: 100,
                  height: 100,
                  // margin:  EdgeInsets.only(top: 20, bottom: 10),
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(photoUrl != null
                            ? photoUrl.toString()
                            : "https://e7.pngegg.com/pngimages/643/98/png-clipart-computer-icons-avatar-mover-business-flat-design-corporate-elderly-care-microphone-heroes-thumbnail.png"),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: profile_textfield(
                  prefixIcon: Icons.person,
                  name: name1,
                  labelText: "Name",
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18.0, 0, 18, 0),
                child: profile_textfield(
                  prefixIcon: Icons.mail,
                  name: email1,
                  labelText: "Email",
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.all(38.0),
                child: Container(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.remove('email').then((value) async {
                            await FirebaseAuth.instance.signOut();
                          });
                          await Future.delayed(Duration(seconds: 2))
                              .then((value) => Get.to(ruff()));
                        },
                        child: Text("Log Out"))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
