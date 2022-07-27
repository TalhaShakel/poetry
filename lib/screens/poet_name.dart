import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poetry_publisher/screens/single%20Poet/single_poet.dart';

class P_name extends StatelessWidget {
  P_name({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('poet_name').snapshots();
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

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2.75,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 2,
                    crossAxisCount: 3),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data?.docs[index];

                  return InkWell(
                    onTap: () {
                      Get.to(single_poet_home(
                        name: data?["p_name"],
                      ));
                    },
                    child: Card(
                      elevation: 2,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Center(
                          child: Text(
                            "${data?["p_name"]}".trim(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
