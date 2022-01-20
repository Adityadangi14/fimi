import 'package:fimi/modals/newUserModal.dart';
import 'package:fimi/services/AuthServices/authHelper.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';
import 'package:fimi/views/HomePage/HomePage.dart';
import 'package:fimi/views/newUserInfo/newUserInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fimi/providers/provider.dart';

class LogInSignUp extends StatefulWidget {
  const LogInSignUp({Key? key}) : super(key: key);

  @override
  _LogInSignUpState createState() => _LogInSignUpState();
}

class _LogInSignUpState extends State<LogInSignUp> {
  @override
  void initState() {
    // TODO: implement initState

    AuthHelper authHelper = new AuthHelper();
    authHelper.currentUser.listen((user) async {
      final String? email =
          await SharedPreferencesHelper.getEmailInSharedPrefrences();
  
      if (user != null) {
        screenPicker();
      }
    });

    super.initState();
  }

  screenPicker() async {
    final String? email =
        await SharedPreferencesHelper.getEmailInSharedPrefrences();
    final bool hasUserName =
        await context.read(databaseServicesProvider).doesUserExist(email);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              hasUserName == true ? HomePage() : NewUserInfo()),
    );
  }

  signMeIn() async {
    await context.read(googlelogInProvider).logInSignUp();
    screenPicker();
  }

  @override
  Widget build(BuildContext context) {
    final String vector = 'assets/images/LoginSignUp2.svg';
    final String google = 'assets/images/google.svg';

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 450,
            child: SvgPicture.asset(vector),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Continue with:",
              style:
                  GoogleFonts.raleway(fontSize: 40, color: Color(0xffbd1862)),
            ),
          ),
          InkWell(
            onTap: () {
              signMeIn();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xfff4e89d)),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset(google),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
