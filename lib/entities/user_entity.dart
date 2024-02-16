import 'package:floor/floor.dart';

@entity
class User {
  @primaryKey
  final int id;
  @ColumnInfo(name: 'user_name')
  String userName;
  String email;
  String password;

  User(this.id, this.userName, this.email, this.password);
}
