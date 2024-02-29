import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../dao/user_dao.dart';
import '../entities/user_entity.dart';

class UserViewModel extends ChangeNotifier {
  late UserDao _userDao;
  late User currentUser = User(1234, 'Bob', 'bob@bob.com', 'bobpass');
  String currentUserName = 'Bob'; // hardcoded for now TODO: remove hardcoding

  UserViewModel() {
    _userDao = GetIt.instance.get<UserDao>();
    // TODO: update this to user real auth
    _userDao.getUserIdByName(currentUserName).then((id) {
      if (id == null) {
        insertUser(currentUserName, 'bob@bob.com', 'bobpass');
      }
      watchUserByUsername(currentUserName);
    });
  }

  void watchUserByUsername(String userName) async {
    int? userId = await _userDao.getUserIdByName(userName);
    if (userId != null) {
      _userDao.watchUserById(userId).listen((user) {
        if (user != null) {
          currentUser = user;
          notifyListeners();
        }
      });
    }
  }

  Future<int?> getUserIdByName(String userName) {
    return _userDao.getUserIdByName(userName);
  }

  Future<void> insertUser(String userName, String email, String password) async {
    User newUser = User(1234, userName, email, password);
    _userDao.insertUser(newUser);
    notifyListeners();
  }

}