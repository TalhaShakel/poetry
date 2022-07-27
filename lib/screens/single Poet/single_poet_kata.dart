import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poetry_publisher/screens/widgets/main_container.dart';

class single_poetry_kata extends StatelessWidget {
  String name
      // id
      ;
  single_poetry_kata({
    Key? key,
    required this.name,
    // required this.id,
  }) : super(key: key);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('kata').snapshots();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
          
          body: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc, doc2;

                      print("${snapshot.data!.docs[index]["poetry"]}");
                      if (snapshot.data!.docs[index]["p_name"] == name.trim()) {
                        doc = snapshot.data!.docs[index];
                      }
                      return doc != null
                          ? maincontainer(
                              poetry: doc["poetry"], p_name: doc?["p_name"])
                          : Container();
                    });

               
              })),
    );
  }
}
