import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/comment.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/signing.dart';
import 'package:poetry_publisher/screens/widgets/main_container.dart';
import 'package:poetry_publisher/tesying.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class shair extends StatelessWidget {
  var uid;

  var type;
  likepost(String postid, List like) async {
    uid = await FirebaseAuth.instance.currentUser!.uid;

    var Firestore = await FirebaseFirestore.instance;
    try {
      if (like.contains(uid)) {
        await Firestore.collection('post').doc(postid).update({
          "like": FieldValue.arrayRemove([uid])
        });
      } else {
        await Firestore.collection('post').doc(postid).update({
          "like": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  shair({Key? key, required this.type}) : super(key: key);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('post').snapshots();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    List? like;
                    like = data!["like"];
                    if (snapshot.data?.docs[index]["type"] == "$type") {
                      return data != null
                          ? Column(
                              children: [
                                maincontainer(
                                  ontap: () {
                                    Get.to(comment(
                                      postid: data.id.toString(),
                                    ));
                                  },
                                  likecount: like!.length.toString(),
                                  icon: Icon(like.contains(uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var login3 = prefs.getString("email");
                                    if (login3 == null) {
                                      Get.to(login());
                                    } else {
                                      likepost(
                                          data.id.toString(), data["like"]);
                                    }
                                  },
                                  poetry: data["poetry"].toString(),
                                  p_name: data["p_name"].toString(),
                                ),
                                // Text("data"),
                                // Text(data.data().toString())
                              ],
                            )
                          : Container();
                    }
                    return Container();
                  }
                });
          }),
      floatingActionButton: float(),
    );
  }
}
