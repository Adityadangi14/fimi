import "package:shared_preferences/shared_preferences.dart";

class SharedPreferencesHelper {
  static String sharedPreferencedDisplayNameKey = 'DISPLAYNAMEKEY';
  static String sharedPreferencesUserNameKey = 'USERNAMEKEY';
  static String sharedPreferencedUserEmailKey = 'USEREMAILKEY';
  static String sharedPreferencedPhotoURLKey = 'PHOTOURLKEY';

  static Future<bool> saveDisplayNameSharedPrefrences(
      String displayName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedDisplayNameKey, displayName);
  }

  static Future<bool> saveUserEmailPrefrences(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedUserEmailKey, email);
  }

  static Future<bool> saveUserPHotoURLPrefrences(String photoURL) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencedPhotoURLKey, photoURL);
  }

  static Future<bool> saveUserNamePrefrences(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferencesUserNameKey, userName);
  }

  static Future<String?> getDisplayNameInSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedDisplayNameKey);
  }

  static Future<String?> getEmailInSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedUserEmailKey);
  }

  static Future<String?> getPhotoURLInSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencedPhotoURLKey);
  }

  static Future<String?> getUserNameSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferencesUserNameKey);
  }
}
