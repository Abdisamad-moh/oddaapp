import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/preferences.dart';

class AuthService extends GetxService {
  final _box = GetStorage();
  late bool isLogin;
  late int steps;
  String? deviceToken;
  late bool isOnboarded;

  AuthService() {
    checkUserLogin();
  }

  Future<AuthService> init() async {
    checkUserLogin();
    return this;
  }
  void checkUserLogin() {
    bool hasData = _box.hasData(SharedPref.isLogin);
    if (kDebugMode) {
      print("User Logged In =====> $hasData");
    }
    if (hasData) {
      isLogin = true;
    } else {
      isLogin = false;
    }

  }
  Future  saveCountryCode(String key,String value){
    return _box.write(key, value);
  }
   dynamic getCountryCode(String key){
    return _box.read(key);
  }


  Future removeUser() async {
    await _box.remove(SharedPref.isLogin);
    await _box.remove('mDateKey');
  }

  Future setUserLogin() async {
    
    await _box.write(SharedPref.isLogin, "true");
  }


  bool get isLoginn => isLogin;

}
