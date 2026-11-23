import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class StorageService {
  static const String key = 'user_data_list';

  Future<List<UserModel>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null) return [];

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(users.map((e) => e.toMap()).toList());
    await prefs.setString(key, data);
  }
}
