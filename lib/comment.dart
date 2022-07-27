import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:poetry_publisher/main.dart';
import 'package:poetry_publisher/screens/Auth%20Screens/login.dart';

class comment extends StatelessWidget {
  String? postid;
  comment({Key? key, this.postid}) : super(key: key);
  var com = TextEditingController();
  String? data;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('post')
              .doc(postid.toString())
              .collection('comments')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, inde) {
                  var data1 = snapshot.data!.docs[inde];
                  return CommentCard(
                    snap: data1,
                  );
                });
          }),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       "https://cdn.dribbble.com/users/1577045/screenshots/4914645/media/028d394ffb00cb7a4b2ef9915a384fd9.png?compress=1&resize=400x300&vertical=top"),
            //   radius: 18,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: com,
                  decoration: InputDecoration(
                    hintText: 'Comment as ',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                if (login3 != null) {
                  var uid = FirebaseAuth.instance.currentUser!.uid;
// FirebaseFirestore.
                  var firestore = FirebaseFirestore.instance;
                  EasyLoading.show();
                  final dat = await firestore.collection("user").doc(uid).get();
                  print(dat.data()!["displayName"]);
                  await firestore
                      .collection('post')
                      .doc(postid.toString())
                      .collection('comments')
                      .add({
                    "photoUrl": dat.data()!["photoUrl"],
                    "comment": com.text.toString(),
                    'datePublished': DateTime.now(),
                    "name": dat.data()!["displayName"]
                  }).then((value) => com.clear());
                  EasyLoading.dismiss();
                } else {
                  EasyLoading.dismiss();
                  Get.to(login());
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return snap == null
        ? CircularProgressIndicator()
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(snap.data()["photoUrl"].toString()),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // RichText(
                        //   text: TextSpan(
                        //     children: [
                        //       TextSpan(
                        //           text: snap.data()['name'],
                        //           style: const TextStyle(
                        //             fontWeight: FontWeight.bold,
                        //           )),
                        //       TextSpan(
                        //         text: ' ${snap}',
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Text(snap.data()['name']),
                        Text(snap.data()['comment']),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            DateFormat.yMMMd().format(
                              snap.data()['datePublished'].toDate(),
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.favorite,
                    size: 16,
                  ),
                )
              ],
            ),
          );
  }
}
