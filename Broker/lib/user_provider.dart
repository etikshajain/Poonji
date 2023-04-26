import 'package:broker/db.dart';
import 'package:broker/models/entities/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  final SharedPref pref;

  UserProvider(this.pref){
    final u = pref.getUser();
    _user = u ?? User.empty;
    notifyListeners();
  }

  User _user = User.empty;

  Future<void> setUser(User user) async{
    await pref.setUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> clearUser()async{
    await pref.setUser(null);
    _user = User.empty;
    notifyListeners();
  }

  bool get isLoggedIn => _user != User.empty;

  User get user => _user;


}
