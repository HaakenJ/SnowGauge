import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../dao/user_dao.dart';
import '../entities/user_entity.dart';

class UserViewModel extends ChangeNotifier {
  late LocalUserDao _userDao;
  late final String _userId;
  late LocalUser currentUser;

  void initModel() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
      _userDao = GetIt.instance.get<LocalUserDao>();
      _userDao.getUserById(_userId).then((user) {
        if (user == null) {
          insertUser(_userId, currentUser!.email!);
        }
        watchUserById(_userId);
      });
    }
  }

  void watchUserById(String id) async {
    _userDao.watchUserById(id).listen((user) {
      if (user != null) {
        currentUser = user;
        notifyListeners();
      }
    });
  }

  Future<void> insertUser(String id, String userName) async {
    LocalUser newUser = LocalUser(id, userName);
    _userDao.insertUser(newUser);
    notifyListeners();
  }
}