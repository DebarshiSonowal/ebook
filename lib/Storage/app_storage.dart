import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  // shared_preferences
  Storage._();

  static final Storage instance = Storage._();
  late SharedPreferences sharedpreferences;

  Future<void> initializeStorage() async {
    sharedpreferences = await SharedPreferences.getInstance();
  }

  Future<void> setUser(String token) async {
    await sharedpreferences.setString("token", token);
    await sharedpreferences.setBool("isLoggedIn", true);
  }

  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "";
}
