import 'package:hive_demo/sampleHiveLogin/models/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DBFunctions {
  //Singleton
  DBFunctions._internal();
  static DBFunctions instance = DBFunctions._internal();

  factory DBFunctions() {
    return instance;
  }
  //Add users
  Future<void> userSignup(UserModel user) async {
    final db = await Hive.openBox<UserModel>('user');
    db.put(user.id, user);
  }

  //getUsers
  Future<List<UserModel>> getUsers() async {
    final db = await Hive.openBox<UserModel>('user');

    return db.values.toList();
  }

}