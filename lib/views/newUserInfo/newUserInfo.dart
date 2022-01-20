import 'package:flutter/material.dart';
import 'package:fimi/providers/provider.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fimi/views/HomePage/HomePage.dart';

class NewUserInfo extends StatelessWidget {
  const NewUserInfo({Key? key}) : super(key: key);

  static TextEditingController userNameController = new TextEditingController();

  static String? photoURL;
  final String photoURL2 =
      'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png';

  getPhotoURL() async {
    photoURL = await SharedPreferencesHelper.getPhotoURLInSharedPrefrences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              height: 80,
              width: 80,
              child: CircleAvatar(
                child: Image.network(
                  photoURL != null ? photoURL! : photoURL2,
                ),
              ),
            ),
          ),
          Container(
            width: 250,
            child: TextField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'Enter a Username',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                final email =
                    await SharedPreferencesHelper.getEmailInSharedPrefrences();
                final displayName = await SharedPreferencesHelper
                    .getDisplayNameInSharedPrefrences();
                final photoURL = await SharedPreferencesHelper
                    .getPhotoURLInSharedPrefrences();
                SharedPreferencesHelper.saveUserNamePrefrences(
                    userNameController.text);

                Map<String, String?> userMap = {
                  'email': email,
                  'userName': userNameController.text,
                  'photoURL': photoURL,
                  'displayName': displayName
                };

                context.read(databaseServicesProvider).uploadUserData(userMap);

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text("Continue"))
        ],
      ),
    ));
  }
}
