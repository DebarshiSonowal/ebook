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

  Future<void> setReadingBook(int id) async {
    await sharedpreferences.setInt("id", id);
  }


  Future<void> setOnBoarding() async {
    await sharedpreferences.setBool("isOnBoarding", true);
  }

  Future<void> logout() async{
    await sharedpreferences.clear();
  }

  get isLoggedIn => sharedpreferences.getBool("isLoggedIn") ?? false;

  get readingBook => sharedpreferences.getInt("id") ?? 0;

  get isOnBoarding => sharedpreferences.getBool("isOnBoarding") ?? false;

  get token => sharedpreferences.getString("token") ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvdHJhdHJpLmluXC9hcGlcL3N1YnNjcmliZXJzXC9sb2dpbiIsImlhdCI6MTY2Mjk1OTk5NiwiZXhwIjoxNjYyOTYzNTk2LCJuYmYiOjE2NjI5NTk5OTYsImp0aSI6ImZ2MzYwZ09zNGdReVhsWWoiLCJzdWIiOjQsInBydiI6IjdhNTljY2RhNDc0MGVjOGU1ZDRmMGVhOGQyNjQ3YThiYWE3N2FjZGQifQ.2_F9m8Jw7iYj5jfDl24dU83foJxNU9tVzUUjQIvrTtE";
}
