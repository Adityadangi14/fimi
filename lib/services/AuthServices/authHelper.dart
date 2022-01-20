import 'package:fimi/modals/newUserModal.dart';
import 'package:fimi/services/AuthServices/authServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fimi/sharedPreferences/sharePreferences.dart';

import 'package:fimi/services/DatabaseServices/databaseServices.dart';

class AuthHelper {
  final authSerivces = AuthSerivces();
  final googleSighIn = GoogleSignIn(scopes: ['email']);
  DatabaseServices databaseServices = new DatabaseServices();

  NewUserModal newUserModal = new NewUserModal();

  Stream<User?> get currentUser => authSerivces.currentUser;

  logInSignUp() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSighIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final results = await authSerivces.signInWithCredential(credential);

      await SharedPreferencesHelper.saveDisplayNameSharedPrefrences(
          (results.user!.displayName)!);
      await SharedPreferencesHelper.saveUserEmailPrefrences(
          (results.user!.email)!);
      await SharedPreferencesHelper.saveUserPHotoURLPrefrences(
          (results.user!.photoURL)!);
      print('${results.user!.displayName}');
    } catch (error) {
      print(error.toString());
    }
  }

  logOut() {
    authSerivces.logout();
  }
}
