import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/constraint.dart';
import 'package:poetry_publisher/main.dart';
import 'package:poetry_publisher/ruff.dart';

class A_home extends StatelessWidget {
  const A_home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(A_shair());
                  },
                  child: Text("Poetry")),
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(A_gazal());
                  },
                  child: Text("Gazal")),
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(A_kata());
                  },
                  child: Text("Kata")),
            )
          ],
        ),
      ),
    );
  }
}

class A_shair extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  A_shair({Key? key}) : super(key: key);
  var poetry = TextEditingController();
  var name = TextEditingController();
  var unwan = TextEditingController();

  userStore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // String? uid = await FirebaseAuth.instance.currentUser!.uid;

    try {
      await db.collection("post").add({
        "p_name": name.text.trim(),
        "poetry": poetry.text.trim(),
        "unwan": unwan.text.trim(),
        "like": [],
        "uid": {},
        "time": Timestamp.now(),
        "type": "poetry"
      }).then((value) {
        poetry.clear();
        name.clear();
        unwan.clear();
      });
      Fluttertoast.showToast(
          msg: "Posted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("User is register");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("ERROR$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(30.0),
                    // height: size.height * 0.2,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage('assets/frantisek.jpg'),
                        //   fit: BoxFit.fill,
                        // ),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter a valid Poetry';
                            }
                            return null;
                          },
                          controller: poetry,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "Poetry",
                          ),
                          maxLines: null,
                          // maxLength: 8,
                        ))),
                // main_textfield(size: size, name: name, labelText: "poet name"),
                main_textfield(
                  size: size,
                  name: unwan,
                  labelText: "Unwan",
                ),

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('poet_name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return Container(
                        padding: const EdgeInsets.all(30.0),
                        child: DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            hint: Text("Select Poet Name"),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document['p_name'],
                                child: Text(document['p_name']),
                                onTap: () {
                                  name.text = document['p_name'];
                                  print(name.text);
                                },
                              );
                            }).toList(),
                            onChanged: (_) {}),
                      );
                    }),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          EasyLoading.show();

                          await userStore();
                          Get.back();
                          EasyLoading.dismiss();
                        } catch (e) {
                          EasyLoading.dismiss();

                          showSnackBar(context, e.toString());
                        }
                      }
                      // if (_) userStore();
                    },
                    child: Text("Post"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class main_textfield extends StatelessWidget {
  var labelText;

  main_textfield({
    Key? key,
    required this.size,
    required this.labelText,
    required this.name,
  }) : super(key: key);

  final Size size;
  final TextEditingController name;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(30.0),
        // height: size.height * 0.2,
        width: size.width * 0.9,
        decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/frantisek.jpg'),
            //   fit: BoxFit.fill,
            // ),
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'enter a valid name';
                }
                return null;
              },
              controller: name,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: labelText.toString(),
              ),

              maxLines: null,
              // maxLength: 8,
            )));
  }
}

class A_kata extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var unwan = TextEditingController();

  A_kata({Key? key}) : super(key: key);
  var poetry = TextEditingController();
  var name = TextEditingController();

  userStore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // String? uid = await FirebaseAuth.instance.currentUser!.uid;

    try {
      await db.collection("post").add({
        "p_name": name.text.trim(),
        "poetry": poetry.text.trim(),
        "unwan": unwan.text.trim(),
        "like": [],
        "uid": {},
        "time": Timestamp.now(),
        "type": "kata"
      }).then((value) {
        poetry.clear();
        name.clear();
        unwan.clear();
      });
      Fluttertoast.showToast(
          msg: "Posted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("User is register");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("ERROR$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(30.0),
                    // height: size.height * 0.2,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage('assets/frantisek.jpg'),
                        //   fit: BoxFit.fill,
                        // ),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter a valid Poetry';
                            }
                            return null;
                          },
                          controller: poetry,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "Kata",
                          ),
                          maxLines: null,
                          // maxLength: 8,
                        ))),
                // Container(
                //     margin: const EdgeInsets.all(15.0),
                //     padding: const EdgeInsets.all(30.0),
                //     // height: size.height * 0.2,
                //     width: size.width * 0.9,
                //     decoration: BoxDecoration(
                //         // image: DecorationImage(
                //         //   image: AssetImage('assets/frantisek.jpg'),
                //         //   fit: BoxFit.fill,
                //         // ),
                //         color: Colors.white,
                //         border: Border.all(color: Colors.black),
                //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //     child: Directionality(
                //         textDirection: TextDirection.rtl,
                //         child: TextFormField(
                //           validator: (value) {
                //             if (value == null || value.isEmpty) {
                //               return 'enter a valid NAme';
                //             }
                //             return null;
                //           },
                //           controller: name,
                //           keyboardType: TextInputType.multiline,
                //           decoration: const InputDecoration(
                //             border: const UnderlineInputBorder(),
                //             labelText: "Poet Name",
                //           ),

                //           maxLines: null,
                //           // maxLength: 8,
                //         ))),

                main_textfield(
                  size: size,
                  name: unwan,
                  labelText: "Unwan",
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('poet_name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return Container(
                        padding: const EdgeInsets.all(30.0),
                        child: DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            hint: Text("Select Poet Name"),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document['p_name'],
                                child: Text(document['p_name']),
                                onTap: () {
                                  name.text = document['p_name'];
                                  print(name.text);
                                },
                              );
                            }).toList(),
                            onChanged: (_) {}),
                      );
                    }),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          EasyLoading.show();

                          await userStore();
                          EasyLoading.dismiss();

                          Get.back();
                        } catch (e) {
                          EasyLoading.dismiss();

                          showSnackBar(context, e.toString());
                        }
                      }
                    },
                    child: Text("Post"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class A_gazal extends StatelessWidget {
  var unwan = TextEditingController();

  A_gazal({Key? key}) : super(key: key);
  var poetry = TextEditingController();
  var name = TextEditingController();

  userStore() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // String? uid = await FirebaseAuth.instance.currentUser!.uid;

    try {
      await db.collection("post").add({
        "p_name": name.text.trim(),
        "poetry": poetry.text.trim(),
        "unwan": unwan.text.trim(),
        "like": [],
        "time": Timestamp.now(),
        "uid": {},
        "type": "gazal"
      }).then((value) {
        poetry.clear();
        name.clear();
        unwan.clear();
      });
      Fluttertoast.showToast(
          msg: "Posted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("User is register");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("ERROR$e");
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(30.0),
                    // height: size.height * 0.2,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage('assets/frantisek.jpg'),
                        //   fit: BoxFit.fill,
                        // ),
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'enter a valid Poetry';
                            }
                            return null;
                          },
                          controller: poetry,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: const UnderlineInputBorder(),
                            labelText: "Gazal",
                          ),
                          maxLines: null,
                          // maxLength: 8,
                        ))),
                // Container(
                //     margin: const EdgeInsets.all(15.0),
                //     padding: const EdgeInsets.all(30.0),
                //     // height: size.height * 0.2,
                //     width: size.width * 0.9,
                //     decoration: BoxDecoration(
                //         // image: DecorationImage(
                //         //   image: AssetImage('assets/frantisek.jpg'),
                //         //   fit: BoxFit.fill,
                //         // ),
                //         color: Colors.white,
                //         border: Border.all(color: Colors.black),
                //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
                //     child: Directionality(
                //         textDirection: TextDirection.rtl,
                //         child: TextFormField(
                //           validator: (value) {
                //             if (value == null || value.isEmpty) {
                //               return 'enter a valid Name';
                //             }
                //             return null;
                //           },
                //           controller: name,
                //           keyboardType: TextInputType.multiline,
                //           decoration: const InputDecoration(
                //             border: const UnderlineInputBorder(),
                //             labelText: "Poet Name",
                //           ),

                //           maxLines: null,
                //           // maxLength: 8,
                //         ))),
                main_textfield(
                  size: size,
                  name: unwan,
                  labelText: "Unwan",
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('poet_name')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );

                      return Container(
                        padding: const EdgeInsets.all(30.0),
                        child: DropdownButtonFormField(
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            hint: Text("Select Poet Name"),
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document['p_name'],
                                child: Text(document['p_name']),
                                onTap: () {
                                  name.text = document['p_name'];
                                  print(name.text);
                                },
                              );
                            }).toList(),
                            onChanged: (_) {}),
                      );
                    }),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          EasyLoading.show();
                          await userStore();
                          EasyLoading.dismiss();
                          Get.back();
                        } catch (e) {
                          EasyLoading.dismiss();

                          showSnackBar(context, e.toString());
                        }
                      }
                    },
                    child: Text("Post"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
