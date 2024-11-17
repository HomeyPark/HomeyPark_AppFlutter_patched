import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  SharedPreferences? _preferences;
  int userId = 0;

  Future<SharedPreferences?> get preferences async {
    _preferences = await SharedPreferences.getInstance();
    userId = _preferences?.getInt("userId") ?? 0;
    return _preferences;
  }

  Future<Preferences> init() async {
    _preferences = await preferences;
    return this;
  }

  Future<void> saveUserId(int id) async {
    await _preferences?.setInt("userId", id);
  }

  Future<int> getUserId() async {
    return _preferences?.getInt("userId") ?? 0;
  }

  Future<void> deleteUserId() async {
    await _preferences?.remove("userId");
  }
}

final preferences = Preferences();
