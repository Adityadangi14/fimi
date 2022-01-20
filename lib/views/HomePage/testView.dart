import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fimi/services/DatabaseServices/databaseServices.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';
import 'package:flutter/material.dart';

class TestView extends StatelessWidget {
  const TestView({Key? key}) : super(key: key);

  static DatabaseServices databaseServices = new DatabaseServices();

  getNavtiveUserName() async {
    return await SharedPreferencesHelper.getUserNameSharedPrefrences();
  }

  Future<String> getUser2imageURL() async {
    String? nativeUser = await getNavtiveUserName();
    print('nativeuser++++++' + nativeUser.toString());

    QuerySnapshot user = await databaseServices.searchUsersByUserName(
        "yooaditya_boom"
            .toString()
            .replaceAll(nativeUser!, '')
            .replaceAll('_', ''));
    print('image+++++++' + user.docs[0]['photoURL']);
    return await user.docs[0]['photoURL'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser2imageURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Text(snapshot.data.toString());
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
