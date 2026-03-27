import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper {
  static String userIdKey="USERKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY";
  static String userImagekey="USERIMAGEKEY";
  static String userDisplayNamekey="USERDISPLAYKEY";

  
  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserOriginalName(String getUserDisplayName) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userDisplayNamekey, getUserDisplayName);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUserName); 
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUserEmail); 
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<bool> clearUserInfo() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    return prefs.clear();
  }
}