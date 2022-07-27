// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/comment.dart';
import 'package:poetry_publisher/constraint.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';
import 'package:poetry_publisher/screens/single%20Poet/single_poet_kata.dart';
import 'package:poetry_publisher/screens/single%20Poet/single_poetry_gazal.dart';
import 'package:poetry_publisher/screens/widgets/main_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gazal.dart';
import '../kata.dart';
import '../poet_name.dart';
import '../shair.dart';

class single_poet_home extends StatelessWidget {
  String? name;
  single_poet_home({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kcolor,
          title: Text("$name"),
          // leading: ,
          actions: [
            // IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            // IconButton(onPressed: () {}, icon: Icon(Icons.apps_rounded))
          ],
          bottom: TabBar(
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                  fontSize: 18.0, fontFamily: 'Family Name'), //For Selected tab
              unselectedLabelStyle:
                  TextStyle(fontSize: 14.0, fontFamily: 'Family Name'),
              tabs: [
                Tab(
                  text: "شعر",
                ),
                Tab(
                  text: "قطعہ",
                ),
                Tab(
                  text: "غزل",
                ),
                // Tab(
                //   text: "شاعر",
                // ),
                // Tab(
                //   text: "عنوان",
                // )
              ]),
        ),
        body: TabBarView(
          children: [
            single_poetry(
              type: "poetry",
              name: name.toString(),
            ),
            single_poetry(
              type: "kata",
              name: name.toString(),
            ),
            single_poetry(
              type: "gazal",
              name: name.toString(),
            ),
            // P_name(),
            // Center(
            //   child: Text("data4"),
            // )
          ],
        ),
      ),
    );
  }
}

class single_poetry extends StatelessWidget {
  String name
      // id
      ;

  var type;
  single_poetry({
    Key? key,
    required this.type,
    required this.name,
    // required this.id,
  }) : super(key: key);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('post').snapshots();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(name),
        // ),
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
                    if (snapshot.data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      var data;
                      List? like;
                      if (snapshot.data?.docs[index]["p_name"] == "$name" &&
                          snapshot.data?.docs[index]["type"] == "$type") {
                        data = snapshot.data?.docs[index];
                        like = data["like"];
                      }

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
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var login3 = prefs.getString("email");
                                    if (login3 == null) {
                                      Get.to(login());
                                    } else {
                                      // likepost(
                                      //     data.id.toString(), data["like"]);
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
                  });
            }),
      ),
    );
  }
}
