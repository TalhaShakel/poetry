import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:poetry_publisher/admin_panel/ad_home.dart';
import 'package:poetry_publisher/comment.dart';
import 'package:poetry_publisher/main.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';
import 'package:poetry_publisher/screens/widgets/main_container.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class test extends StatefulWidget {
  test({Key? key}) : super(key: key);

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  // var isLiked2 = false;

  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('gazal').snapshots();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];
                  int _itemCount = data!["like"];
                  // bool uuid = data["ll"];

                  var userrid = FirebaseAuth.instance.currentUser!.uid;

                  Map key = data["uid"];
                  int buttonSelected = 1;

                  print(key.keys != userrid ? "object" : "talh");
                  print(userrid);

                  return maincontainer2(
                      icon: Icon(key.keys.isEmpty
                          ? Icons.favorite_border
                          : data["uid.$userrid"] == false
                              ? Icons.favorite
                              : Icons.favorite_border),
                      onPressed: () async {
                        var store = await FirebaseFirestore.instance;
                        Map uid = data["uid"];
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        var login3 = prefs.getString("email");
                        print("object");
                        if (login3 == null) {
                          Get.to(login());
                        } else {
                          try {
                            if (data["uid"]["$userrid"] == false) {
                              _itemCount--;

                              await store
                                  .collection("gazal")
                                  .doc(data.id)
                                  .update({
                                "like": _itemCount,
                                "uid.$userrid": true
                              });
                            } else if (data["uid"]["$userrid"] == true ||
                                uid.keys != userrid) {
                              _itemCount++;
                              await store
                                  .collection("gazal")
                                  .doc(data.id)
                                  .update({
                                "like": _itemCount,
                                "uid.$userrid": false
                              });
                            }
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      poetry: data["poetry"].toString(),
                      p_name: data["p_name"].toString());
                });
          }),
    );
  }
}

// class comment extends StatelessWidget {
//   comment({Key? key}) : super(key: key);
//   var com = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//       height: 100,
//       child: CommentBox(
//         image: Image.asset(
//           "assets/frantisek.jpg",
//           height: 64,
//           width: 64,
//         ),
//         controller: com,
//         onImageRemoved: () {
//           //on image removed
//         },
//         onSend: () {
//           //on send button pressed
//           print(com.text);
//         },
//       ),
//     ));
//   }
// }

class maincontainer2 extends StatelessWidget {
  String poetry;

  String p_name;

  var onPressed;

  var icon;

  // var onTap;

  var child;

  maincontainer2(
      {Key? key,
      required this.poetry,
      required this.p_name,
      this.icon,
      this.child,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(15.0),
      // padding: const EdgeInsets.all(3.0),
      // height: size.height * 0.2,
      width: size.width * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Center(
                child: Text(
                  poetry,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Text(
                p_name,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/henry.jpg'),
                  fit: BoxFit.fill,
                ),
                color: Color.fromARGB(255, 0, 0, 0),
                border: Border.all(color: Color.fromARGB(255, 217, 214, 214)),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: onPressed, icon: icon),
                Container(
                  child: child,
                ),
                IconButton(
                    onPressed: () {
                      Share.share("${poetry}\n\t\t${p_name}");
                    },
                    icon:
                        Icon(Icons.share, color: Color.fromARGB(255, 0, 0, 0))),
                IconButton(
                    onPressed: () {
                      print("object");
                      Clipboard.setData(
                              ClipboardData(text: "${poetry}\n\t\t${p_name} "))
                          .then((value) => Fluttertoast.showToast(
                              msg: "Copied",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 6,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0));
                    },
                    icon:
                        Icon(Icons.copy, color: Color.fromARGB(255, 0, 0, 0))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class float extends StatelessWidget {
  const float({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpeedDial(
        // onPress: () {
        //   print("object");
        // },
        // animatedIcon: AnimatedIcons.event_add,
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: Icon(Icons.book),
              label: "شعر",
              onTap: () {
                if (login3 != null) {
                  Get.to(A_shair());
                } else {
                  Get.to(login());
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.book),
              label: "غزل",
              onTap: () {
                if (login3 != null) {
                  Get.to(A_gazal());
                } else {
                  Get.to(login());
                }
              }),
          SpeedDialChild(
              child: Icon(Icons.book),
              label: "قطعہ",
              onTap: () {
                if (login3 != null) {
                  Get.to(A_kata());
                } else {
                  Get.to(login());
                }
                // Get.to(A_kata());
              }),
        ],
      ),
    );
  }
}
