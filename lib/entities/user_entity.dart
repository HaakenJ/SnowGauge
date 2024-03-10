import 'package:floor/floor.dart';

@entity
class LocalUser {
  @primaryKey
  final String id;
  @ColumnInfo(name: 'user_name')
  String userName;

  LocalUser(this.id, this.userName);
}
