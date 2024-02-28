import 'package:SnowGauge/utilities/id_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:SnowGauge/dao/user_dao.dart';
import 'package:SnowGauge/entities/user_entity.dart';

class UserViewModel extends ChangeNotifier {
  late UserDao _userDao;
  late User currentUser = User(IdGenerator.generateId(), 'Bob', 'bob@bob.com', 'bobpass');
  String currentUserName = 'Bob'; // hardcoded for now

  // Constructor
  UserViewModel({UserDao? userDao}) {
    // If userDao is provided, use it. Otherwise, get it from GetIt.
    _userDao = userDao ?? GetIt.instance.get<UserDao>();
    _initializeUser();
  }

  // Method to initialize user data
  void _initializeUser() async {
    int? userId = await getUserIdByName(currentUserName);
    if (userId == null) {
      await insertUser(currentUserName, 'bob@bob.com', 'bobpass');
      userId = await getUserIdByName(currentUserName);
    }
    if (userId != null) {
      watchUserById(userId);
    }
  }

  // Method to watch user by user ID
  void watchUserById(int userId) {
    _userDao.watchUserById(userId).listen((user) {
      if (user != null) {
        currentUser = user;
        notifyListeners();
      }
    });
  }

  // Method to get user ID by user name
  Future<int?> getUserIdByName(String userName) {
    return _userDao.getUserIdByName(userName);
  }

  // Method to insert a new user
  Future<void> insertUser(String userName, String email, String password) async {
    User newUser = User(IdGenerator.generateId(), userName, email, password);
    await _userDao.insertUser(newUser);
    notifyListeners();
  }
}
