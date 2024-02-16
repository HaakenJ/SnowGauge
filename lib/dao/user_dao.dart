import 'package:floor/floor.dart';
import 'package:SnowGauge/entities/user_entity.dart';

@dao
abstract class UserDao {
  // Create
  @insert
  Future<void> insertUser(User user);

  // Read
  @Query('SELECT * FROM User')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Stream<User?> watchUserById(int id);

  @Query('SELECT id FROM User WHERE user_name = :userName')
  Future<int?> getUserIdByName(String userName);

  // Update
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(User user);

  // Delete
  @delete
  Future<void> deleteUser(User user);
}
