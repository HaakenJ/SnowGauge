import 'package:floor/floor.dart';
import 'package:SnowGauge/entities/user_entity.dart';

@dao
abstract class LocalUserDao {
  // Create
  @insert
  Future<void> insertUser(LocalUser user);

  // Read
  @Query('SELECT * FROM LocalUser')
  Future<List<LocalUser>> getAllUsers();

  @Query('SELECT * FROM LocalUser WHERE id = :id')
  Stream<LocalUser?> watchUserById(String id);

  @Query('SELECT id FROM LocalUser WHERE user_name = :userName')
  Future<String?> getUserIdByName(String userName);

  @Query('SELECT * FROM LocalUser WHERE id = :id')
  Future<LocalUser?> getUserById(String id);

  // Update
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(LocalUser user);

  // Delete
  @delete
  Future<void> deleteUser(LocalUser user);

  @Query('DELETE FROM LocalUser')
  Future<void> deleteAllUsers();
}
