import 'dart:convert';

import 'package:broker/models/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  final SharedPreferences pref;

  SharedPref(this.pref);

  User? getUser(){
    try{
      final String? res = pref.getString(UserPrefKeys.user.toString());
      if(res == null){
        return null;
      }
      return User.fromJson(json.decode(res));
    }catch (e){
      print(e);
      return null;
    }
  }

  Future<bool> setUser(User? user) async {
    if(user == null){
      return pref.remove(UserPrefKeys.user.toString());
    }
    return pref.setString(
        UserPrefKeys.user.toString(), json.encode(user.toJson()));
  }


}

enum UserPrefKeys{user, firstTime, }
